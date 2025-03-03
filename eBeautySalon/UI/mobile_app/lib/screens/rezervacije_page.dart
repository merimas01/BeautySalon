import 'package:flutter/material.dart';
import 'package:mobile_app/models/rezervacija.dart';
import 'package:mobile_app/models/rezervacija_insert.dart';
import 'package:mobile_app/providers/rezervacije_provider.dart';
import 'package:mobile_app/screens/moje_rezervacije.dart';
import 'package:mobile_app/screens/paypal_page.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/usluge_provider.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class RezervacijePage extends StatefulWidget {
  static const String routeName = "/reservation";
  const RezervacijePage({super.key});

  @override
  State<RezervacijePage> createState() => _RezervacijePageState();
}

class _RezervacijePageState extends State<RezervacijePage> {
  late UslugeProvider _uslugaProvider;
  late RezervacijeProvider _rezervacijeProvider;
  bool isLoadingData = true;
  bool isLoadingTermin = true;
  dynamic selectedTerminZaUslugu;
  List<dynamic> terminiZaUslugu = [];
  Usluga? selectedUsluga;
  SearchResult<Usluga>? _uslugaResult;
  Rezervacija? lastRezervacija;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _uslugaProvider = context.read<UslugeProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    initForm();
  }

  Future initForm() async {
    var usluge = await _uslugaProvider.get();
    var del = await _rezervacijeProvider.DeleteUnpaidReservactions();

    setState(() {
      isLoadingData = false;
      _uslugaResult = usluge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 2,
      title: "Zakažite termin",
      child: Container(
        width: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: Text(
                    "Zakažite Vaš termin u par koraka!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        //fontFamily: 'BeckyTahlia',
                        fontSize: 26,
                        color: Colors.pinkAccent),
                  ),
                ),
                _makeAReservation(),
                lastRezervacija != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "*Pritiskom na dugme ispod izvršavate plaćanje. Ukoliko to ne uradite, Vaša rezervacija se briše.",
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    : Text(""),
                lastRezervacija != null ? _plati() : Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectTermin(List<dynamic> termini) {
    if (isLoadingTermin == false && termini != null) {
      return Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              hint: Text("Odaberi termin"),
              value: selectedTerminZaUslugu,
              isExpanded: true,
              onChanged: (dynamic newValue) {
                setState(() {
                  selectedTerminZaUslugu = newValue;
                });
                print("termin: $selectedTerminZaUslugu");
              },
              items: termini.map<DropdownMenuItem<dynamic>>((dynamic service) {
                return DropdownMenuItem<dynamic>(
                  value: service,
                  enabled: service['zauzet'] == false ? true : false,
                  child: Text(
                    service['termin'] ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: service['zauzet'] == false
                            ? Colors.green
                            : Colors.red),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget selectUsluga() {
    if (isLoadingData == false) {
      return Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Usluga>(
              hint: Text("Odaberi uslugu"),
              value: selectedUsluga,
              isExpanded: true,
              onChanged: (Usluga? newValue) async {
                setState(() {
                  selectedUsluga = null;
                  selectedTerminZaUslugu = null;
                  isLoadingTermin = true;
                  terminiZaUslugu = [];
                });

                var dataTermini =
                    await _rezervacijeProvider.GetTerminiZaUsluguIDatum(
                        newValue!.uslugaId!, selectedDate!);

                setState(() {
                  isLoadingTermin = false;
                  terminiZaUslugu = dataTermini;
                  selectedUsluga = newValue;
                });
                print(
                    "usluga: ${selectedUsluga?.uslugaId} ${selectedUsluga?.naziv}");
              },
              items: _uslugaResult?.result
                  .map<DropdownMenuItem<Usluga>>((Usluga service) {
                return DropdownMenuItem<Usluga>(
                  value: service,
                  child: Text(
                    service.naziv!,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
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

  _makeAReservation() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  "*Prvo izaberite datum koji želite rezervisati. Potom izaberite uslugu, zatim termin odnosno vrijeme u kojem želite biti usluženi." +
                      "\nNapomena: Možete zakazati samo jednu uslugu na jedan dan.",
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.justify,
                ),
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
                selectedDate != null
                    ? Text("Izaberite uslugu:", style: TextStyle(fontSize: 18))
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                selectedDate != null ? selectUsluga() : Container(),
                SizedBox(
                  height: 20,
                ),
                selectedUsluga != null
                    ? Text("Izaberite termin:", style: TextStyle(fontSize: 18))
                    : Text(""),
                SizedBox(
                  height: 10,
                ),
                isLoadingTermin == false && terminiZaUslugu != []
                    ? selectTermin(terminiZaUslugu)
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedDate != null &&
                            selectedUsluga != null &&
                            selectedTerminZaUslugu != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green[400], // Background color
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12), // Optional: Adjust padding
                            ),
                            onPressed: () async {
                              if (selectedDate != null &&
                                  selectedUsluga != null &&
                                  selectedTerminZaUslugu != null) {
                                try {
                                  var request = RezervacijaInsert(
                                    LoggedUser.id,
                                    selectedUsluga!.uslugaId,
                                    selectedTerminZaUslugu['terminId'],
                                    selectedDate,
                                    false,
                                    false,
                                  );
                                  var obj = await _rezervacijeProvider
                                      .insert(request);

                                  setState(() {
                                    lastRezervacija = obj;
                                  });
                                  showSuccessMessage();
                                } catch (err) {
                                  print("error: $err");
                                  _showError();
                                }
                              } else {
                                _showValidationError();
                              }
                            },
                            child: Text("Rezervišite Vaš dan",
                                style: TextStyle(fontSize: 16)))
                        : SizedBox.shrink(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSuccessMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Informacija o uspjehu"),
              content: Text("Uspješno izvršena akcija!"),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  void _showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Ups!"),
              content: const Text(
                  "Nije dozvoljeno rezervisati više od jednu uslugu na jedan dan. \nProvjerite Vaše rezervacije i pokušajte ponovo kasnije."),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }

  void _showValidationError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška!"),
              content: const Text(
                  "Niste selektirali sve podatke potrebne za rezervaciju. Pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }

  _plati() {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayPalScreen(
                lastRezervacija: lastRezervacija,
                totalAmount: lastRezervacija!.usluga!.cijena!,
              ),
            ),
          );

          setState(() {
            selectedUsluga = null;
            selectedTerminZaUslugu = null;
            isLoadingTermin = true;
            terminiZaUslugu = [];
            selectedDate = null;
          });
        },
        child: Text("Izvrši plaćanje"));
  }
}
