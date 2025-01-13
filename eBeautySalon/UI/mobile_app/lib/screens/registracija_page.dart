import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/widgets/master_screen.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/korisnik_insert.dart';
import '../models/slika_profila_insert_update.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../utils/constants.dart';

class RegistracijaPage extends StatefulWidget {
  static const String routeName = "/registration";
  const RegistracijaPage({super.key});

  @override
  State<RegistracijaPage> createState() => _RegistracijaPageState();
}

class _RegistracijaPageState extends State<RegistracijaPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController _passwordController = new TextEditingController();
  late KorisnikProvider _korisnikProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  bool isLoadingImage = true;
  bool _ponistiSliku = false;
  Map<String, dynamic> _initialValue = {};

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Registruj se",
        child: FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child: Container(
              width: 800,
              height: 700,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _naslov(),
                        _korisnickoIme(),
                        _inputIme(),
                        _inputPrezime(),
                        _inputTelefonEmail(),
                        SizedBox(height: 10),
                        _inputSifra(),
                        SizedBox(
                          height: 20,
                        ),
                        _buttonOdaberiSliku(),
                        SizedBox(height: 10),
                        _odaberiSliku(),
                        _saveAction(),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'ime': "",
      'prezime': "",
      'email': "",
      'telefon': "",
      'korisnickoIme': "",
      'status': true,
      'slikaProfilaId': DEFAULT_SlikaProfilaId,
      'password': '',
      'passwordPotvrda': '',
    };

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Nazad na prijavu")),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var obj = Map.from(_formKey.currentState!.value);
                print(obj);
                var slika_request = SlikaProfilaInsertUpdate(_base64image);

                if (val == true) {
                  doInsert(obj, slika_request);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Neispravni podaci"),
                            content: Text(
                                "Ispravite greške i popunite obavezna polja."),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                          ));
                }
              },
              child: Text("Završi registraciju")),
        ],
      ),
    );
  }

  // Widget _naslov() {
  //   var naslov = "Registruj se";
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Color.fromARGB(255, 244, 201, 215), // Set background color
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //         child: Center(
  //           child: RichText(
  //               text: TextSpan(
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.pink,
  //                   ),
  //                   children: [
  //                 TextSpan(
  //                   text: naslov,
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //               ])),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        _base64image != null && _image != null
            ? Column(
                children: [
                  Image.file(
                    _image!,
                    width: null,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 3,
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
            : _image != null && _ponistiSliku != true
                ? Container(
                    child: Image.file(
                      _image!,
                      width: null,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    child: Image.asset(
                      "assets/images/noImage.jpg",
                      height: 180,
                      width: null,
                      fit: BoxFit.cover,
                    ),
                  ),
      ],
    );
  }

  Future ponistiSliku() async {
    setState(() {
      _ponistiSliku = true;
      print("ponisti sliku: $_ponistiSliku");
      _base64image = null;
      print("base64image: $_base64image");
      _image = null;
      print("image: $_image");
    });
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

  Widget _korisnickoIme() {
    return FormBuilderTextField(
      decoration: InputDecoration(labelText: "Korisničko ime:"),
      name: "korisnickoIme",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Molimo Vas unesite korisničko ime (minimalno 3 karaktera)';
        }
        if (!RegExp(r'^[a-zA-Z]{1,}[a-zA-Z\d-_.]{2,}$').hasMatch(value)) {
          return 'Korisničko ime treba imati najmanje 3 karaktera,\ntreba počinjati sa slovom i smije sadržavati: \nslova bez afrikata, brojeve i sljedeće znakove: ._-';
        }
        return null;
      },
    );
  }

  Widget _inputIme() {
    return FormBuilderTextField(
      decoration: InputDecoration(labelText: "Ime:"),
      name: "ime",
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          return 'Molimo Vas unesite ime';
        }
        if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+').hasMatch(value)) {
          return 'Brojevi i specijalni znakovi (@#\$?!%()[]{}<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
        }
        if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
          return 'Unesite ispravno ime.';
        }
        return null;
      },
    );
  }

  Widget _inputPrezime() {
    return FormBuilderTextField(
      name: "prezime",
      decoration: InputDecoration(labelText: "Prezime:"),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          return 'Molimo Vas unesite prezime';
        }
        if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+').hasMatch(value)) {
          return 'Brojevi i specijalni znakovi (@\$#?!%()[]{}<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
        }
        if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
          return 'Unesite ispravno prezime.';
        }
        return null;
      },
    );
  }

  Widget _inputTelefonEmail() {
    return Row(
      children: [
        Expanded(
          child: FormBuilderTextField(
            name: "telefon",
            decoration: InputDecoration(labelText: "Telefon:"),
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
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
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FormBuilderTextField(
            name: "email",
            decoration: InputDecoration(labelText: "Email:"),
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return 'Molimo Vas unesite email';
              }
              if (!RegExp(
                      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,3})?(\.[a-zA-Z]{2,3})?$')
                  .hasMatch(value)) {
                return 'Unesite ispravan email primjer@domena.com';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _inputSifra() {
    return Row(
      children: [
        Expanded(
            child: FormBuilderTextField(
          decoration: InputDecoration(labelText: "Šifra:"),
          name: "password",
          obscureText: true,
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().isEmpty) {
              return 'Molimo Vas unesite lozinku';
            }
            if (!RegExp(r'[\u0000-\uFFFF]{3,}').hasMatch(value)) {
              return 'Vaša lozinka treba sačinjavati minimalno 3 znaka';
            }
            return null;
          },
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: FormBuilderTextField(
          decoration: InputDecoration(labelText: "Ponovite šifru:"),
          name: "passwordPotvrda",
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().isEmpty) {
              return 'Molimo Vas ponovite lozinku';
            }
            if (_passwordController.text != value) {
              return 'Lozinke se ne podudaraju.';
            }
            return null;
          },
        )),
      ],
    );
  }

Widget _naslov() {
    return Text(
      "Registrujte se na nasu aplikaciju putem sljedece forme!",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.pinkAccent),
    );
  }

  void doInsert(Map obj, SlikaProfilaInsertUpdate slika_request) async {
    var korisnik_insert = KorisnikInsert(
        obj['ime'],
        obj['prezime'],
        obj['email'],
        obj['telefon'],
        obj['korisnickoIme'],
        obj['password'],
        obj['passwordPotvrda'],
        obj['slikaProfilaId']);

    if (_base64image != null) {
      var obj = await _slikaProfilaProvider.insert(slika_request);

      if (obj != null) {
        var slikaId = obj.slikaProfilaId;
        korisnik_insert.slikaProfilaId = slikaId;
      } else {
        korisnik_insert.slikaProfilaId = DEFAULT_SlikaProfilaId;
      }
    } else {
      korisnik_insert.slikaProfilaId = DEFAULT_SlikaProfilaId;
    }
    print("insert korisnik request: $korisnik_insert");
    try {
      var kor_post = await _korisnikProvider.insert(korisnik_insert);
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Informacija o uspjehu"),
                content: Text("Uspješno izvršena akcija!"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      child: Text("Nazad na prijavu"))
                ],
              ));
      _formKey.currentState?.reset();
      ponistiSliku();
      setState(() {
        _passwordController.clear();
      });
    } catch (err) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text("Neispravni podaci. Molimo pokušajte ponovo."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }
}
