import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
      'slikaUslugeId': widget.usluga?.slikaUslugeId.toString(),
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          //  SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                    onPressed: () async {
                      var val = _formKey.currentState?.saveAndValidate();
                      var request_usluga =
                          new Map.from(_formKey.currentState!.value);
                      var request_slika =
                          new SlikaUslugeInsertUpdate(_base64image);

                      try {
                        if (val == true) {
                          if (widget.usluga == null) {
                            doInsert(request_usluga, request_slika);
                          } else if (widget.usluga != null) {
                            doUpdate(request_usluga, request_slika);
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
                                    content: Text(
                                        "Ispravite greške i ponovite unos."),
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
          ),
        ],
      ),
      title: this.widget.usluga?.naziv ?? "Dodaj uslugu",
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
                    decoration: InputDecoration(labelText: "Naziv:"),
                    name: "naziv",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo Vas unesite naziv';
                      }
                      if (!RegExp(r'^[a-zA-Z .,"\-]+$').hasMatch(value)) {
                        return 'Unesite ispravan naziv';
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
                  if (value == null || value.isEmpty) {
                    return 'Molimo Vas unesite cijenu';
                  }
                  if (!RegExp(r'^(?!0+(\.0{1,2})?$)\d{1,3}(,\d{3})*(\.\d{2})?$')
                      .hasMatch(value)) {
                    return 'Unesite ispravnu cijenu';
                  }
                  return null;
                },
              ),
              FormBuilderTextField(
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo Vas unesite opis';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9 .,!?"\-]+$').hasMatch(value)) {
                    return 'Unesite ispravan opis';
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
    Uint8List imageBytes = base64Decode(_slikaUslugeResult!.result[0].slika);
    return imageBytes;
  }

  Uint8List displayCurrentImage() {
    if (widget.usluga != null) {
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
    var req = await _uslugeProvider.insert(request_usluga);
    print("req: ${req.slikaUslugeId}");
  }

  Future doUpdate(request_usluga, request_slika) async {
    if (_base64image != null &&
        widget.usluga?.slikaUslugeId == DEFAULT_SlikaUslugeId) {
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
      var del =
          await _slikaUslugeProvider.delete(widget.usluga!.slikaUslugeId!);
      print("delete slikaUslugeId: $del");
      request_usluga['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
    }
    print("update request: $request_usluga");
    var req =
        await _uslugeProvider.update(widget.usluga!.uslugaId!, request_usluga);
    print("req: ${req.slikaUslugeId}");
  }
}
