import 'package:desktop_app/models/uloga.dart';
import 'package:desktop_app/screens/uloge_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/zaposlenik.dart';
import '../providers/uloge_provider.dart';
import '../widgets/master_screen.dart';

class UlogeDetailsScreen extends StatefulWidget {
  Uloga? uloga;
  Zaposlenik? zaposlenik;
  Korisnik? korisnik;
  UlogeDetailsScreen({super.key, this.uloga, this.zaposlenik, this.korisnik});

  @override
  State<UlogeDetailsScreen> createState() => _UlogeDetailsScreenState();
}

class _UlogeDetailsScreenState extends State<UlogeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UlogeProvider _ulogeProvider;
  SearchResult<Uloga>? _ulogeResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'ulogaId': widget.uloga?.ulogaId == null
          ? "0"
          : widget.uloga?.ulogaId.toString(),
      'naziv': widget.uloga?.naziv,
      'opis': widget.uloga?.opis,
    };

    _ulogeProvider = context.read<UlogeProvider>();
    initForm();
  }

  Future initForm() async {
    _ulogeResult = await _ulogeProvider.get();

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
        title: "Upravljaj ulogama");
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
                    builder: (context) => UlogeListScreen(
                          zaposlenik: this.widget.zaposlenik,
                          korisnik: this.widget.korisnik,
                        )));
              },
              child: Text("Nazad na uloge")),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                print(_formKey.currentState?.value);

                try {
                  if (val == true) {
                    if (widget.uloga == null) {
                      await _ulogeProvider.insert(_formKey.currentState?.value);
                      _formKey.currentState?.reset();
                    } else {
                      await _ulogeProvider.update(
                          widget.uloga!.ulogaId!, _formKey.currentState?.value);
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
                                                  UlogeListScreen(
                                                    zaposlenik:
                                                        this.widget.zaposlenik,
                                                    korisnik:
                                                        this.widget.korisnik,
                                                  )));
                                    },
                                    child: Text("Nazad na uloge"))
                              ],
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Neispravni podaci"),
                              content:
                                  Text("Ispravite greške i ponovite unos."),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                  }
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text(
                                "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba biti imati unikatne vrijednosti (naziv uloge možda već postoji)"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Ok"))
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
    var naslov = this.widget.uloga != null
        ? "Uredi ulogu: ${widget.uloga?.naziv}"
        : "Dodaj novu ulogu";
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
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _naslov(),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Naziv:"),
                      name: "naziv",
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Molimo Vas unesite naziv';
                        }
                        if (RegExp(r'[@#$?!%()\d~°^ˇ`˙´.;:,"<>+=*]+')
                            .hasMatch(value)) {
                          return 'Brojevi i specijalni znakovi (@#\$?!%()<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
                        }
                        if (value
                            .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                            .isEmpty) {
                          return 'Unesite ispravan naziv.';
                        }
                        return null;
                      },
                    ),
                    FormBuilderTextField(
                      name: "opis",
                      decoration: InputDecoration(labelText: "Opis:"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Molimo Vas unesite opis';
                        }
                        if (RegExp(r'[@#$^ˇ`˙´~°<>+=*]+').hasMatch(value)) {
                          return 'Specijalni znakovi (@\$#<>+=*~°^ˇ`˙´) su nedozvoljeni.';
                        }
                        if (value
                            .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                            .isEmpty) {
                          return 'Unesite ispravan opis.';
                        }
                        return null;
                      },
                    ),
                    _saveAction(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
