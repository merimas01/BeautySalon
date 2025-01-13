import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:desktop_app/main.dart';
import 'package:desktop_app/screens/profil_page.dart';
import 'package:desktop_app/screens/recenzije_list_screen.dart';
import 'package:desktop_app/screens/rezervacije_list_screen.dart';
import 'package:desktop_app/screens/usluge_details_screen.dart';
import 'package:desktop_app/screens/usluge_list_screen.dart';
import 'package:desktop_app/screens/usluge_termini_list_screen.dart';
import 'package:desktop_app/screens/zaposlenici_list_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/novost.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/novosti_provider.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/usluge_provider.dart';
import '../widgets/hoverable_image.dart';
import '../widgets/master_screen.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

import 'kategorije_list_screen.dart';
import 'korisnici_list_screen.dart';
import 'novosti_details_screen.dart';
import 'novosti_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey chartKey = GlobalKey();
  final GlobalKey chartKey2 = GlobalKey();
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  late UslugeProvider _uslugeProvider;
  late NovostiProvider _novostiProvider;
  SearchResult<Novost>? _resultNovosti;
  List<Usluga>? slikeUsluga;
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  bool isLoadingSlike = true;
  List<dynamic> listUsluge = [];
  List<dynamic> listUsluznici = [];
  int listUslugeCount = 0;
  int listUsluznikCount = 0;
  List<String> nazivUslugeList = [];
  List<String> nazivUsluznikaList = [];
  List<String> sifraUslugeList = [];
  List<String> sifraUsluznikaList = [];
  File? _pdfFileUsluge;
  File? _pdfFileUsluznici;
  int pdfUsluge = 0;
  int pdfUsluznici = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  var listUslugeNumbers = [];
  bool _isHovered = false;
  bool authorised = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    _novostiProvider = context.read<NovostiProvider>();

    initForm();
  }

  void initForm() async {
    listUsluge = await _recenzijaUslugeProvider.GetProsjecnaOcjena();
    listUsluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();
    var usluge = await _uslugeProvider.get(filter: {'isSlikaIncluded': true});
    var novosti = await _novostiProvider.GetLastThreeNovosti();

    setState(() {
      nazivUslugeList =
          listUsluge.map((usluga) => usluga['nazivUsluge'] as String).toList();
      sifraUslugeList =
          listUsluge.map((usluga) => usluga['sifraUsluge'] as String).toList();
      listUslugeCount = listUsluge.length;
      isLoadingUsluge = false;
    });

    setState(() {
      nazivUsluznikaList = listUsluznici
          .map((usluznik) => usluznik['nazivUsluznik'] as String)
          .toList();
      sifraUsluznikaList = listUsluznici
          .map((usluznik) => usluznik['sifraUsluznik'] as String)
          .toList();
      listUsluznikCount = listUsluznici.length;
      isLoadingUsluznici = false;
    });

    setState(() {
      slikeUsluga = usluge.result;
      isLoadingSlike = false;
    });

    setState(() {
      _resultNovosti = novosti;
    });

    setState(() {
      if (LoggedUser.uloga == "Administrator") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Početna stranica"),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [buttonOdjava()],
            ),
            welcomeMessageText(),
            SizedBox(
              height: 50,
            ),
            SizedBox(
                height: 1,
                child: Container(
                  color: Colors.pink,
                )),
            SizedBox(
              height: 50,
            ),
            _ikonice(),
            SizedBox(
              height: 30,
            ),
            textZaUsluge(),
            SizedBox(height: 20),
            _slidingImages(),
            SizedBox(
              height: 40,
            ),
            _textZaNovosti(),
            SizedBox(
              height: 20,
            ),
            _createGrids(),
            authorised == true ? iznadBarChart() : Container(),
            authorised == true
                ? SizedBox(
                    height: 20,
                  )
                : Container(),
            authorised == true ? buttonRecenzije() : Container(),
            SizedBox(
              height: 60,
            ),
            isLoadingUsluge == false && isLoadingUsluznici == false
                ? authorised == true
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RepaintBoundary(
                                key: chartKey,
                                child: buildBarChartUsluge(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              sifraUslugeList.length != 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Prosječne ocjene usluga 💄",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "Za više detalja preuzmite PDF dokument ispod."),
                                        SizedBox(height: 20),
                                        buttonPrintajPDFUsluge(),
                                      ],
                                    )
                                  : Container(
                                      child: CircularProgressIndicator()),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            child: Container(color: Colors.pink),
                            height: 1,
                            width: 300,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              sifraUsluznikaList.length != 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Prosječne ocjene uslužnika 👧",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "Za više detalja preuzmite PDF dokument ispod."),
                                        SizedBox(height: 20),
                                        buttonPrintajPDFUsluznici(),
                                      ],
                                    )
                                  : Container(
                                      child: CircularProgressIndicator()),
                              SizedBox(
                                width: 10,
                              ),
                              RepaintBoundary(
                                  key: chartKey2,
                                  child: buildBarChartUsluznici()),
                            ],
                          ),
                        ],
                      )
                    : Container()
                : Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogPDF(BuildContext context, bool isUsluge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'PDF je spreman',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Kliknite "Preuzmi PDF" da preuzmete PDF na željenu lokaciju.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
                child: ElevatedButton(
              child: Text('Preuzmi PDF'),
              onPressed: () async {
                isUsluge ? openPDFUsluge() : openPDFUsluznik();
                Navigator.of(context).pop();
              },
            ))
          ],
        );
      },
    );
  }

  Widget buttonOdjava() => Padding(
        padding: const EdgeInsets.all(8.0),
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

  // Widget discoverServicesText() {
  //   return Center(
  //       child: RichText(
  //     text: TextSpan(
  //         style: TextStyle(
  //             fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),
  //         children: [
  //           TextSpan(text: "Istražite servise koje aplikacija nudi!")
  //         ]),
  //   ));
  // }

  Widget welcomeMessageText() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'Dobrodošli, ',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: "${LoggedUser.ime} ${LoggedUser.prezime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
                fontSize: 23,
              ),
            ),
            TextSpan(
              text: " 🖐️",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _textZaNovosti() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1200,
        child: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Kreiranjem novosti, ne samo da kreiramo dobar marketing i promoviramo naš salon, nego i obaviještavamo klijente ' +
                      '- o novim pogodnostima, novim uslugama, o mogućnostima zaposlenja, '
                          'pišemo članke o ljepoti... Na osnovu čega se stvara veza između klijenata i samog salona. U svrhu da ' +
                      'tu vezu održimo, ne smijemo stati kreirati. ' +
                      "U nastavku su prikazane posljednje tri novosti. 🔍",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget textZaUsluge() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1200,
        child: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '\nLjepota je karakteristika svakoga od nas. Kreirati salon koji će se baviti održavanjem, ' +
                      'uljepšavanjem i njegovanjem iste, je jedan od većih satisfakcija koje čovjek može imati. ' +
                      'Njegovanjem vanjske ljepote u ovom salonu se naši klijenti odmaraju, relaksiraju i opuštaju, ' +
                      'čime njeguju svoj psihički duh. Zavirite u sve usluge koji je naš salon pripremio svim klijentima ' +
                      'koji žele pružiti sebi nekoliko minuta ljubavi i uživanja. 🌷',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget iznadBarChart() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Center(
        child: Container(
          width: 1200,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '\nRecenzije daju uvid u poslovanje našeg salona, stoga su jako bitne. Na narednim slikama, prikazani su štapićasti dijagami sa prosječnim ocjenama usluga/uslužnika.' +
                      ' Ukoliko pređete kursorom preko štapića, vidjet ćete naziv usluge/uslužnika i njihove prosječne ocjene. ' +
                      ' Detaljnije informacije o svakom dijagramu se nalaze u pdf dokumentima koje možete odmah preuzeti. ' +
                      'Pojedinačne recenzije od svakog korisnika se mogu vidjeti pritiskom na dugme ispod.',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildBarChartUsluge() {
    return sifraUslugeList.length != 0
        ? SizedBox(
            width: 500,
            height: 300,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label = nazivUslugeList[group.x.toInt()];
                      return BarTooltipItem(
                        'Prosječna ocjena: ${rod.toY.toStringAsFixed(2)}\nUsluga: ${label}',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                barGroups: generateData(listUsluge),
                minY: 1,
                maxY: 5,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 28)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        final labels =
                            sifraUslugeList; //dohvatiti šifru ovde - sifreUslugeList

                        return Text(
                          labels.isNotEmpty ? labels[index] : "", //"${index}"
                          style: TextStyle(fontSize: 12),
                          softWrap:
                              true, // Allows text to wrap to the next line
                          overflow:
                              TextOverflow.visible, // Ensures all text is shown
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceEvenly,
                //groupsSpace: 50,
              ),
            ),
          )
        : Text("Nema podataka.");
  }

  Widget buildBarChartUsluznici() {
    return sifraUsluznikaList.length != 0
        ? SizedBox(
            width: 500,
            height: 300,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label = nazivUsluznikaList[group.x.toInt()];
                      return BarTooltipItem(
                        'Prosječna ocjena: ${rod.toY.toStringAsFixed(2)}\nUslužnik: ${label}',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                barGroups: generateData(listUsluznici),
                minY: 1,
                maxY: 5,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 28)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        final labels = sifraUsluznikaList;

                        return Text(
                          labels.isNotEmpty ? labels[index] : "",
                          style: TextStyle(fontSize: 10),
                          softWrap:
                              true, // Allows text to wrap to the next line
                          overflow:
                              TextOverflow.visible, // Ensures all text is shown
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceEvenly,
              ),
            ),
          )
        : Text("Nema podataka.");
  }

  Widget buttonRecenzije() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 255, 255, 255)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.pink),
          side: MaterialStateProperty.all(BorderSide(
            color: Colors.pink,
            width: 1.0,
            style: BorderStyle.solid,
          )),
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RecenzijeListScreen()));
        },
        child: Text("Pogledaj sve recenzije"));
  }

  Widget buttonPrintajPDFUsluge() {
    return ElevatedButton(
        onPressed: () {
          generatePDF();
        },
        child: Text("Generiši PDF dokument"));
  }

  Widget buttonPrintajPDFUsluznici() {
    return ElevatedButton(
        onPressed: () {
          generatePDFUsluznici();
        },
        child: Text("Generiši PDF dokument"));
  }

  void generatePDF() async {
    // Capture chart image
    final chartImage = await captureChartImageUsluge();

    // Create PDF document
    final pdf = pw.Document();

    // Load the custom font from assets
    final ByteData bytes = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
    //final Uint8List fontBytes = bytes.buffer.asUint8List();
    final ttf = pw.Font.ttf(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Izvještaj o recenzijama usluga",
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Datum: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
              pw.SizedBox(height: 20),
              pw.Text("Preuzeo: ${LoggedUser.ime} ${LoggedUser.prezime}"),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                height: 1,
                child: pw.Container(
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Nazivi usluga",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "U sljedećoj tabeli prikazane su sve ocijenjivane usluge i njihove šifre.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Šifra usluge",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Usluga",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                    ],
                  ),
                  for (var item in listUsluge)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text("${item['sifraUsluge']}",
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['nazivUsluge'].toString(),
                              style: pw.TextStyle(font: ttf)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Detalji recenzija",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                "U sljedećoj tabeli prikazane su sve ocijenjivane usluge, sa svim ocijenama koje imaju. Prikazana je i prosječna ocjena za svaku od njih.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.normal,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Šifra usluge",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Ocjene",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Prosječna ocjena",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            font: ttf,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var item in listUsluge)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text("${item['sifraUsluge']}",
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['sveOcjene'].join(", "),
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['prosjecnaOcjena'].toString(),
                              style: pw.TextStyle(font: ttf)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Štapićasti dijagram",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                "Na dijagramu su prikazane sve usluge koje su ocjenjivane. Na x-osi su predstavljene šifre usluga (koje su također predstavljene u prvoj tabeli). Na y-osi na desnoj strani su prikazane prosječne ocjene usluga koje se kreću od 1-5. \nUsluge koje nisu prikazane na dijagramu, nisu nijednom recenzirane.\nNa osnovu dijagrama se primjećuje koje usluge imaju najveću prosječnu ocjenu, kao i one koje imaju najnižu, te stoga se može zaključiti koje usluge se klijentima najviše sviđaju, a koje najmanje.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),

              pw.SizedBox(height: 50),

              pw.Container(
                height: 200,
                child: pw.Center(
                  child: pw.Image(pw.MemoryImage(chartImage)),
                ),
              ),
              // Adding the chart image
              // pw.Image(
              //   pw.MemoryImage(chartImage),
              //   width: 400, // Customize as needed
              //   height: 500,
              // )
            ],
          );
        },
      ),
    );

    // Save PDF file
    final output = await getApplicationDocumentsDirectory();
    //final directory = await getTemporaryDirectory();
    final file = File("${output.path}/izvjestajRecenzijaUsluga.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");

    setState(() {
      _pdfFileUsluge = file;

      if (_pdfFileUsluge != null) {
        print("is pdf ready true");
        _showDialogPDF(context, true);
      }
    });
  }

  void openPDFUsluge() async {
    pdfUsluge++;
    if (_pdfFileUsluge != null) {
      // Allow the user to select where to save the file
      String? outputFilePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF to...',
        fileName: 'izvjestajRecenzijaUsluga${pdfUsluge}.pdf',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );

      if (outputFilePath != null) {
        // Copy the generated PDF to the selected location
        try {
          await _pdfFileUsluge!.copy(outputFilePath);

          // Open the saved PDF
          await OpenFile.open(outputFilePath);
        } catch (e) {
          //print("error catched");
          _showDialogPDF(context, true);
        }
      }
    }
  }

  void generatePDFUsluznici() async {
    // Capture chart image
    final chartImage = await captureChartImageUsluznici();

    // Create PDF document
    final pdf = pw.Document();

    // Load the custom font from assets
    final ByteData bytes = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
    //final Uint8List fontBytes = bytes.buffer.asUint8List();
    final ttf = pw.Font.ttf(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Izvještaj o recenzijama uslužnika",
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Datum: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
              pw.SizedBox(height: 20),
              pw.Text("Preuzeo: ${LoggedUser.ime} ${LoggedUser.prezime}"),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                height: 1,
                child: pw.Container(
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Imena uslužnika",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "U sljedećoj tabeli prikazani su svi ocijenjivani uslužnici i njihove šifre.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Šifra uslužnika",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Ime i prezime uslužnika",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                    ],
                  ),
                  for (var item in listUsluznici)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text("${item['sifraUsluznik']}",
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['nazivUsluznik'].toString(),
                              style: pw.TextStyle(font: ttf)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Detalji recenzija",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "U sljedećoj tabeli prikazane su svi ocijenjivani uslužnici, sa svim ocjenama koje imaju. Prikazana je i prosječna ocjena za svakog od njih.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Šifra uslužnika",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Ocjene",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Prosječna ocjena",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            font: ttf,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var item in listUsluznici)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['sifraUsluznik'],
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['sveOcjene'].join(", "),
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(item['prosjecnaOcjena'].toString(),
                              style: pw.TextStyle(font: ttf)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // dodaj novu stranicu
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Dijagram (Bar chart)",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                "Na dijagramu su prikazani svi uslužnici koji su ocjenjivani. Na x-osi su predstavljene šifre uslužnika (koje su također predstavljene u prvoj tabeli). Na y-osi na desnoj strani su prikazane prosječne ocjene uslužnika koje se kreću od 1-5. \nUslužnici koje nisu prikazani na dijagramu, nisu nijednom recenzirani.\nNa osnovu dijagrama se primjećuje koji uslužnici imaju najveću prosječnu ocjenu, kao i one koje imaju najnižu, te stoga se može zaključiti koje uslužnici se klijentima najviše sviđaju, a koji najmanje.",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),

              pw.SizedBox(height: 50),
              pw.SizedBox(
                height: 20,
              ),
              // Adding the chart image
              pw.Image(
                pw.MemoryImage(chartImage),
                width: 400, // Customize as needed
                height: 300,
              )
            ],
          );
        },
      ),
    );

    // Save PDF file
    final output = await getApplicationDocumentsDirectory();
    //final directory = await getTemporaryDirectory();
    final file = File("${output.path}/izvjestajRecenzijaUsluznika.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");

    setState(() {
      _pdfFileUsluznici = file;

      if (_pdfFileUsluznici != null) {
        print("is pdf ready true");
        _showDialogPDF(context, false);
      }
    });
  }

  void openPDFUsluznik() async {
    pdfUsluznici++;
    if (_pdfFileUsluznici != null) {
      // // Allow the user to select where to save the file
      String? outputFilePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF to...',
        fileName: 'izvjestajRecenzijaUsluznika${pdfUsluznici}.pdf',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );

      if (outputFilePath != null) {
        // Copy the generated PDF to the selected location
        try {
          await _pdfFileUsluznici!.copy(outputFilePath);

          // Open the saved PDF
          await OpenFile.open(outputFilePath);
        } catch (e) {
          //print("error catched");
          _showDialogPDF(context, false);
        }
      }
    }

    // final output = await getApplicationDocumentsDirectory();
    // final filePath =
    //     "${output.path}/izvjestajRecenzijaUsluznika${pdfUsluznici}.pdf";
    //OpenFile.open(filePath);
  }

  Future<Uint8List> captureChartImageUsluge() async {
    try {
      RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      throw Exception("Error capturing chart: $e");
    }
  }

  Future<Uint8List> captureChartImageUsluznici() async {
    RenderRepaintBoundary boundary =
        chartKey2.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  List<BarChartGroupData> generateData(List<dynamic> dataset) {
    dataset
        .sort((a, b) => b['prosjecnaOcjena'].compareTo(a['prosjecnaOcjena']));
    final random = Random();
    return List.generate(dataset.length, (index) {
      final obj = dataset[index];
      final double value = obj['prosjecnaOcjena'].toDouble();

      // Random color for each bar
      Color barColor = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: barColor,
            width: 25,
          ),
        ],
      );
    });
  }

  final PageController _pageController = PageController();

  int _currentPage = 0;

  void _goToNextPage() {
    if (slikeUsluga != null) {
      if (_currentPage < slikeUsluga!.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _goToPreviousPage() {
    if (slikeUsluga != null) {
      if (_currentPage > 0) {
        _currentPage--;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _createGrids() {
    return _resultNovosti != null
        ? SizedBox(
            height: 350,
            width: 1000,
            child: Container(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      _resultNovosti!.result.length, // grids horizontally
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                ),
                itemCount: _resultNovosti!.result.length, // grids in total
                itemBuilder: (context, index) {
                  final novost = _resultNovosti!.result[index];
                  final novostSlika =
                      _resultNovosti!.result[index].slikaNovost?.slika;
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.0,
                            color: Color.fromARGB(255, 221, 98, 159)),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: _hoverImage(
                        novostSlika != "" && novostSlika != null
                            ? novostSlika
                            : null,
                        novost,
                        index),
                  );
                },
              ),
            ),
          )
        : Container(child: CircularProgressIndicator());
  }

  int _hoveredIndex = -1;

  Widget _hoverImage(imageBytes, novost, index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTap: () {
          print("on tap");
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageBytes != null
                ? ColorFiltered(
                    colorFilter: _hoveredIndex == index
                        ? _normalFilter()
                        : _darkerFilter(),
                    child: Image.memory(
                      base64Decode(imageBytes!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Nema slike",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

            // Show text and button only when hovered
            if (_hoveredIndex == index)
              Positioned(
                bottom: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text that appears on hover
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: Colors.white),
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${novost.naslov}", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          softWrap: true,
                          maxLines: 2, // Limits the text to 2 lines
                          overflow: TextOverflow
                              .ellipsis, // Adds "..." if the text exceeds max lines
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NovostiDetailsScreen(
                                  novost: novost,
                                )));
                      },
                      child: Tooltip(
                          message: "Detalji",
                          child: Icon(Icons.info, color: Colors.white)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Brightness filter for hover
  ColorFilter _darkerFilter() {
    return ColorFilter.matrix(<double>[
      0.8, 0, 0, 0, 10, // Red (slightly less pink)
      0, 0.7, 0, 0, -20, // Green (muted for grey)
      0, 0, 0.8, 0, 10, // Blue (less enhanced for a softer pink)
      0, 0, 0, 1, 0, // Alpha
    ]);
  }

  /// Normal filter (no brightness change)
  ColorFilter _normalFilter() {
    return ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0, // Red
      0, 1, 0, 0, 0, // Green
      0, 0, 1, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ]);
  }

  Widget _slidingImages() {
    if (slikeUsluga != null) {
      return Column(
        children: [
          SizedBox(
            height: 450,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slikeUsluga?.length ?? 0,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final slika = slikeUsluga?[index].slikaUsluge?.slika;
                // return _hoverImage(slika != null ? base64Decode(slika) : null,
                //     slikeUsluga![index]);
                return HoverableImage(
                  usluga: slikeUsluga![index],
                  imageBytes:
                      slika != null && slika != "" ? base64Decode(slika) : null,
                  onTap: () {
                    print("${slikeUsluga![index].uslugaId}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UslugeDetaljiScreen(
                              usluga: slikeUsluga![index],
                            )));
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                child: Tooltip(
                    child: Icon(Icons.arrow_left), message: "Prethodna"),
              ),
              Text('${_currentPage + 1}/${slikeUsluga!.length}'),
              ElevatedButton(
                onPressed: _currentPage < slikeUsluga!.length - 1
                    ? _goToNextPage
                    : null,
                child: Tooltip(
                    child: Icon(Icons.arrow_right), message: "Sljedeća"),
              ),
            ],
          ),
        ],
      );
    } else
      return Container(child: CircularProgressIndicator());
  }

  Widget _ikonice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KategorijeListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje kategorijama",
                  child: Icon(Icons.category, color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UslugeListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje uslugama",
                  child: Icon(
                    Icons.face_retouching_natural,
                    color: Colors.white,
                  ))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RezervacijeListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje rezervacijama",
                  child: Icon(Icons.notes_outlined, color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UslugeTerminiListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje terminima",
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RecenzijeListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje recenzijama",
                  child: Icon(Icons.star, color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KorisniciListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje korisnicima",
                  child: Icon(Icons.people, color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ZaposleniciListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje zaposlenicima",
                  child: Icon(Icons.work, color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NovostiListScreen()));
              },
              child: Tooltip(
                  message: "Upravljanje novostima",
                  child: Icon(Icons.screen_search_desktop_rounded,
                      color: Colors.white))),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilPage()));
              },
              child: Tooltip(
                  message: "Upravljanje profilom",
                  child: Icon(Icons.person, color: Colors.white))),
        ),
      ],
    );
  }
}
