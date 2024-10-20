import 'package:desktop_app/models/kategorija.dart';
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
          _saveAction(),
        ],
      ),
      title: this.widget.kategorija?.naziv ?? "Dodaj kategoriju",
    );
  }

  Widget _saveAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                print(_formKey.currentState?.value);

                try {
                  if (val == true) {
                    if (widget.kategorija == null) {
                      await _kategorijeProvider
                          .insert(_formKey.currentState?.value);
                      _formKey.currentState?.reset();
                    } else {
                      await _kategorijeProvider.update(
                          widget.kategorija!.kategorijaId!,
                          _formKey.currentState?.value);
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
                                "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba biti imati unikatne vrijednosti (naziv kategorije možda već postoji)"),
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
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
                      if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
                        return 'Unesite ispravan naziv.';
                      }
                      return null;
                    },
                  )),
                ],
              ),
              FormBuilderTextField(
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Molimo Vas unesite opis';
                  }
                  if (RegExp(r'[@#$^ˇ`˙´~°<>+=*]+').hasMatch(value)) {
                    return 'Specijalni znakovi (@\$#<>+=*~°^ˇ`˙´) su nedozvoljeni.';
                  }
                  if (value.replaceAll(RegExp(r'[^a-zA-Z]'), "").isEmpty) {
                    return 'Unesite ispravan opis.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }
}
