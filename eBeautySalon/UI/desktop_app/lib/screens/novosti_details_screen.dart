import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_app/models/slika_novost_insert_update.dart';
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
      'slikaNovostId': widget.novost?.slikaNovostId.toString(),
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
      title: this.widget.novost?.naslov ?? "Dodaj novost",
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          //  SizedBox(height: 8,),
          _saveAction()
        ],
      ),
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
                    decoration: InputDecoration(labelText: "Naslov:"),
                    name: "naslov",
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Molimo Vas unesite naslov';
                      }
                      if (!RegExp(r'^[a-zA-Z .,"\-]+$').hasMatch(value)) {
                        return 'Unesite ispravan naslov';
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
                      maxLines: 10,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Molimo Vas unesite sadrzaj';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9 .,!?"\-\n]+$')
                            .hasMatch(value)) {
                          return 'Unesite ispravan sadrzaj';
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
                      name: 'slikaNovostId',
                      builder: ((field) {
                        return InputDecorator(
                          decoration: InputDecoration(
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
    Uint8List imageBytes = base64Decode(_slikaNovostResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.novost != null) {
      Uint8List imageBytes = base64Decode(widget.novost!.slikaNovost!.slika);
      setState(() {
        _imaSliku = true;
      });
      if (widget.novost!.slikaNovostId == DEFAULT_SlikaNovostId) {
        setState(() {
          _imaSliku = false;
        });
      }
      return imageBytes;
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
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
                            content: Text("Ispravite greške i ponovite unos."),
                          ));
                }
              },
              child: Text("Spasi")),
        ),
      ],
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
        widget.novost?.slikaNovostId == DEFAULT_SlikaNovostId) {
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
      var del =
          await _slikaNovostProvider.delete(widget.novost!.slikaNovostId!);
      print("delete slikaNovostId: $del");
      request_novost['slikaNovostId'] = DEFAULT_SlikaUslugeId;
    }
    print("update request: $request_novost");

    try {
      var req = await _novostiProvider.update(
          widget.novost!.novostId!, request_novost);
      if (req != null) {
        print("req: ${req.slikaNovostId}");
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Informacija o uspjehu"),
                  content: Text("Uspješno izvršena akcija!"),
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
