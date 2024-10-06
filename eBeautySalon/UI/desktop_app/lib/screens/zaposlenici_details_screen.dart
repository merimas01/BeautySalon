import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/models/korisnik_insert.dart';
import 'package:desktop_app/models/korisnik_update.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../models/slika_profila_insert_update.dart';
import '../models/uloga.dart';
import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_insert_update.dart';
import '../models/zaposlenik_usluga.dart';
import '../models/zaposlenik_usluga_insert_update.dart';
import '../models/korisnik_uloga_insert_update.dart';
import '../providers/korisnici_uloge_provider.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../providers/uloge_provider.dart';
import '../providers/usluge_provider.dart';
import '../providers/zaposlenici_provider.dart';
import '../providers/zaposlenici_usluge_provider.dart';
import '../utils/constants.dart';
import '../widgets/multiselect_dropdown.dart';

class ZaposleniciDetailsScreen extends StatefulWidget {
  Zaposlenik? zaposlenik;
  Korisnik? korisnik;
  ZaposleniciDetailsScreen({
    super.key,
    this.zaposlenik,
    this.korisnik,
  });

  @override
  State<ZaposleniciDetailsScreen> createState() =>
      _ZaposleniciDetailsScreenState();
}

class _ZaposleniciDetailsScreenState extends State<ZaposleniciDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KorisnikProvider _korisnikProvider;
  late UslugeProvider _uslugeProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  late ZaposleniciUslugeProvider _zaposleniciUslugeProvider;
  late ZaposleniciProvider _zaposleniciProvider;
  late KorisniciUlogeProvider _korisniciUlogeProvider;
  late UlogeProvider _ulogeProvider;
  SearchResult<SlikaProfila>? _slikaProfilaResult;
  SearchResult<Usluga>? _uslugeResult;
  SearchResult<Uloga>? _ulogeResult;
  bool isLoading = true;
  bool isLoadingImage = true;
  bool _imaSliku = false;
  bool _ponistiSliku = false;
  SearchResult<Usluga> _selectedItems = SearchResult();
  String? uloga;
  String validationError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'zaposlenikId': widget.zaposlenik?.zaposlenikId.toString(),
      'datumRodjenja': widget.zaposlenik?.datumRodjenja.toString(),
      'datumZaposlenja': widget.zaposlenik?.datumZaposlenja.toString(),
      'korisnikId': widget.zaposlenik?.korisnikId.toString(),
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'email': widget.korisnik?.email,
      'telefon': widget.korisnik?.telefon,
      'korisnickoIme': widget.korisnik?.korisnickoIme,
      'status': widget.korisnik?.status,
      'slikaProfilaId': widget.korisnik?.slikaProfilaId.toString(),
      'ulogaId': widget.korisnik?.korisnikUlogas?.length == 0
          ? DEFAULT_UlogaId.toString()
          : widget.korisnik?.korisnikUlogas?[0].ulogaId.toString(),
    };

    uloga = widget.korisnik?.korisnikUlogas?.length == 0
        ? "Usluznik"
        : widget.korisnik?.korisnikUlogas?[0].uloga?.naziv.toString();

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    _zaposleniciUslugeProvider = context.read<ZaposleniciUslugeProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    _korisniciUlogeProvider = context.read<KorisniciUlogeProvider>();
    _ulogeProvider = context.read<UlogeProvider>();

    initForm();
  }

  Future initForm() async {
    _uslugeResult = await _uslugeProvider.get();
    _slikaProfilaResult = await _slikaProfilaProvider.get();
    _ulogeResult = await _ulogeProvider.get();

    if (widget.zaposlenik != null) {
      var x =
          widget.zaposlenik?.zaposlenikUslugas?.map((e) => e.usluga!).toList();
      if (x != null) {
        setState(() {
          _selectedItems.result = x;
          validationError = "";
        });
      }
    } else {
      setState(() {
        validationError = "Molimo Vas odaberite barem jednu uslugu.";
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.zaposlenik?.korisnik?.ime == null ||
              widget.zaposlenik?.korisnik?.prezime == null
          ? "Registruj novog zaposlenika"
          : "${widget.zaposlenik?.korisnik?.ime} ${widget.zaposlenik?.korisnik?.prezime}",
      child: Column(children: [
        isLoading ? Container() : _buildForm(),
        _saveAction(),
      ]),
    );
  }

  Widget _saveAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var obj = Map.from(_formKey.currentState!.value);
                print(obj);
                var slika_request = SlikaProfilaInsertUpdate(_base64image);
                var korisnik_insert = KorisnikInsert(
                    obj['ime'],
                    obj['prezime'],
                    obj['email'],
                    obj['telefon'],
                    obj['korisnickoIme'],
                    obj['password'],
                    obj['passwordPotvrda'],
                    obj['slikaProfilaId']);

                var korisnik_update = KorisnikUpdate(obj['ime'], obj['prezime'],
                    obj['email'], obj['telefon'], true, DEFAULT_SlikaProfilaId);

                try {
                  if (val == true && validationError == "") {
                    if (widget.zaposlenik == null) {
                      doInsert(obj, korisnik_insert, slika_request);
                    } else if (widget.zaposlenik != null &&
                        validationError != "") {
                      doUpdate(obj, korisnik_update, slika_request);
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Informacija o uspjehu"),
                              content: Text("Uspješno izvršena akcija!"),
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Neispravni podaci"),
                              content:
                                  Text("Ispravite greške i ponovite unos."),
                            ));
                  }
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text(
                                "Neispravni podaci. Molimo pokušajte ponovo. ${e.toString()}"), //Text(e.toString()),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Ok"))
                            ],
                          ));
                }
              },
              child: Text("Spasi")),
        ),
      ],
    );
  }

  void _showMultiSelectDropdown() async {
    final SearchResult<Usluga>? items = _uslugeResult;
    final SearchResult<Usluga>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(usluge: items!);
        });

    if (results != null) {
      setState(() {
        _selectedItems = results;
        validationError = "";
      });
      for (var item in results.result) {
        print("selected items: ${item.naziv} ${item.uslugaId}");
      }
    } else if (results?.result.length == 0) {
      print("nema selektovanih usluga");
    }
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.only(
              right: 10.0, top: 10.0, left: 10.0, bottom: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      name: 'ulogaId',
                      decoration: InputDecoration(
                        labelText: 'Uloge',
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['ulogaId']?.reset();
                          },
                        ),
                        hintText: 'Odaberite ulogu',
                      ),
                      onChanged: (x) async {
                        setState(() {
                          uloga =
                              x == DEFAULT_UlogaId.toString() ? "Usluznik" : "";
                        });
                        if (uloga == "Usluznik" &&
                            _selectedItems.result.length == 0) {
                          setState(() {
                            validationError =
                                "Molimo Vas odaberite barem jednu uslugu.";
                          });
                        } else {
                          setState(() {
                            validationError = "";
                          });
                        }
                        print(x);
                        print(uloga);
                        print(validationError);
                      },
                      items: _ulogeResult?.result
                              .map((item) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: item.ulogaId.toString(),
                                    child: Text(item.naziv ?? ""),
                                  ))
                              .toList() ??
                          [],
                      validator: (value) {
                        if (value == null) {
                          return 'Molimo Vas izaberite ulogu';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Korisničko ime:"),
                    name: "korisnickoIme",
                    enabled: widget.korisnik == null,
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Ime:"),
                    name: "ime",
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: "prezime",
                      decoration: InputDecoration(labelText: "Prezime:"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: "telefon",
                      decoration: InputDecoration(labelText: "Telefon:"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: "email",
                      decoration: InputDecoration(labelText: "Email:"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'datumRodjenja', // The key for this input
                      inputType: InputType
                          .date, // Can be InputType.date, InputType.time, or InputType.both
                      decoration: InputDecoration(
                        labelText: 'Datum rođenja',
                      ),
                      initialValue: DateTime.now(),
                      firstDate: DateTime(1900), // Earliest selectable date
                      lastDate: DateTime(2030), // Latest selectable date
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a date';
                        }
                        // else if (value.isBefore(DateTime.now())) {
                        //   return 'The date must not be in the past';
                        // }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'datumZaposlenja', // The key for this input
                      inputType: InputType
                          .date, // Can be InputType.date, InputType.time, or InputType.both
                      decoration: InputDecoration(
                        labelText: 'Datum zaposlenja',
                      ),
                      initialValue: DateTime.now(),
                      firstDate: DateTime(2010), // Earliest selectable date
                      lastDate: DateTime.now(), // Latest selectable date
                    ),
                  )
                ],
              ),
              widget.korisnik == null
                  ? Row(
                      children: [
                        Expanded(
                            child: FormBuilderTextField(
                          decoration: InputDecoration(labelText: "Šifra:"),
                          name: "password",
                          obscureText: true,
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: FormBuilderTextField(
                          decoration:
                              InputDecoration(labelText: "Ponovite šifru:"),
                          name: "passwordPotvrda",
                          obscureText: true,
                        )),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              uloga == "Usluznik"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255)),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.pink),
                              side: MaterialStateProperty.all(BorderSide(
                                color: Colors.pink,
                                width: 1.0,
                                style: BorderStyle.solid,
                              )),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.pink))),
                            ),
                            onPressed: () {
                              _showMultiSelectDropdown();
                            },
                            child: const Text(
                                "Odaberite usluge za koje je zadužen zaposlenik")),
                        SizedBox(width: 10),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: _selectedItems.result
                              .map((Usluga item) => Chip(
                                    label: Text(item.naziv!),
                                    deleteIcon: Icon(Icons.delete_forever),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedItems.result.remove(item);
                                        if (_selectedItems.result.length == 0) {
                                          setState(() {
                                            validationError =
                                                "Molimo Vas odaberite barem jednu uslugu.";
                                          });
                                        } else {
                                          setState(() {
                                            validationError = "";
                                          });
                                        }
                                        print(
                                            "broj itema: ${_selectedItems.result}");
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                        validationError != ""
                            ? Text(
                                validationError,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container()
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Row(
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
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 219, 36, 36)),
                                    ),
                                    onPressed: () {
                                      ponistiSliku();
                                    },
                                    child: Text("Poništi sliku"))
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
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 219, 36, 36)),
                                    ),
                                    onPressed: () {
                                      ponistiSliku();
                                    },
                                    child: Text("Poništi sliku"))
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
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: FormBuilderField(
                      name: 'slikaUslugeId',
                      builder: ((field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            //label: Text("Odaberite novu sliku"),
                            errorText: field.errorText,
                          ),
                          child: ListTile(
                            leading: Icon(Icons.photo),
                            title: Text("Odaberite novu sliku"),
                            trailing: Icon(Icons.file_upload),
                            onTap: () {
                              getImage();
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Uint8List displayNoImage() {
    Uint8List imageBytes = base64Decode(_slikaProfilaResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.zaposlenik != null) {
      Uint8List imageBytes =
          base64Decode(widget.zaposlenik!.korisnik!.slikaProfila!.slika);
      setState(() {
        _imaSliku = true;
      });
      if (widget.zaposlenik!.korisnik!.slikaProfilaId ==
          DEFAULT_SlikaProfilaId) {
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

  Future doInsert(obj, korisnik_insert, slika_request) async {
    
  }

  Future doUpdate(obj, korisnik_update, slika_request) async {
   
  }
}
