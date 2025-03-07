import 'package:desktop_app/models/kategorija.dart';
import 'package:desktop_app/screens/kategorije_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/kategorije_provider.dart';
import '../widgets/master_screen.dart';

class KategorijeDetailsScreen extends StatefulWidget {
  Kategorija? kategorija;
  KategorijeDetailsScreen({super.key, this.kategorija});

  @override
  State<KategorijeDetailsScreen> createState() =>
      _KategorijeDetailsScreenState();
}

class _KategorijeDetailsScreenState extends State<KategorijeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KategorijeProvider _kategorijeProvider;
  SearchResult<Kategorija>? _kategorijeResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'kategorijaId': widget.kategorija?.kategorijaId == null
          ? "0"
          : widget.kategorija?.kategorijaId.toString(),
      'naziv': widget.kategorija?.naziv,
      'opis': widget.kategorija?.opis,
    };

    _kategorijeProvider = context.read<KategorijeProvider>();
    initForm();
  }

  Future initForm() async {
    _kategorijeResult = await _kategorijeProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Kategorije",
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
                    builder: (context) => KategorijeListScreen()));
              },
              child: Text("Nazad na kategorije")),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                print(_formKey.currentState?.value);

                try {
                  if (val == true) {
                    if (widget.kategorija == null) {
                      await _kategorijeProvider
                          .insert(_formKey.currentState?.value);
                      _formKey.currentState?.reset();
                    } else {
                      await _kategorijeProvider.update(
                          widget.kategorija!.kategorijaId!,
                          _formKey.currentState?.value);
                    }
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  KategorijeListScreen()));
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Neispravni podaci"),
                              content: Text(
                                  "Ispravite greške i popunite obavezna polja."),
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
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text(
                                "Neispravni podaci. Svaki zapis treba biti imati unikatne vrijednosti (naziv kategorije možda već postoji). \nMolimo pokušajte ponovo."),
                            actions: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.pink),
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
    var naslov = this.widget.kategorija != null
        ? "Uredi kategoriju: ${this.widget.kategorija?.sifra}"
        : "Dodaj novu kategoriju";
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 500,
            //height: 500,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 211, 17, 17)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        KategorijeListScreen()));
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
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
                      _saveAction()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
