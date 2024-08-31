import 'package:desktop_app/models/kategorija.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/kategorije_provider.dart';
import '../widgets/master_screen.dart';

class KategorijeDetailsScreen extends StatefulWidget {
  Kategorija? kategorija;
  KategorijeDetailsScreen({super.key, this.kategorija});

  @override
  State<KategorijeDetailsScreen> createState() =>
      _KategorijeDetailsScreenState();
}

class _KategorijeDetailsScreenState extends State<KategorijeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KategorijeProvider _kategorijeProvider;
  SearchResult<Kategorija>? _kategorijeResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'kategorijaId': widget.kategorija?.kategorijaId == null
       ? "0"
      : widget.kategorija?.kategorijaId.toString(),
      'naziv': widget.kategorija?.naziv,
      'opis': widget.kategorija?.opis,
    };

    _kategorijeProvider = context.read<KategorijeProvider>();
    initForm();
  }

  Future initForm() async {
    _kategorijeResult = await _kategorijeProvider.get();

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
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      //print("dugme Spasi pritisnuto.")
                      _formKey.currentState?.saveAndValidate();
                      print(_formKey.currentState?.value);

                      try {
                        if (widget.kategorija == null) {
                          await _kategorijeProvider
                              .insert(_formKey.currentState?.value);
                        } else {
                          await _kategorijeProvider.update(
                              widget.kategorija!.kategorijaId!,
                              _formKey.currentState?.value);
                        }
                        print("uspjesno spaseno");

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
      title: this.widget.kategorija?.naziv ?? "Dodaj kategoriju",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Usluga ID:"),
                        name: "kategorijaId",
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
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
              ),
            ],
          ),
        ));
  }
}
