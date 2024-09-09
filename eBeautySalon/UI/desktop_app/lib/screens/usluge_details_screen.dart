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
      //   'datumKreiranja': "${widget.usluga?.datumKreiranja?.day}.${widget.usluga?.datumKreiranja?.month}.${widget.usluga?.datumKreiranja?.year}",
      //   'datumModifikovanja' : "${widget.usluga?.datumModifikovanja?.day}.${ widget.usluga?.datumModifikovanja?.month}.${ widget.usluga?.datumModifikovanja?.year}",
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
                padding: const EdgeInsets.only(right: 15.0),
                child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();
                      var request_usluga =
                          new Map.from(_formKey.currentState!.value);

                      try {
                        if (widget.usluga == null) {
                          doInsert();
                        } else if (widget.usluga != null) {
                          doUpdate();
                        }

                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Informacija"),
                                  content: Text("Uspješno izvršena akcija!"),
                                ));
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Usluga ID:"),
                        name: "uslugaId",
                        enabled: false,
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Naziv:"),
                    name: "naziv",
                  )),
                ],
              ),
              FormBuilderTextField(
                name: "cijena",
                decoration: InputDecoration(labelText: "Cijena:"),
              ),
              FormBuilderTextField(
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      name: 'kategorijaId',
                      //initialValue: 'Male',
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
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoadingImage
                      ? Image.memory(
                          displayCurrentImage(),
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : _image != null
                          ? Image.file(
                              _image!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            )
                          : Image.memory(
                              displayCurrentImage(),
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
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

  Uint8List displayCurrentImage() {
    if (widget.usluga != null) {
      Uint8List imageBytes = base64Decode(widget.usluga!.slikaUsluge!.slika);
      return imageBytes;
    } else {
      Uint8List imageBytes = base64Decode(_slikaUslugeResult!.result[0].slika);
      return imageBytes;
    }
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
    }

    setState(() {
      isLoadingImage = false;
    });
  }

  void doInsert() async {
    _formKey.currentState?.saveAndValidate();
    //print(_formKey.currentState?.value);
    var request = new Map.from(_formKey.currentState!.value);
    if (_base64image != null) {
      var request_slika = new SlikaUslugeInsertUpdate(_base64image);
      var obj = await _slikaUslugeProvider.insert(request_slika);

      if (obj != null) {
        var slikaId = obj.slikaUslugeId;
        request['slikaUslugeId'] = slikaId;
      } else {
        request['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
      }
    } else {
      request['slikaUslugeId'] = DEFAULT_SlikaUslugeId;
    }
    print("insert request: $request");
    var req = await _uslugeProvider.insert(request);
    print("req: ${req.slikaUslugeId}");
  }

  void doUpdate() async {
    _formKey.currentState?.saveAndValidate();
    var request = new Map.from(_formKey.currentState!.value);
    var request_slika = new SlikaUslugeInsertUpdate(_base64image);

    if (_base64image != null &&
        widget.usluga?.slikaUslugeId == DEFAULT_SlikaUslugeId) {
      var obj = await _slikaUslugeProvider.insert(request_slika);
      if (obj != null) {
        var slikaId = obj.slikaUslugeId;
        request['slikaUslugeId'] = slikaId;
      }
    } else if (_base64image != null &&
        widget.usluga?.slikaUslugeId != DEFAULT_SlikaUslugeId) {
      await _slikaUslugeProvider.update(
          widget.usluga!.slikaUslugeId!, request_slika);
    }

    print("insert request: $request");
    var req = await _uslugeProvider.update(widget.usluga!.uslugaId!, request);
    print("req: ${req.slikaUslugeId}");
  }
}
