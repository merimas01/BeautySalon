import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../models/slika_profila_insert_update.dart';
import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_usluga.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../providers/usluge_provider.dart';
import '../providers/zaposlenici_provider.dart';
import '../providers/zaposlenici_usluge_provider.dart';
import '../utils/constants.dart';

class ZaposleniciDetailsScreen extends StatefulWidget {
  ZaposlenikUsluga? zaposlenikUsluga;
  Zaposlenik? zaposlenik;
  Usluga? usluga;
  Korisnik? korisnik;
  ZaposleniciDetailsScreen(
      {super.key,
      this.zaposlenikUsluga,
      this.zaposlenik,
      this.usluga,
      this.korisnik});

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
  SearchResult<ZaposlenikUsluga>? _zaposleniciUslugeResult;
  SearchResult<SlikaProfila>? _slikaProfilaResult;
  SearchResult<Usluga>? _uslugeResult;
  SearchResult<Zaposlenik>? _zaposleniciResult;
  SearchResult<Korisnik>? _korisniciResult;
  bool isLoading = true;
  bool isLoadingImage = true;
  bool _imaSliku = false;
  bool _ponistiSliku = false;

  // @override //ova metoda se pokrece nakon init state-a
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'zaposlenikId': widget.zaposlenikUsluga?.zaposlenikId.toString(),
      'uslugaId': widget.zaposlenikUsluga?.uslugaId.toString(),
      'datumKreiranja': widget.zaposlenikUsluga?.datumKreiranja.toString(),
      'datumModificiranja':
          widget.zaposlenikUsluga?.datumModificiranja.toString(),
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
      'naziv': widget.usluga?.naziv
    };

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    _zaposleniciUslugeProvider = context.read<ZaposleniciUslugeProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();

    initForm();
  }

  Future initForm() async {
    _uslugeResult = await _uslugeProvider.get();
    _slikaProfilaResult = await _slikaProfilaProvider.get();
    _zaposleniciUslugeResult = await _zaposleniciUslugeProvider.get();
    _korisniciResult = await _korisnikProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.zaposlenik?.korisnik?.ime == null ||
              widget.zaposlenik?.korisnik?.prezime == null
          ? "Dodaj zaposlenika"
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
                var request_slika = new SlikaProfilaInsertUpdate(_base64image);

                try {
                  if (val == true) {
                    if (widget.zaposlenik == null) {
                      doInsert();
                    } else if (widget.zaposlenik != null) {
                      doUpdate();
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
                width: 10,
              ),
              Row(
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
                        hintText: 'Odaberi uslugu',
                      ),
                      items: _uslugeResult?.result
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
                  )
                ],
              ),
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
    if (widget.zaposlenikUsluga != null) {
      Uint8List imageBytes = base64Decode(
          widget.zaposlenikUsluga!.zaposlenik!.korisnik!.slikaProfila!.slika);
      setState(() {
        _imaSliku = true;
      });
      if (widget.zaposlenikUsluga!.zaposlenik!.korisnik!.slikaProfilaId ==
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

  Future doInsert() async {}

  Future doUpdate() async {}
}
