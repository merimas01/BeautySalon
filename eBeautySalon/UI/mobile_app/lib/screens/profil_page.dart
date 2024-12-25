import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class ProfilPage extends StatefulWidget {
  static const String routeName = "/profil";
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _korisniciProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  SearchResult<Korisnik>? result;
  SearchResult<SlikaProfila>? _slikaProfilaResult;
  bool isLoading = true;
  bool isEnabled = false;
  Korisnik? korisnik;
  bool authorised = false;

  @override
  void initState() {
    _korisniciProvider = context.read<KorisnikProvider>();

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    initForm();
  }

  Future initForm() async {
    if (LoggedUser.id != null) {
      var data = await _korisniciProvider.getById(LoggedUser.id!);
      _slikaProfilaResult = await _slikaProfilaProvider.get();
      setState(() {
        korisnik = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Profil",
        child: isLoading == false
            ? _buildForm()
            : Center(child: CircularProgressIndicator()));
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        child: Container(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        korisnik != null &&
                                (korisnik?.slikaProfila != null &&
                                    korisnik?.slikaProfila?.slika != null) &&
                                _slikaProfilaResult?.result != null
                            ? Image.memory(
                                displayCurrentImage(),
                                width: null,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                child: Image.asset(
                                  "assets/images/noImage.jpg",
                                  height: 250,
                                  width: null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Korisničko ime:"),
                      name: "korisnickoIme",
                      initialValue: korisnik?.korisnickoIme ?? "",
                      enabled: false,
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Ime:"),
                      name: "ime",
                      initialValue: korisnik?.ime ?? "",
                      enabled: false,
                    ),
                    FormBuilderTextField(
                      name: "prezime",
                      enabled: false,
                      initialValue: korisnik?.prezime ?? "",
                      decoration: InputDecoration(labelText: "Prezime:"),
                    ),
                    FormBuilderTextField(
                      name: "telefon",
                      enabled: isEnabled,
                      initialValue: korisnik?.telefon ?? "",
                      decoration: InputDecoration(labelText: "Telefon:"),
                    ),
                    FormBuilderTextField(
                      name: "email",
                      enabled: isEnabled,
                      initialValue: korisnik?.email ?? "",
                      decoration: InputDecoration(labelText: "Email:"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    korisnik != null
                        ? Column(
                            children: [
                              _editButton(),
                              _mojeRecenzijeButton(),
                              _mojeRezervacijeButton()
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _editButton() {
    return ElevatedButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ProfilPageDetailsScreen(
          //           korisnik: korisnik,
          //         )));
        },
        child: Text("Uredi profil"));
  }

  Widget _mojeRecenzijeButton() {
    return ElevatedButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ProfilPageDetailsScreen(
          //           korisnik: korisnik,
          //         )));
        },
        child: Text("Moje recenzije"));
  }

  Widget _mojeRezervacijeButton() {
    return ElevatedButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ProfilPageDetailsScreen(
          //           korisnik: korisnik,
          //         )));
        },
        child: Text("Moje rezervacije"));
  }

  Uint8List displayCurrentImage() {
    if (korisnik != null) {
      if (korisnik?.slikaProfila != null) {
        Uint8List imageBytes = base64Decode(korisnik!.slikaProfila!.slika);
        return imageBytes;
      } else {
        Uint8List imageBytes =
            base64Decode(_slikaProfilaResult!.result[0].slika);
        return imageBytes;
      }
    } else {
      Uint8List imageBytes = base64Decode(_slikaProfilaResult!.result[0].slika);
      return imageBytes;
    }
  }
}
