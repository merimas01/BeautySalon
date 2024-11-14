import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/models/korisnik_insert.dart';
import 'package:desktop_app/models/korisnik_update.dart';
import 'package:desktop_app/screens/uloge_list_screen.dart';
import 'package:desktop_app/screens/zaposlenici_list_screen.dart';
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
import '../models/uloga_insert_update.dart';
import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_insert_update.dart';
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
  TextEditingController _passwordController = new TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _hoveredItemText;
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
  List<Usluga>? _postojeceUsluge;
  String? selectedUlogaId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'zaposlenikId': widget.zaposlenik?.zaposlenikId.toString(),
      'datumRodjenja': widget.zaposlenik?.datumRodjenja,
      'datumZaposlenja': widget.zaposlenik?.datumZaposlenja,
      'korisnikId': widget.zaposlenik?.korisnikId.toString(),
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'email': widget.korisnik?.email,
      'telefon': widget.korisnik?.telefon,
      'korisnickoIme': widget.korisnik?.korisnickoIme,
      'status': widget.korisnik?.status,
      'slikaProfilaId': widget.korisnik?.slikaProfilaId.toString(),
      'ulogaId': widget.korisnik?.korisnikUlogas?[0].ulogaId.toString(),
    };

    _postojeceUsluge =
        widget.zaposlenik?.zaposlenikUslugas?.map((e) => e.usluga!).toList();

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
      var role = widget.korisnik?.korisnikUlogas
          ?.map((e) => e.ulogaId)
          .where((id) => id == DEFAULT_UlogaId)
          .toList()[0]; //svaki korisnik ima samo jednu ulogu

      if (_postojeceUsluge?.length != 0) {
        //ako ima usluge, on je vec usluznik
        setState(() {
          _selectedItems.result = _postojeceUsluge!;
          validationError = "";
          uloga = "Usluznik";
          selectedUlogaId =
              widget.korisnik?.korisnikUlogas?[0].ulogaId.toString();
          print(
              "selectedItems, postojeceUsluge ${_selectedItems.result.length}, ${_postojeceUsluge?.length}");
        });
      }
      if (role == DEFAULT_UlogaId && _postojeceUsluge?.length == 0) {
        //ako je usluznik i ako nema nijednu uslugu
        setState(() {
          validationError =
              "Molimo Vas odaberite barem jednu uslugu (maksimalno 3).";
        });
      }
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
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 255, 255)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 139, 132, 134)),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZaposleniciListScreen()));
                },
                child: Text("Nazad na zaposlenike"))),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var obj = Map.from(_formKey.currentState!.value);
                print(obj);
                var ulogaID =
                    obj['ulogaId'] != null ? int.parse(obj['ulogaId']) : null;
                var slika_request = SlikaProfilaInsertUpdate(_base64image);

                if (val == true && ulogaID != null && validationError == "") {
                  if (widget.zaposlenik == null) {
                    doInsert(obj, slika_request, ulogaID);
                  } else if (widget.zaposlenik != null) {
                    doUpdate(obj, slika_request, ulogaID);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Neispravni podaci"),
                            content: Text("Ispravite greške i ponovite unos."),
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

      if (results.result.length > 3) {
        print("greska, vece od 3");
        setState(() {
          _selectedItems.result = [];
          validationError =
              "Dozvoljeno je izabrati maksimalno 3 usluge. Pokušajte ponovo.";
        });
      }
    } else if (results?.result.length == 0) {
      print("nema selektovanih usluga");
      setState(() {
        validationError =
            "Molimo Vas odaberite barem jednu uslugu (maksimalno 3).";
      });
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
                      onReset: () async {
                        if (widget.zaposlenik == null) {
                          setState(() {
                            selectedUlogaId = "";
                            uloga = null;
                          });
                        } else {
                          setState(() {
                            selectedUlogaId = widget
                                .korisnik?.korisnikUlogas?[0].ulogaId
                                .toString();
                            uloga =
                                selectedUlogaId == DEFAULT_UlogaId.toString()
                                    ? "Usluznik"
                                    : "";
                          });
                        }
                      },
                      onChanged: (x) async {
                        setState(() {
                          selectedUlogaId = x;
                          uloga =
                              x == DEFAULT_UlogaId.toString() ? "Usluznik" : "";
                        });
                        if (uloga == "Usluznik" &&
                            _selectedItems.result.length == 0) {
                          setState(() {
                            validationError =
                                "Molimo Vas odaberite barem jednu uslugu (maksimalno 3).";
                          });
                        }
                        if (uloga == "Usluznik" &&
                            _selectedItems.result.length > 3) {
                          setState(() {
                            validationError =
                                "Dozvoljeno je izabrati maksimalno 3 usluge. Pokušajte ponovo.";
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
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Tooltip(
                    message:
                        "Po potrebi dodaj novu ulogu, uredi ili izbriši već postojeću.",
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UlogeListScreen()));
                        },
                        child: Text("Upravljaj ulogama")),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Korisničko ime:"),
                    name: "korisnickoIme",
                    enabled: widget.korisnik == null,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Molimo Vas unesite korisničko ime.';
                      }
                      if (!RegExp(r'^[a-zA-Z]+[a-zA-Z\d-_.]+$')
                          .hasMatch(value)) {
                        return 'Korisničko ime treba počinjati sa slovom i smije sadržavati \nslova bez afrikata, brojeve i sljedeće znakove: ._-';
                      }
                      return null;
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Ime:"),
                    name: "ime",
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Molimo Vas unesite ime';
                      }
                      if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
                          .hasMatch(value)) {
                        return 'Brojevi i specijalni znakovi (@#\$?!%()[]{}<>+=*~°^ˇ`˙´.:;,") su nedozvoljeni.';
                      }
                      if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
                        return 'Unesite ispravno ime.';
                      }
                      return null;
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: "prezime",
                      decoration: InputDecoration(labelText: "Prezime:"),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Molimo Vas unesite prezime';
                        }
                        if (RegExp(r'[@#$?!%()\{\}\[\]\d~°^ˇ`˙´.;:,"<>+=*]+')
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: "telefon",
                      decoration: InputDecoration(labelText: "Telefon:"),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
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
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
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
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'datumRodjenja',
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Datum rođenja',
                      ),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2030),
                      validator: (value) {
                        if (value == null) {
                          return 'Niste unijeli datum.';
                        }
                        if (value != null && value != _selectedDate) {
                          setState(() {
                            _selectedDate = value;
                            _dateController.text =
                                "${value.toLocal()}".split(' ')[0];
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                        name: 'datumZaposlenja',
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: 'Datum zaposlenja',
                        ),
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                        validator: (value) {
                          if (value == null) {
                            return 'Niste unijeli datum';
                          }
                          return null;
                        }),
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
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Molimo Vas unesite lozinku';
                            }
                            if (!RegExp(r'[\u0000-\uFFFF]{3,}')
                                .hasMatch(value)) {
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
                          decoration:
                              InputDecoration(labelText: "Ponovite šifru:"),
                          name: "passwordPotvrda",
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Molimo Vas ponovite lozinku';
                            }
                            if (_passwordController.text != value) {
                              return 'Lozinke se ne podudaraju.';
                            }
                            return null;
                          },
                        )),
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
                              height: 3,
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
                                  height: 3,
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
                      name: 'slikaProfilaId',
                      builder: ((field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            //label: Text("Odaberite novu sliku"),
                            errorText: field.errorText,
                          ),
                          child: ListTile(
                            leading: Icon(Icons.photo),
                            title: Text("Odaberite novu sliku zaposlenika"),
                            trailing: Icon(Icons.file_upload),
                            onTap: () {
                              getImage();
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(width: 30),
                  uloga == "Usluznik"
                      ? Column(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 255, 255, 255)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 33, 33, 33)),
                                ),
                                onPressed: () {
                                  _showMultiSelectDropdown();
                                },
                                child: const Text(
                                    "Odaberite usluge za koje je zadužen zaposlenik")),
                            SizedBox(height: 5),
                            // _selectedItems.result.length <= 3
                            //     ?
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: _selectedItems.result
                                  .map((Usluga item) => SizedBox(
                                      width: 150,
                                      child: MouseRegion(
                                          onEnter: (_) {
                                            setState(() {
                                              _hoveredItemText = item.naziv;
                                            });
                                          },
                                          onExit: (_) {
                                            setState(() {
                                              _hoveredItemText = null;
                                            });
                                          },
                                          child: Tooltip(
                                              message: item.naziv!,
                                              child: Chip(
                                                label: Text(item.naziv!),
                                                deleteIcon:
                                                    Icon(Icons.delete_forever),
                                                onDeleted: () {
                                                  setState(() {
                                                    _selectedItems.result
                                                        .remove(item);
                                                    if (_selectedItems
                                                            .result.length ==
                                                        0) {
                                                      setState(() {
                                                        validationError =
                                                            "Molimo Vas odaberite barem jednu uslugu (maksimalno 3).";
                                                      });
                                                    } else if (_selectedItems
                                                            .result.length !=
                                                        0) {
                                                      setState(() {
                                                        validationError = "";
                                                      });
                                                    }
                                                    print(
                                                        "broj itema: ${_selectedItems.result}");
                                                  });
                                                },
                                              )))))
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

  Future doInsert(obj, slika_request, ulogaID) async {
    //ne dozvoliti da se isti korisnik unosi dvaput, uraditi to na backendu,
    //pa samo ispisati poruku ovde u alertu.

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

      if (kor_post != null) {
        print("kor_post: ${kor_post.slikaProfilaId}");
        var kid = kor_post.korisnikId;

        var zaposlenik_request = ZaposlenikInsertUpdate(
            obj['datumRodjenja'], obj['datumZaposlenja'], kid);
        var zap_post = await _zaposleniciProvider.insert(zaposlenik_request);
        print("insert zaposlenik request request: ${zaposlenik_request}");

        if (zap_post != null) {
          var zid = zap_post.zaposlenikId;

          if (ulogaID != null) {
            var korisnikUloga_request = KorisnikUlogaInsertUpdate(kid, ulogaID);
            print("korisnikUloga_request ${korisnikUloga_request}");
            var kor_uloga_post =
                await _korisniciUlogeProvider.insert(korisnikUloga_request);
          }

          for (var zu in _selectedItems.result) {
            var zaposlenik_usluga_request =
                ZaposlenikUslugaInsertUpdate(zid, zu.uslugaId);
            print("zaposlenik_usluga_request ${zaposlenik_usluga_request}");
            var zap_usluga_post =
                _zaposleniciUslugeProvider.insert(zaposlenik_usluga_request);
          }
        }
      }
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Informacija o uspjehu"),
                content: Text("Uspješno izvršena akcija!"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ZaposleniciListScreen()));
                      },
                      child: Text("Nazad na zaposlenike"))
                ],
              ));
      _formKey.currentState?.reset();
      //print(_formKey.currentState!.value);
      ponistiSliku();
      _selectedItems.result = [];
      uloga = null;
      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _dateController.clear();
      });
    } catch (e) {
      print("error: ${e.toString()}");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (korisničko ime, email ili telefon možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  Future doUpdate(obj, slika_request, ulogaID) async {
    var korisnik_update = KorisnikUpdate(obj['ime'], obj['prezime'],
        obj['email'], obj['telefon'], true, widget.korisnik!.slikaProfilaId);

    if (_base64image != null &&
        widget.korisnik?.slikaProfilaId == DEFAULT_SlikaProfilaId) {
      var obj = await _slikaProfilaProvider.insert(slika_request);
      if (obj != null) {
        var slikaId = obj.slikaProfilaId;
        korisnik_update.slikaProfilaId = slikaId;
      }
    } else if (_base64image != null &&
        widget.korisnik?.slikaProfila != DEFAULT_SlikaProfilaId) {
      await _slikaProfilaProvider.update(
          widget.korisnik!.slikaProfilaId!, slika_request);
    } else if (_ponistiSliku == true && _base64image == null) {
      if (widget.korisnik!.slikaProfilaId != DEFAULT_SlikaProfilaId) {
        var del = await _slikaProfilaProvider
            .delete(widget.korisnik!.slikaProfilaId!);
        print("delete slikaUslugeId: $del");
      }
      korisnik_update.slikaProfilaId = DEFAULT_SlikaProfilaId;
    }

    try {
      print("update korisnik request: $korisnik_update");
      var kor_put = await _korisnikProvider.update(
          widget.korisnik!.korisnikId!, korisnik_update);

      if (kor_put != null) {
        print("kor_put: ${kor_put.slikaProfilaId}");
      }

      var zaposlenik_request = ZaposlenikInsertUpdate(obj['datumRodjenja'],
          obj['datumZaposlenja'], widget.zaposlenik!.korisnikId);
      var zap_put = await _zaposleniciProvider.update(
          widget.zaposlenik!.zaposlenikId!, zaposlenik_request);
      print(
          "update zaposlenik request request: ${zaposlenik_request} ${zap_put.datumRodjenja}");

      var korisnikUloga_request =
          KorisnikUlogaInsertUpdate(widget.korisnik!.korisnikId!, ulogaID);

      if (ulogaID != null) {
        var uloga_vec_postoji = widget.zaposlenik?.korisnik?.korisnikUlogas
            ?.map((e) => e.ulogaId == ulogaID);
        if (uloga_vec_postoji != null && !uloga_vec_postoji.contains(true)) {
          //ako nema tu ulogu
          var kor_uloga_id = widget.korisnik?.korisnikUlogas
              ?.map((k) => k.korisnikUlogaId)
              .toList()[0];
          if (kor_uloga_id != null) {
            print("korisnikUloga_request update ${korisnikUloga_request}");
            var kor_uloga_post = await _korisniciUlogeProvider.update(
                kor_uloga_id, korisnikUloga_request);
          }
        } else if (uloga_vec_postoji == null) {
          print("korisnikUloga_request insert ${korisnikUloga_request}");
          var kor_uloga_post =
              await _korisniciUlogeProvider.insert(korisnikUloga_request);
        }
      }

      if (ulogaID == DEFAULT_UlogaId) {
        var uloga_usluznik = widget.korisnik?.korisnikUlogas
            ?.map((e) => e.ulogaId == DEFAULT_UlogaId)
            .toList()[0];

        //ako je postojeca uloga bila Usluznik, provjeriti ima li usluga.
        if (uloga_usluznik == true) {
          //uporediti postojece usluge i nove. ako su iste, ne radi se update, ako nisu
          //iste, brisu se stare i dodaju se nove.
          print(
              "selected items result length: ${_selectedItems.result.length}");
          print("postojece usluge: ${_postojeceUsluge?.length}");

          //if stara_lista != nova_lista
          if (!areListsEqual(_selectedItems.result, _postojeceUsluge)) {
            print("usao u if");
            for (var zu in widget.zaposlenik!.zaposlenikUslugas!) {
              var delete_zu =
                  _zaposleniciUslugeProvider.delete(zu.zaposlenikUslugaId!);
            }

            for (var zu in _selectedItems.result) {
              var zaposlenik_usluga_request = ZaposlenikUslugaInsertUpdate(
                  widget.zaposlenik!.zaposlenikId, zu.uslugaId);
              print("zaposlenik_usluga_request ${zaposlenik_usluga_request}");
              var zap_usluga_post =
                  _zaposleniciUslugeProvider.insert(zaposlenik_usluga_request);
            }
          }
        }
      }
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Informacija o uspjehu"),
                content: Text("Uspješno izvršena akcija!"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ZaposleniciListScreen()));
                      },
                      child: Text("Nazad na zaposlenike"))
                ],
              ));
    } catch (e) {
      print("error: ${e.toString()}");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (email ili telefon možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  bool areListsEqual(List<Usluga> list1, List<Usluga>? list2) {
    if (list1.length != list2?.length)
      return false;
    else if (list1.length == list2?.length) {
      //list1 ne smije biti 0, tako da ako je ovaj uslov tacan, znaci da ce i list2 imati elemente
      for (int i = 0; i < list1.length; i++) {
        if (list1[i].uslugaId != list2![i].uslugaId) {
          return false;
        }
      }
    }
    return true;
  }
}
