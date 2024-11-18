import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/screens/profil_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';

import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../models/slika_profila_insert_update.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../utils/constants.dart';
import '../widgets/master_screen.dart';

class ProfilPageDetailsScreen extends StatefulWidget {
  Korisnik? korisnik;
  ProfilPageDetailsScreen({super.key, this.korisnik});

  @override
  State<ProfilPageDetailsScreen> createState() =>
      _ProfilPageDetailsScreenState();
}

class _ProfilPageDetailsScreenState extends State<ProfilPageDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisniciResult;

  late SlikaProfilaProvider _slikaProfilaProvider;
  SearchResult<SlikaProfila>? _slikaProfilaResult;

  bool isLoading = true;
  bool isLoadingImage = true;
  bool _imaSliku = false;
  bool _ponistiSliku = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'korisnickoIme': widget.korisnik?.korisnickoIme,
      'telefon': widget.korisnik?.telefon,
      'email': widget.korisnik?.email,
      'status': widget.korisnik?.status,
      'slikaProfilaId': widget.korisnik?.slikaProfilaId,
    };

    _korisnikProvider = context.read<KorisnikProvider>();
    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();

    initForm();
  }

  Future initForm() async {
    _korisniciResult = await _korisnikProvider.get();
    _slikaProfilaResult = await _slikaProfilaProvider.get();

    //obicni get
    print("result korisnici: ${_korisniciResult?.result[0].ime}");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Profil",
      child: Center(
        child: isLoading
            ? Container(child: CircularProgressIndicator())
            : _buildForm(),
      ),
    );
  }

  Widget _naslov() {
    var naslov = this.widget.korisnik != null ? "Uredi profil" : "";
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

  Widget _buildForm() {
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
                      decoration: InputDecoration(labelText: "Korisničko ime:"),
                      name: "korisnickoIme",
                      enabled: false,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FormBuilderTextField(
                          decoration: InputDecoration(labelText: "Ime:"),
                          name: "ime",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo Vas unesite ime';
                            }
                            if (RegExp(
                                    r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
                                .hasMatch(value)) {
                              return 'Brojevi i specijalni znakovi (@#\$?!%()[]{}<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
                            }
                            if (value
                                .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                                .isEmpty) {
                              return 'Unesite ispravno ime.';
                            }
                            return null;
                          },
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            name: "prezime",
                            decoration: InputDecoration(labelText: "Prezime:"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Molimo Vas unesite prezime';
                              }
                              if (RegExp(
                                      r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
                                  .hasMatch(value)) {
                                return 'Brojevi i specijalni znakovi (@\$#?!%()[]{}<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
                              }
                              if (value
                                  .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                                  .isEmpty) {
                                return 'Unesite ispravno prezime.';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    FormBuilderTextField(
                      name: "telefon",
                      decoration: InputDecoration(labelText: "Telefon:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo Vas unesite telefon';
                        }
                        if (!RegExp(
                                r'^\+?\d{2,4}[\s-]{1}\d{2}[\s-]{1}\d{3}[\s-]{1}\d{3,4}$')
                            .hasMatch(value)) {
                          return 'Unesite ispravan telefon: +### ## ### ###';
                        }
                        return null;
                      },
                    ),
                    FormBuilderTextField(
                      name: "email",
                      decoration: InputDecoration(labelText: "Email:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo Vas unesite email';
                        }
                        if (!RegExp(
                                r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,3})?(\.[a-zA-Z]{2,3})?$')
                            .hasMatch(value)) {
                          return 'Unesite ispravan email: primjer@domena.com';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buttonOdaberiSliku(),
                    SizedBox(
                      height: 10,
                    ),
                    _odaberiSliku(),
                    _saveAction(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buttonOdaberiSliku() {
    return FormBuilderField(
      name: 'slikaProfilaId',
      builder: ((field) {
        return Container(
          width: 100,
          height: 30,
          child: ElevatedButton(
              child: Center(
                child: Tooltip(
                    message: "Izaberi sliku",
                    child: Icon(
                      Icons.file_upload,
                      size: 30,
                    )),
              ),
              onPressed: () => getImage(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 194, 191, 191)),
                iconColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 0, 0, 0)),
              )),
        );
      }),
    );
  }

  Widget _odaberiSliku() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoadingImage
            ? Column(
                children: [
                  _ponistiSliku != true
                      ? Image.memory(
                          displayCurrentImage(),
                          width: null,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          displayNoImage(),
                          width: null,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  _imaSliku
                      ? SizedBox(
                          width: 60,
                          child: TextButton(
                              style: ButtonStyle(
                                iconColor: MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 225, 34, 34)),
                              ),
                              onPressed: () {
                                ponistiSliku();
                              },
                              child: Tooltip(
                                  message: "Poništi sliku",
                                  child: Icon(Icons.delete))),
                        )
                      : Container()
                ],
              )
            : _base64image != null && _image != null
                ? Column(
                    children: [
                      Image.file(
                        _image!,
                        width: null,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 60,
                        child: TextButton(
                            style: ButtonStyle(
                              iconColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 225, 34, 34)),
                            ),
                            onPressed: () {
                              ponistiSliku();
                            },
                            child: Tooltip(
                                message: "Poništi sliku",
                                child: Icon(Icons.delete))),
                      )
                    ],
                  )
                : _ponistiSliku != true
                    ? Container(
                        child: Image.memory(
                          displayCurrentImage(),
                          width: null,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        child: Image.memory(
                          displayNoImage(),
                          width: null,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
      ],
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilPage()));
              },
              child: Text("Nazad na profil")),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                print("value: $val");
                var request_korisnik =
                    new Map.from(_formKey.currentState!.value);
                var request_slika = new SlikaProfilaInsertUpdate(_base64image);

                try {
                  if (val == true) {
                    if (widget.korisnik != null) {
                      doUpdate(request_korisnik, request_slika);
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
                                                  ProfilPage()));
                                    },
                                    child: Text("Nazad na profil"))
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
                                "Neispravni podaci. Molimo pokušajte ponovo. ${e.toString()}"),
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

  File? _image;
  String? _base64image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    var path = result?.files.single.path;
    print("path slike: ${path}");

    if (result != null && path != null) {
      _image = File(path);
      _base64image = base64Encode(_image!.readAsBytesSync());
      print(
          "${(_image != null && _base64image != null) ? "postoji slika" : "ne postoji slika"}");
    }

    setState(() {
      isLoadingImage = false;
    });
  }

  Uint8List displayNoImage() {
    Uint8List imageBytes = base64Decode(_slikaProfilaResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.korisnik != null) {
      Uint8List imageBytes = base64Decode(widget.korisnik!.slikaProfila!.slika);
      setState(() {
        _imaSliku = true;
      });
      if (widget.korisnik!.slikaProfilaId == DEFAULT_SlikaProfilaId) {
        setState(() {
          _imaSliku = false;
        });
      }
      return imageBytes;
    } else {
      Uint8List imageBytes = base64Decode(_slikaProfilaResult!.result[0].slika);
      setState(() {
        _imaSliku = false;
      });
      return imageBytes;
    }
  }

  Future ponistiSliku() async {
    setState(() {
      _ponistiSliku = true;
      print("ponisti sliku: $_ponistiSliku");
      _base64image = null;
      print("base64image: $_base64image");
      _image = null;
      print("image: $_image");
      _imaSliku = false;
    });
  }

  Future doUpdate(request_korisnik, request_slika) async {
    if (_base64image != null &&
        widget.korisnik?.slikaProfilaId == DEFAULT_SlikaProfilaId) {
      var obj = await _slikaProfilaProvider.insert(request_slika);
      if (obj != null) {
        var slikaId = obj.slikaProfilaId;
        request_korisnik['slikaProfilaId'] = slikaId;
      }
    } else if (_base64image != null &&
        widget.korisnik?.slikaProfilaId != DEFAULT_SlikaProfilaId) {
      await _slikaProfilaProvider.update(
          widget.korisnik!.slikaProfilaId!, request_slika);
    } else if (_ponistiSliku == true && _base64image == null) {
      var del =
          await _slikaProfilaProvider.delete(widget.korisnik!.slikaProfilaId!);
      print("delete slikaProfilaId: $del");
      request_korisnik['slikaProfilaId'] = DEFAULT_SlikaProfilaId;
    }
    print("update request: $request_korisnik");

    try {
      var req = await _korisnikProvider.update(
          widget.korisnik!.korisnikId!, request_korisnik);
      if (req != null) {
        print("req: ${req.slikaProfilaId}");
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Informacija o uspjehu"),
                  content: Text("Uspješno izvršena akcija!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilPage()));
                        },
                        child: Text("Nazad na profil"))
                  ],
                ));
      }
    } catch (e) {
      print("error: ${e.toString()}");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (ime, email ili telefon možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }
}
