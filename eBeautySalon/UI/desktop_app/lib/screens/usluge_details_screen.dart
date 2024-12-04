import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:desktop_app/screens/usluge_list_screen.dart';

import '../utils/constants.dart';

import 'package:desktop_app/models/slika_usluge.dart';
import 'package:desktop_app/models/slika_usluge_insert_update.dart';
import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/kategorije_provider.dart';
import '../providers/slika_usluge_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class UslugeDetaljiScreen extends StatefulWidget {
  Usluga? usluga;

  UslugeDetaljiScreen({super.key, this.usluga});

  @override
  State<UslugeDetaljiScreen> createState() => _UslugeDetaljiScreenState();
}

class _UslugeDetaljiScreenState extends State<UslugeDetaljiScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KategorijeProvider _kategorijeProvider;
  late SlikaUslugeProvider _slikaUslugeProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<Kategorija>? _kategorijeResult;
  SearchResult<SlikaUsluge>? _slikaUslugeResult;
  bool isLoading = true;
  bool isLoadingImage = true;
  bool _imaSliku = false;
  bool _ponistiSliku = false;
  bool authorised = false;

  @override //ova metoda se pokrece nakon init state-a
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'uslugaId': widget.usluga?.uslugaId == null
          ? "0"
          : widget.usluga?.uslugaId.toString(),
      'naziv': widget.usluga?.naziv,
      'opis': widget.usluga?.opis,
      'cijena': widget.usluga?.cijena!.toString(),
      'kategorijaId': widget.usluga?.kategorijaId.toString(),
      'slikaUslugeId': widget.usluga?.slikaUslugeId.toString() ??
          "${DEFAULT_SlikaUslugeId.toString()}",
    };
    _kategorijeProvider = context.read<KategorijeProvider>();
    _slikaUslugeProvider = context.read<SlikaUslugeProvider>();
    _uslugeProvider = context.read<UslugeProvider>();

    initForm();
  }

  Future initForm() async {
    _kategorijeResult = await _kategorijeProvider.get();
    _slikaUslugeResult = await _slikaUslugeProvider.get();

    setState(() {
      isLoading = false;
    });

    setState(() {
      if (LoggedUser.uloga == "Administrator") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
    });
  }

  Widget buildAuthorisation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 800,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("🔐",
                          style: TextStyle(
                            fontSize: 40.0,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Nažalost ne možete pristupiti ovoj stranici.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Usluge",
      child: Center(
        child: isLoading == false
            ? authorised == true
                ? _buildForm()
                : buildAuthorisation()
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _naslov() {
    var naslov = this.widget.usluga != null
        ? "Uredi uslugu: ${this.widget.usluga?.sifra}"
        : "Dodaj novu uslugu";
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
                    builder: (context) => UslugeListScreen()));
              },
              child: Text("Nazad na usluge")),
          SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var request_usluga = new Map.from(_formKey.currentState!.value);
                var request_slika = new SlikaUslugeInsertUpdate(_base64image);

                if (val == true) {
                  if (widget.usluga == null) {
                    doInsert(request_usluga, request_slika);
                  } else if (widget.usluga != null) {
                    doUpdate(request_usluga, request_slika);
                  }
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
              child: Text("Spasi")),
        ],
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Container(
        width: 600,
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
                          child: FormBuilderTextField(
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
                      )),
                    ],
                  ),
                  FormBuilderTextField(
                    name: "cijena",
                    decoration: InputDecoration(labelText: "Cijena:"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Molimo Vas unesite cijenu';
                      }
                      if (!RegExp(
                              r'^(?!0+(\.0{1,2})?$)\d{1,3}(,\d{3})*(\.\d{1,2})?$')
                          .hasMatch(value)) {
                        return 'Unesite ispravnu cijenu. Npr: 50.60 (ne smije biti 0, negaitvan broj, broj sa više od 3 cifre, niti bilo koji specijalan karakter osim broja)';
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
                        return 'Specijalni znakovi (@#\$<>+=*~°^ˇ`˙´) su nedozvoljeni.';
                      }
                      if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
                        return 'Unesite ispravan opis.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'kategorijaId',
                          decoration: InputDecoration(
                            labelText: 'Kategorije',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['kategorijaId']
                                    ?.reset();
                              },
                            ),
                            hintText: 'Odaberi kategoriju',
                          ),
                          items: _kategorijeResult?.result
                                  .map((item) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: item.kategorijaId.toString(),
                                        child: Text(item.naziv ?? ""),
                                      ))
                                  .toList() ??
                              [],
                          validator: (value) {
                            if (value == null) {
                              return 'Molimo Vas izaberite kategoriju';
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
      ),
    );
  }

  Widget _buttonOdaberiSliku() {
    return FormBuilderField(
      name: 'slikaUslugeId',
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

  Uint8List displayNoImage() {
    Uint8List imageBytes = base64Decode(_slikaUslugeResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.usluga != null) {
      if (widget.usluga?.slikaUsluge != null) {
        Uint8List imageBytes = base64Decode(widget.usluga!.slikaUsluge!.slika);
        setState(() {
          _imaSliku = true;
        });

        if (widget.usluga!.slikaUslugeId == DEFAULT_SlikaUslugeId) {
          setState(() {
            _imaSliku = false;
          });
        }
        return imageBytes;
      } else {
        Uint8List imageBytes =
            base64Decode(_slikaUslugeResult!.result[0].slika);
        setState(() {
          _imaSliku = false;
        });
        return imageBytes;
      }
    } else {
      Uint8List imageBytes = base64Decode(_slikaUslugeResult!.result[0].slika);
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

  Future doInsert(request_usluga, request_slika) async {
    if (_base64image != null) {
      var obj = await _slikaUslugeProvider.insert(request_slika);

      if (obj != null) {
        var slikaId = obj.slikaUslugeId;
        request_usluga['slikaUslugeId'] = slikaId;
      } else {
        request_usluga['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
      }
    } else {
      request_usluga['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
    }
    print("insert request: $request_usluga");
    try {
      var req = await _uslugeProvider.insert(request_usluga);
      if (req != null) {
        print("req: ${req.slikaUslugeId}");
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Informacija o uspjehu"),
                  content: Text("Uspješno izvršena akcija!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UslugeListScreen()));
                        },
                        child: Text("Nazad na usluge"))
                  ],
                ));
        _formKey.currentState?.reset();
        ponistiSliku();
      }
    } catch (e) {
      print("error: ${e.toString()}");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (naziv usluge možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  Future doUpdate(request_usluga, request_slika) async {
    if (_base64image != null &&
        (widget.usluga?.slikaUslugeId == DEFAULT_SlikaUslugeId ||
            widget.usluga?.slikaUslugeId == null)) {
      var obj = await _slikaUslugeProvider.insert(request_slika);
      if (obj != null) {
        var slikaId = obj.slikaUslugeId;
        request_usluga['slikaUslugeId'] = slikaId;
      }
    } else if (_base64image != null &&
        widget.usluga?.slikaUslugeId != DEFAULT_SlikaUslugeId) {
      await _slikaUslugeProvider.update(
          widget.usluga!.slikaUslugeId!, request_slika);
    } else if (_ponistiSliku == true && _base64image == null) {
      try {
        var del =
            await _slikaUslugeProvider.delete(widget.usluga!.slikaUslugeId!);
        print("delete slikaUslugeId: $del");
        request_usluga['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
      } catch (err) {
        print("error delete");
      }
    }
    print("update request: $request_usluga");

    try {
      var req = await _uslugeProvider.update(
          widget.usluga!.uslugaId!, request_usluga);
      if (req != null) {}
      print("req: ${req.slikaUslugeId}");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Informacija o uspjehu"),
                content: Text("Uspješno izvršena akcija!"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UslugeListScreen()));
                      },
                      child: Text("Nazad na usluge"))
                ],
              ));
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (naziv usluge možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }
}
