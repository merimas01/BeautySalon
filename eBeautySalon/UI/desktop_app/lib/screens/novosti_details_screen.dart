import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/models/slika_novost_insert_update.dart';
import 'package:desktop_app/screens/novosti_list_screen.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../models/search_result.dart';
import '../models/slika_novost.dart';
import '../providers/novosti_provider.dart';
import '../providers/slika_novost_provider.dart';
import '../utils/constants.dart';

class NovostiDetailsScreen extends StatefulWidget {
  Novost? novost;
  NovostiDetailsScreen({super.key, this.novost});

  @override
  State<NovostiDetailsScreen> createState() => _NovostiDetailsScreenState();
}

class _NovostiDetailsScreenState extends State<NovostiDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late SlikaNovostProvider _slikaNovostProvider;
  late NovostiProvider _novostiProvider;
  SearchResult<Novost>? _novostiResult;
  SearchResult<SlikaNovost>? _slikaNovostResult;
  bool isLoading = true;
  bool isLoadingImage = true;
  bool _imaSliku = false;
  bool _ponistiSliku = false;

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
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj,
      'slikaNovostId': widget.novost?.slikaNovostId.toString() ?? DEFAULT_SlikaNovostId.toString(),
    };
    _slikaNovostProvider = context.read<SlikaNovostProvider>();
    _novostiProvider = context.read<NovostiProvider>();

    initForm();
  }

  Future initForm() async {
    _novostiResult = await _novostiProvider.get();
    _slikaNovostResult = await _slikaNovostProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Novosti",
        child: Center(
          child: isLoading
              ? Container(child: CircularProgressIndicator())
              : _buildForm(),
        ));
  }

  Widget _naslov() {
    var naslov = this.widget.novost?.naslov != null
        ? "Uredi novost: ${this.widget.novost?.naslov}"
        : "Dodaj novost";
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
                          decoration: InputDecoration(labelText: "Naslov:"),
                          name: "naslov",
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Molimo Vas unesite naslov';
                            }
                            if (RegExp(r'[@#$^ˇ`˙´~°<>+=*]+').hasMatch(value)) {
                              return 'Specijalni znakovi su nedozvoljeni (@#<>+=*~°^ˇ`˙´).';
                            }
                            if (value
                                .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                                .isEmpty) {
                              return 'Unesite ispravan naslov.';
                            }
                            return null;
                          },
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: "sadrzaj",
                            decoration: InputDecoration(labelText: "Sadržaj:"),
                            keyboardType: TextInputType.multiline,
                            maxLines: 9,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Molimo Vas unesite sadrzaj';
                              }
                              if (RegExp(r'[@#$^ˇ`˙´~°<>+=*]+')
                                  .hasMatch(value)) {
                                return 'Specijalni znakovi su nedozvoljeni (@#<>+=*~°^ˇ`˙´).';
                              }
                              if (value
                                  .replaceAll(RegExp(r'[^a-zA-Z]'), "")
                                  .isEmpty) {
                                return 'Unesite ispravan sadržaj.';
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
        ));
  }

  Widget _buttonOdaberiSliku() {
    return FormBuilderField(
      name: 'slikaNovostId',
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
    Uint8List imageBytes = base64Decode(_slikaNovostResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.novost != null) {
      if (widget.novost?.slikaNovost != null) {
        Uint8List imageBytes = base64Decode(widget.novost!.slikaNovost!.slika);
        setState(() {
          _imaSliku = true;
        });

        if (widget.novost!.slikaNovostId == DEFAULT_SlikaUslugeId) {
          setState(() {
            _imaSliku = false;
          });
        }
        return imageBytes;
      } else {
        Uint8List imageBytes =
            base64Decode(_slikaNovostResult!.result[0].slika);
        setState(() {
          _imaSliku = false;
        });
        return imageBytes;
      }
    } else {
      Uint8List imageBytes = base64Decode(_slikaNovostResult!.result[0].slika);
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
                    builder: (context) => NovostiListScreen()));
              },
              child: Text("Nazad na novosti")),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var request_novost = new Map.from(_formKey.currentState!.value);
                var request_slika = new SlikaNovostInsertUpdate(_base64image);

                if (val == true) {
                  if (widget.novost == null) {
                    doInsert(request_novost, request_slika);
                  } else if (widget.novost != null) {
                    doUpdate(request_novost, request_slika);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Neispravni podaci"),
                            content: Text("Ispravite greške i popunite obavezna polja"),
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

  Future doInsert(request_novost, request_slika) async {
    if (_base64image != null) {
      var obj = await _slikaNovostProvider.insert(request_slika);
      if (obj != null) {
        var slikaId = obj.slikaNovostId;
        request_novost['slikaNovostId'] = slikaId;
      } else {
        request_novost['slikaNovostId'] = DEFAULT_SlikaNovostId;
      }
    } else {
      request_novost['slikaNovostId'] = DEFAULT_SlikaNovostId;
    }
    print("insert request: $request_novost");
    try {
      var req = await _novostiProvider.insert(request_novost);
      if (req != null) {
        print("req: ${req.slikaNovostId}");
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Informacija o uspjehu"),
                  content: Text("Uspješno izvršena akcija!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NovostiListScreen()));
                        },
                        child: Text("Nazad na novosti"))
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
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (naslov novosti možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  Future doUpdate(request_novost, request_slika) async {
    if (_base64image != null &&
        (widget.novost?.slikaNovostId == DEFAULT_SlikaNovostId || widget.novost?.slikaNovostId == null)) {
      var obj = await _slikaNovostProvider.insert(request_slika);
      if (obj != null) {
        var slikaId = obj.slikaNovostId;
        request_novost['slikaNovostId'] = slikaId;
      }
    } else if (_base64image != null &&
        widget.novost?.slikaNovostId != DEFAULT_SlikaNovostId) {
      await _slikaNovostProvider.update(
          widget.novost!.slikaNovostId!, request_slika);
    } else if (_ponistiSliku == true && _base64image == null) {
      try{
      var del =
          await _slikaNovostProvider.delete(widget.novost!.slikaNovostId!);
      print("delete slikaNovostId: $del");
      request_novost['slikaNovostId'] = DEFAULT_SlikaUslugeId;
      }
      catch(err){
        print("delete error");
      }
    }
    print("update request: $request_novost");

    try {
      var req = await _novostiProvider.update(
          widget.novost!.novostId!, request_novost);
      if (req != null) {
        print("req: ${req.slikaNovostId}, ${req.datumModificiranja}");
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Informacija o uspjehu"),
                  content: Text("Uspješno izvršena akcija!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NovostiListScreen()));
                        },
                        child: Text("Nazad na novosti"))
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
                    "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (naslov novosti možda već postoji)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }
}
