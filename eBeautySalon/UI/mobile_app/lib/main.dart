import 'package:mobile_app/models/favoriti_usluge.dart';
import 'package:mobile_app/providers/favoriti_usluge_provider.dart';
import 'package:mobile_app/providers/kategorije_provider.dart';
import 'package:mobile_app/providers/korisnik_provider.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/providers/novost_provider.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/providers/recenzije_usluznika_provider.dart';
import 'package:mobile_app/providers/rezervacije_provider.dart';
import 'package:mobile_app/providers/slika_profila_provider.dart';
import 'package:mobile_app/providers/status_provider.dart';
import 'package:mobile_app/providers/termini_provider.dart';
import 'package:mobile_app/providers/usluga_termin_provider.dart';
import 'package:mobile_app/providers/usluge_provider.dart';
import 'package:mobile_app/providers/zaposlenici_provider.dart';
import 'package:mobile_app/screens/home_page.dart';
import 'package:mobile_app/screens/pretraga_page.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/screens/registracija_page.dart';
import 'package:mobile_app/screens/rezervacije_page.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      //dependency injection
      ChangeNotifierProvider(create: (_) => UslugeProvider()),
      ChangeNotifierProvider(create: (_) => KategorijeProvider()),
      ChangeNotifierProvider(create: (_) => SlikaProfilaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => ZaposleniciProvider()),
      ChangeNotifierProvider(create: (_) => NovostiProvider()),
      ChangeNotifierProvider(create: (_) => RecenzijaUslugeProvider()),
      ChangeNotifierProvider(create: (_) => RecenzijaUsluznikaProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijeProvider()),
      ChangeNotifierProvider(create: (_) => StatusiProvider()),
      ChangeNotifierProvider(create: (_) => TerminProvider()),
      ChangeNotifierProvider(create: (_) => UslugeTerminiProvider()),
      ChangeNotifierProvider(create: (_) => NovostLikeCommentProvider()),
      ChangeNotifierProvider(create: (_) => FavoritiUslugeProvider()),
    ],
    child: MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neki naslov',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                primary: Colors.pink,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic
                ))),
      ),
      home: LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == HomePage.routeName) {
          return MaterialPageRoute(builder: ((context) => HomePage()));
        } else if (settings.name == PretragaPage.routeName) {
          return MaterialPageRoute(builder: ((context) => PretragaPage()));
        } else if (settings.name == RezervacijePage.routeName) {
          return MaterialPageRoute(builder: ((context) => RezervacijePage()));
        } else if (settings.name == ProfilPage.routeName) {
          return MaterialPageRoute(builder: ((context) => ProfilPage()));
        }

        var uri = Uri.parse(settings.name!);
        // if (uri.pathSegments.length == 2 &&
        //     "/${uri.pathSegments.first}" == NovostDetailsScreen.routeName) {
        //   var id = uri.pathSegments[1];
        //   return MaterialPageRoute(builder: (context) => NovostDetailsScreen(id: id));
        // }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _korisnickoImeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late KorisnikProvider _korisnikProvider;

  @override
  Widget build(BuildContext context) {
    _korisnikProvider = context.read<KorisnikProvider>();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Prijava"),
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: Container(
              constraints: BoxConstraints(maxWidth: 450, maxHeight: 550),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/slika4.png",
                        height: 170,
                        width: 170,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Salon ljepote 'Precious'",
                        style: TextStyle(
                            fontFamily: 'BeckyTahlia',
                            fontSize: 26,
                            color: Colors.pinkAccent),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Prijavite se putem sljedeće forme:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                          fontFamily: 'DejaVuSans',
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo Vas unesite korisničko ime (minimalno 3 karaktera)';
                            }
                            if (!RegExp(r'^[a-zA-Z]{1,}[a-zA-Z\d-_.]{2,}$')
                                .hasMatch(value)) {
                              return 'Korisničko ime treba imati najmanje 3 karaktera,\ntreba počinjati sa slovom i smije sadržavati: \nslova bez afrikata, brojeve i sljedeće znakove: ._-';
                            }
                            return null;
                          },
                          controller: _korisnickoImeController,
                          decoration: InputDecoration(
                              labelText: "Korisničko ime",
                              labelStyle: TextStyle(fontSize: 14),
                              prefixIcon: Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.pink),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 238, 0, 79),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo Vas unesite lozinku';
                          }
                          if (!RegExp(r'[\u0000-\uFFFF]{3,}').hasMatch(value)) {
                            return 'Vaša lozinka treba sačinjavati minimalno 3 znaka';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Lozinka",
                            labelStyle: TextStyle(fontSize: 14),
                            prefixIcon: Icon(Icons.password),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.pink),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 238, 0, 79),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            )),
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 36,
                        width: 450,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255)),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.pink),
                              side: MaterialStateProperty.all(BorderSide(
                                color: Colors.pink,
                                width: 1.0,
                                style: BorderStyle.solid,
                              )),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.pink)))),
                          onPressed: () async {
                            print("pritisnuto dugme Prijavi se");

                            var korisnickoIme = _korisnickoImeController.text;
                            var password = _passwordController.text;

                            print(" $korisnickoIme $password");

                            LoggedUser.korisnickoIme = korisnickoIme;

                            Authorization.username = korisnickoIme;
                            Authorization.password = password;

                            try {
                              var val = _formKey.currentState!.validate();
                              print("${val}");

                              if (val) {
                                var obj = await _korisnikProvider.get();
                                if (obj != null) {
                                  var list = obj.result
                                      .where(
                                        (korisnik) =>
                                            korisnik.korisnickoIme! ==
                                            Authorization.username,
                                      )
                                      .toList();
                                  var korisnik =
                                      list.length != 0 ? list[0] : null;

                                  if (korisnik != null) {
                                    LoggedUser.id = korisnik.korisnikId;
                                    LoggedUser.slika =
                                        korisnik.slikaProfila?.slika;
                                    LoggedUser.ime = korisnik.ime;
                                    LoggedUser.prezime = korisnik.prezime;
                                    LoggedUser.uloga =
                                        korisnik.korisnikUlogas?.length != 0
                                            ? korisnik
                                                .korisnikUlogas![0].uloga!.naziv
                                            : "";

                                    print(
                                        "loggedUser id: ${LoggedUser.id}, ima sliku? ${LoggedUser.slika != "" ? "da" : "ne"}");
                                    if (korisnik.status == false) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text("Greška"),
                                                content: const Text(
                                                    "Nedozvoljena prijava. Vaš račun je blokiran."),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("Ok"))
                                                ],
                                              ));
                                    } else if (LoggedUser.uloga != "")
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text("Greška"),
                                                content: const Text(
                                                    "Nedozvoljena prijava. Molimo pokušajte ponovo."),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("Ok"))
                                                ],
                                              ));
                                    else {
                                      Navigator.pushNamed(
                                          context, HomePage.routeName);
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => const HomePage()));
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text("Greška"),
                                              content: const Text(
                                                  "Neispravni podaci. Molimo pokušajte ponovo."),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Ok"))
                                              ],
                                            ));
                                  }
                                }
                              }
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Greška"),
                                        content: const Text(
                                            "Neispravni podaci. Molimo pokušajte ponovo."),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Ok"))
                                        ],
                                      ));
                            }
                          },
                          child: Text("Prijavi se",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Nemate račun?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.pink),
                            ),
                            onPressed: () {
                              print("registracija button");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistracijaPage()));
                            },
                            child: Text("Registracija",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ))),
        )));
  }
}
