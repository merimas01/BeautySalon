import 'package:flutter/material.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class RezervacijePage extends StatefulWidget {
  static const String routeName = "/reservation";
  const RezervacijePage({super.key});

  @override
  State<RezervacijePage> createState() => _RezervacijePageState();
}

class _RezervacijePageState extends State<RezervacijePage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Zakažite termin",
        child: Container(
          width: 800,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Text(
                      "Zakazite Vas termin u par koraka!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'BeckyTahlia',
                          fontSize: 26,
                          color: Colors.pinkAccent),
                    ),
                  ),
                  _makeAReservation()
                ],
              ),
            ),
          ),
        ));
  }

  DateTime? selectedDate;

  final DateTime nextYear = DateTime(DateTime.now().year + 1);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date
      firstDate: DateTime.now(), // Earliest date
      lastDate: nextYear, // Latest date
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Update the selected date
      });
    }
  }

  String? selectedValue; // Selected item value
  List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  _makeAReservation() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                  ),
                  onPressed: () => _selectDate(context),
                  child: Text(
                      selectedDate == null
                          ? 'Izaberite datum'
                          : 'Datum: ${formatDate(selectedDate!)}',
                      style: TextStyle(fontSize: 18)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Izaberite uslugu:", style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedValue,
                  hint:
                      Text('Select an option', style: TextStyle(fontSize: 18)),
                  dropdownColor:
                      Colors.grey[200], // Background color of dropdown
                  style: TextStyle(
                      color: Colors.black, fontSize: 16), // Text style
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.blue), // Custom icon
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Izaberite termin:", style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedValue, // Current selected value
                  hint: Text('Select an option',
                      style: TextStyle(fontSize: 18)), // Placeholder text
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue; // Update selected value
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {},
                    child:
                        Text("Zakazite termin", style: TextStyle(fontSize: 18)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _odaberiUslugu() {
    return Row(
      children: [
        Expanded(
          child: FormBuilderDropdown<String>(
            name: 'uslugaId',
            decoration: InputDecoration(
              labelText: 'Usluge',
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState!.fields['uslugaId']?.reset();
                },
              ),
              hintText: 'Odaberite uslugu',
            ),
            onChanged: (x) async {
              setState(() {
                selectedUslugaId = x;
                isLoadingTermin = true;
                _terminResult = null;
              });
              var termini = await _uslugaTerminProvider
                  .get(filter: {'uslugaId': x, 'isPrikazan': true});
              print(termini.result[0].termin?.opis);
              setState(() {
                isLoadingTermin = false;
                _terminResult = termini;
              });
            },
            items: _uslugaResult?.result
                    .map((item) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: item.uslugaId.toString(),
                          child: Text(item.naziv ?? ""),
                        ))
                    .toList() ??
                [],
            validator: (value) {
              if (value == null) {
                return 'Molimo Vas izaberite uslugu';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _odaberiTermin() {
    return Row(
      children: [
        Expanded(
          child: FormBuilderDropdown<String>(
            name: 'terminId',
            decoration: InputDecoration(
              labelText: 'Termini',
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState!.fields['terminId']?.reset();
                },
              ),
              hintText: 'Odaberite termin',
            ),
            onChanged: (x) async {
              setState(() {
                selectedTerminId = x;
              });
              // setState(() {
              //   selectedUslugaId = x;
              //   isLoadingTermin=true;
              //   _terminResult=null;
              // });
              //    var termini = await _uslugaTerminProvider.get(filter: {
              //     'uslugaId': x,
              //     'isPrikazan': true
              //   });
              //   print(termini.result[0].termin?.opis);
              //   setState(() {
              //     isLoadingTermin = false;
              //     _terminResult = termini;
              //   });
            },
            items: _terminResult?.result
                    .map((item) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: item.uslugaId.toString(),
                          child: Text(item.termin?.opis ?? ""),
                        ))
                    .toList() ??
                [],
            validator: (value) {
              if (value == null) {
                return 'Molimo Vas izaberite termin';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
