import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_app/screens/profil_page_details_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../widgets/master_screen.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late KorisnikProvider _korisniciProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  SearchResult<Korisnik>? result;
  final _formKey = GlobalKey<FormBuilderState>();
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

      setState(() {
        if (LoggedUser.uloga == "") {
          authorised = false;
        } else {
          authorised = true;
        }

        print("authorised: $authorised");
      });
    }
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
        title: "Profil",
        child: Center(
            child: isLoading == false
                ? authorised == true
                    ? _buildForm()
                    : buildAuthorisation()
                : Center(child: CircularProgressIndicator())));
  }

  Widget _editButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilPageDetailsScreen(
                    korisnik: korisnik,
                  )));
        },
        child: Text("Uredi profil"));
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
                        Image.memory(
                          displayCurrentImage(),
                          width: null,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Korisničko ime:"),
                      name: "korisnickoIme",
                      initialValue: korisnik?.korisnickoIme,
                      enabled: false,
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Ime:"),
                      name: "ime",
                      initialValue: korisnik?.ime,
                      enabled: false,
                    ),
                    FormBuilderTextField(
                      name: "prezime",
                      enabled: false,
                      initialValue: korisnik?.prezime,
                      decoration: InputDecoration(labelText: "Prezime:"),
                    ),
                    FormBuilderTextField(
                      name: "telefon",
                      enabled: isEnabled,
                      initialValue: korisnik?.telefon,
                      decoration: InputDecoration(labelText: "Telefon:"),
                    ),
                    FormBuilderTextField(
                      name: "email",
                      enabled: isEnabled,
                      initialValue: korisnik?.email,
                      decoration: InputDecoration(labelText: "Email:"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    korisnik != null ? _editButton() : Container()
                  ],
                ),
              ),
            ),
          ),
        ));
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
