import 'package:desktop_app/models/rezervacija_update.dart';
import 'package:desktop_app/providers/rezarvacije_provider.dart';
import 'package:desktop_app/screens/rezervacije_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../models/status.dart';
import '../providers/status_provider.dart';
import '../widgets/master_screen.dart';

class RezervacijeUpdateStatus extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijeUpdateStatus({super.key, required this.rezervacija});

  @override
  State<RezervacijeUpdateStatus> createState() =>
      _RezervacijeUpdateStatusState();
}

class _RezervacijeUpdateStatusState extends State<RezervacijeUpdateStatus> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late StatusiProvider _statusiProvider;
  late RezervacijeProvider _rezervacijeProvider;
  SearchResult<Status>? _statusiResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'rezervacijaId': widget.rezervacija?.rezervacijaId.toString(),
      'korisnikId': widget.rezervacija?.korisnikId.toString(),
      'uslugaId': widget.rezervacija?.uslugaId.toString(),
      'terminId': widget.rezervacija?.terminId.toString(),
      'statusId': widget.rezervacija?.statusId.toString(),
      'datumRezervacije': widget.rezervacija?.datumRezervacije,
    };
    _statusiProvider = context.read<StatusiProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();

    print(_initialValue);
    initForm();
  }

  Future initForm() async {
    _statusiResult = await _statusiProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Center(
        child: isLoading
            ? Container(child: CircularProgressIndicator())
            : _buildForm(),
      ),
    );
  }

  Widget _saveAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 139, 132, 134)),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RezervacijeListScreen()));
              },
              child: Text("Nazad na rezervacije")),
          SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var request = new Map.from(_formKey.currentState!.value);
                print("request: ${request}");
                var rezervacija_update = RezervacijaUpdate(
                    int.parse(_initialValue['korisnikId']),
                    int.parse(_initialValue['uslugaId']),
                    int.parse(_initialValue['terminId']),
                    _initialValue['datumRezervacije'],
                    int.parse(request['statusId']));

                print(
                    "${widget.rezervacija?.statusId} ${int.parse(request['statusId'])}");

                if (widget.rezervacija?.statusId !=
                    int.parse(request['statusId'])) {
                  if (widget.rezervacija?.rezervacijaId != null) {
                    var update_status = await _rezervacijeProvider.update(
                        widget.rezervacija!.rezervacijaId!, rezervacija_update);
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Informacija o uspjehu"),
                            content: Text("Uspješno izvršena akcija!"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RezervacijeListScreen()));
                                  },
                                  child: Text("Nazad na rezervacije"))
                            ],
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text("Molimo Vas izaberite novi status."),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RezervacijeListScreen()));
                                  },
                                  child: Text("Nazad na rezervacije"))
                            ],
                          ));
                }
              },
              child: Text("Spasi")),
        ],
      ),
    );
  }

  Widget _naslov() {
    var naslov =
        this.widget.rezervacija != null ? "Promijeni status rezervacije" : "";
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 201, 215), // Set background color
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Center(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                    ),
                    children: [
                  TextSpan(
                    text: naslov,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ])),
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Container(
        width: 400,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _naslov(),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'statusId',
                          decoration: InputDecoration(
                            labelText: 'Statusi',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['statusId']
                                    ?.reset();
                              },
                            ),
                            hintText: 'Odaberite novi status',
                          ),
                          items: _statusiResult?.result
                                  .map((item) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: item.statusId.toString(),
                                        child: Text(item.opis ?? ""),
                                      ))
                                  .toList() ??
                              [],
                          validator: (value) {
                            if (value == null) {
                              return 'Molimo Vas izaberite novi status';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  _saveAction()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
