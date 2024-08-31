import 'package:desktop_app/models/slika_usluge.dart';
import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/kategorije_provider.dart';
import '../providers/sliks_usluge_provider.dart';
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
    print(
        "KATEFORIJE [0] [1]: ${_kategorijeResult?.result[0].naziv}, ${_kategorijeResult?.result[1].naziv}");

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
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      //print("dugme Spasi pritisnuto.")
                      _formKey.currentState?.saveAndValidate();
                      print(_formKey.currentState?.value);

                      try {
                        if (widget.usluga == null) {
                          await _uslugeProvider
                              .insert(_formKey.currentState?.value);
                        } else {
                          await _uslugeProvider.update(widget.usluga!.uslugaId!,
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
      title: this.widget.usluga?.naziv ?? "Dodaj uslugu",
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
              // FormBuilderTextField(
              //   name: "datumKreiranja",
              //   enabled: false,
              //   decoration: InputDecoration(labelText: "Datum kreiranja:"),
              // ),
              //  FormBuilderTextField(
              //   name: "datumModifikovanja",
              //   enabled: false,
              //   decoration: InputDecoration(labelText: "Datum modifikovanja:"),
              // ),
              FormBuilderTextField(
                name: "cijena",
                decoration: InputDecoration(labelText: "Cijena:"),
              ),
              FormBuilderTextField(
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
              ),
              FormBuilderTextField(
                name: "slikaUslugeId",
                initialValue: "1",
                decoration: InputDecoration(labelText: "Slika usluge id:"),
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
              )
            ],
          ),
        ));
  }
}
