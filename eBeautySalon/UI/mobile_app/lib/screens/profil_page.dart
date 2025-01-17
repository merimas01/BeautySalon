import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/screens/moje_recenzije.dart';
import 'package:mobile_app/screens/moje_rezervacije.dart';
import 'package:mobile_app/screens/profil_edit.dart';
import 'package:provider/provider.dart';

import '../main.dart';
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
    initForm();
  }

  Future initForm() async {
    if (LoggedUser.id != null) {
      var data = await _korisniciProvider.getById(LoggedUser.id!);

      setState(() {
        korisnik = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Moj profil",
        child: isLoading == false
            ? _buildForm()
            : Center(child: CircularProgressIndicator()));
  }

  Widget _naslov() {
    return Text(
      "Moji podaci",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.pinkAccent),
    );
  }

  Widget buttonOdjava() => Container(
        // width: 800,
        // height: 100,
        child: TextButton(
          onPressed: () {
            //clear data
            LoggedUser.clearData();

            Authorization.username = "";
            Authorization.password = "";

            //navigate to login
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Tooltip(
            message: 'Odjavi se',
            child: Icon(
              Icons.logout,
              size: 25,
            ),
          ),
        ),
      );

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        child: Container(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonOdjava(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _naslov(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      korisnik != null &&
                              (korisnik?.slikaProfila != null &&
                                  korisnik?.slikaProfila?.slika != null) &&
                              korisnik?.slikaProfila?.slika != ""
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.memory(
                                displayCurrentImage(),
                                width: null,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 250,
                                width: null,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Korisničko ime:"),
                    name: "korisnickoIme",
                    initialValue: korisnik?.korisnickoIme ?? "",
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Ime:"),
                    name: "ime",
                    initialValue: korisnik?.ime ?? "",
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    name: "prezime",
                    enabled: false,
                    initialValue: korisnik?.prezime ?? "",
                    decoration: InputDecoration(labelText: "Prezime:"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    name: "telefon",
                    enabled: isEnabled,
                    initialValue: korisnik?.telefon ?? "",
                    decoration: InputDecoration(labelText: "Telefon:"),
                  ),
                  SizedBox(
                    height: 10,
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
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _mojeRecenzijeButton(),
                            _mojeRezervacijeButton(),
                            _editButton(),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _editButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilEditScreen(
                    korisnik: korisnik,
                  )));
        },
        child: Text("Uredi profil"));
  }

  Widget _mojeRecenzijeButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MojeRecenzije(
                    korisnik: korisnik,
                  )));
        },
        child: Text("Moje recenzije"));
  }

  Widget _mojeRezervacijeButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MojeRezervacije(
                    korisnik: korisnik,
                  )));
        },
        child: Text("Moje rezervacije"));
  }

  Uint8List displayCurrentImage() {
    Uint8List imageBytes = base64Decode(korisnik!.slikaProfila!.slika);
    return imageBytes;
  }
}
