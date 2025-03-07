import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/screens/moje_recenzije.dart';
import 'package:mobile_app/screens/moje_rezervacije.dart';
import 'package:mobile_app/screens/moji_favoriti.dart';
import 'package:mobile_app/screens/moji_komentari_novosti.dart';
import 'package:mobile_app/screens/moji_lajkovi_novosti.dart';
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
        selectedIndex: 3,
        title: "Moj profil",
        child: isLoading == false
            ? _buildForm()
            : Center(child: CircularProgressIndicator()));
  }

  Widget _naslov() {
    return Center(
      child: Text(
        "Moji podaci",
        textAlign: TextAlign.center,
        style: const TextStyle(
            //fontFamily: 'BeckyTahlia',
            fontSize: 26,
            color: Colors.pinkAccent),
      ),
    );
  }

  Widget buttonOdjava() => Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.memory(
                                displayCurrentImage(),
                                width: 300,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                //shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 250,
                                width: 300,
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
                  FormBuilderTextField(
                    name: "datumKreiranja",
                    enabled: isEnabled,
                    initialValue: korisnik?.datumKreiranja != null
                        ? formatDate(korisnik!.datumKreiranja!)
                        : "-",
                    decoration:
                        InputDecoration(labelText: "Datum registracije:"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  korisnik != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _mojeRecenzijeButton(),
                            _mojeRezervacijeButton(),
                            _mojiKomentariNovostiButton(),
                            _mojiLajkoviNovostiButton(),
                            _mojiFavoriti(),
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
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.pink,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MojeRecenzije()));
            },
            child: Text("Moje recenzije"))
      ],
    );
  }

  Widget _mojeRezervacijeButton() {
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          color: Colors.pink,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MojeRezervacije(
                        poslaniKorisnikId: LoggedUser.id,
                      )));
            },
            child: Text("Moje rezervacije"))
      ],
    );
  }

  Widget _mojiKomentariNovostiButton() {
    return Row(
      children: [
        Icon(
          Icons.comment,
          color: Colors.pink,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MojiKomentariNovosti()));
            },
            child: Text("Moji komentari o novostima"))
      ],
    );
  }

  Widget _mojiLajkoviNovostiButton() {
    return Row(
      children: [
        Icon(
          Icons.thumb_up,
          color: Colors.pink,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      MojiLajkoviNovosti(poslaniKorisnikId: LoggedUser.id)));
            },
            child: Text("Moja sviđanja novosti"))
      ],
    );
  }

  Widget _mojiFavoriti() {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.pink,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MojiFavoriti()));
            },
            child: Text("Moji favoriti"))
      ],
    );
  }

  Uint8List displayCurrentImage() {
    Uint8List imageBytes = base64Decode(korisnik!.slikaProfila!.slika);
    return imageBytes;
  }
}
