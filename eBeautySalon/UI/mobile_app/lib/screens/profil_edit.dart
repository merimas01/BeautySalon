import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/korisnik.dart';
import 'package:mobile_app/providers/slika_profila_provider.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/slika_profila_insert_update.dart';
import '../providers/korisnik_provider.dart';
import '../utils/constants.dart';
import '../utils/util.dart';

class ProfilEditScreen extends StatefulWidget {
  Korisnik? korisnik;
  ProfilEditScreen({super.key, this.korisnik});

  @override
  State<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KorisnikProvider _korisnikProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  SearchResult<Korisnik>? _korisniciResult;
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
      'slikaProfilaId': widget.korisnik?.slikaProfilaId.toString() ??
          DEFAULT_SlikaProfilaId.toString(),
    };

    imaSliku();

    _korisnikProvider = context.read<KorisnikProvider>();

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();

    initForm();
  }

  Future initForm() async {
    _korisniciResult = await _korisnikProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  void imaSliku() {
    if (isNullSlika() == false) {
      if (widget.korisnik!.slikaProfilaId != DEFAULT_SlikaProfilaId) {
        setState(() {
          _imaSliku = true;
        });
      }

      if (widget.korisnik!.slikaProfilaId == DEFAULT_SlikaProfilaId) {
        setState(() {
          _imaSliku = false;
        });
      }
    } else {
      setState(() {
        _imaSliku = false;
      });
    }
  }

  Uint8List displayCurrentImage() {
    Uint8List imageBytes = base64Decode(widget.korisnik!.slikaProfila!.slika);
    return imageBytes;
  }

  Image displayNoImage() {
    return Image.asset(
      "assets/images/noImage.jpg",
      height: 180,
      width: null,
      fit: BoxFit.cover,
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
      _imaSliku = false;
    });
  }

  isNullSlika() {
    if (widget.korisnik != null &&
        widget.korisnik?.slikaProfila != null &&
        widget.korisnik?.slikaProfila?.slika != null &&
        widget.korisnik?.slikaProfila?.slika != "") {
      return false;
    } else
      return true;
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

  Widget _naslov() {
    return Text(
      "Uredi profil",
      textAlign: TextAlign.center,
      style: const TextStyle(
          //fontFamily: 'BeckyTahlia',
          fontSize: 26,
          color: Colors.pinkAccent),
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
                      ? isNullSlika() == false
                          ? Container(
                              child: Image.memory(
                                displayCurrentImage(),
                                width: null,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            )
                          : displayNoImage()
                      : displayNoImage(),
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
                    ? isNullSlika() == false
                        ? Image.memory(
                            displayCurrentImage(),
                            width: null,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : displayNoImage()
                    : displayNoImage()
      ],
    );
  }

  Widget _saveAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                                    child: Text("Ok"))
                              ],
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Neispravni podaci"),
                              content: Text(
                                  "Ispravite greške i popunite obavezna polja"),
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
                                "Neispravni podaci. Molimo pokušajte ponovo."),
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

  Future doUpdate(request_korisnik, request_slika) async {
    if (_base64image != null &&
        (widget.korisnik?.slikaProfilaId == DEFAULT_SlikaProfilaId ||
            widget.korisnik?.slikaProfilaId == null)) {
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
      if (widget.korisnik?.slikaProfilaId != DEFAULT_SlikaProfilaId &&
          widget.korisnik?.slikaProfilaId != null) {
        try {
          var del = await _slikaProfilaProvider
              .delete(widget.korisnik!.slikaProfilaId!);
          print("delete slikaUslugeId: $del");
        } catch (err) {
          print("error delete");
        }
      }
      request_korisnik.slikaProfilaId = DEFAULT_SlikaProfilaId;
    }
    print("update request: $request_korisnik");

    try {
      var req = await _korisnikProvider.update(
          widget.korisnik!.korisnikId!, request_korisnik);
      if (req != null) {
        print("req: ${req.slikaProfilaId}");

        LoggedUser.ime = request_korisnik['ime'];
        LoggedUser.prezime = request_korisnik['prezime'];

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
                    "Neispravni podaci. Svaki zapis treba imati unikatne vrijednosti (ime, email ili telefon možda već postoji). Molimo pokušajte ponovo."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Container(
          width: 800,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    dugmeNazad(),
                    SizedBox(
                      height: 10,
                    ),
                    _naslov(),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Korisničko ime:"),
                      name: "korisnickoIme",
                      enabled: false,
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Ime:"),
                      name: "ime",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo Vas unesite ime';
                        }
                        if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
                            .hasMatch(value)) {
                          return 'Brojevi i specijalni znakovi (@#\$?!%()[]{}<>+=*~°^ˇ`˙´.:;,")\nsu nedozvoljeni.';
                        }
                        if (value
                            .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                            .isEmpty) {
                          return 'Unesite ispravno ime.';
                        }
                        return null;
                      },
                    ),
                    FormBuilderTextField(
                      name: "prezime",
                      decoration: InputDecoration(labelText: "Prezime:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo Vas unesite prezime';
                        }
                        if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
                            .hasMatch(value)) {
                          return 'Brojevi i specijalni znakovi (@\$#?!%()[]{}<>+=*~°^ˇ`˙´.:;,")\nsu nedozvoljeni.';
                        }
                        if (value
                            .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                            .isEmpty) {
                          return 'Unesite ispravno prezime.';
                        }
                        return null;
                      },
                    ),
                    FormBuilderTextField(
                      name: "telefon",
                      decoration: InputDecoration(labelText: "Telefon:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo Vas unesite telefon';
                        }
                        if (!RegExp(r'^\d{3}\s?\d{3}\s?\d{3,4}$')
                            .hasMatch(value)) {
                          return 'Unesite ispravan telefon: 06# ### ###';
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "",
      child: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildForm(),
      ),
    );
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilPage()));
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
