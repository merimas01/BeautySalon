import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:desktop_app/main.dart';
import 'package:desktop_app/screens/recenzije_list_screen.dart';
import 'package:desktop_app/screens/usluge_details_screen.dart';
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

import 'novosti_details_screen.dart';

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
    listUsluge = await _recenzijaUslugeProvider
        .GetProsjecnaOcjena(); //dodati jos i sifru u ovu listu
    listUsluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();
    var usluge = await _uslugeProvider.get(filter: {'isSlikaIncluded': true});
    var novosti = await _novostiProvider.GetLastThreeNovosti();
    print("NOVOSTI: ${novosti.result[0].naslov}");

    // for (var item in listUsluge) {
    //   print("${item}");
    // }

    // for (var item in listUsluznici) {
    //   print("${item}");
    // }

    // for (var item in usluge.result) {
    //   print(item.slikaUsluge != null ? "ima sliku" : "nema sliku");
    // }

    setState(() {
      //sifreUslugeList
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
              height: 10,
            ),
            textZaUsluge(),
            SizedBox(height: 10),
            _slidingImages(),
            SizedBox(
              height: 30,
            ),
            uvodniText(),
            SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Pogledajte posljednje objavljene novosti",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            _createGrids(),
            iznadBarChart(),
            SizedBox(
              height: 20,
            ),
            buttonRecenzije(),
            SizedBox(
              height: 60,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RepaintBoundary(
                      key: chartKey,
                      child: isLoadingUsluge == false
                          ? buildBarChartUsluge()
                          : Container(child: CircularProgressIndicator()),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    sifraUslugeList.length != 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Prosječne ocjene usluga",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
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
                        : Container(child: CircularProgressIndicator()),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Prosječne ocjene uslužnika",
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
                        : Container(child: CircularProgressIndicator()),
                    SizedBox(
                      width: 10,
                    ),
                    RepaintBoundary(
                      key: chartKey2,
                      child: isLoadingUsluznici == false
                          ? buildBarChartUsluznici()
                          : Container(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ],
            ),
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
              text: "🖐️", // Waving hand emoji
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            // TextSpan(
            //   text: '! Želimo Vam ugodno korištenje aplikacije!',
            //   style: TextStyle(fontWeight: FontWeight.normal),
            // ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget textZaUsluge() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text:
                  '\nObzirom da je primarni fokus ovog salona - LJEPOTA i njega iste, pogledajte sve beauty usluge koje naš salon nudi klijentima:',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget iznadBarChart() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\nNa narednim slikama, prikazani su štapićasti dijagami sa prosječnim ocjenama usluga/uslužnika' +
                    '(prikazane od najbolje ocijenjenih ka najlošije ocijenjenim).\nNa svakom štapiću piše naziv usluge/uslužnika i njegova prosječna ocjena, ' +
                    'ukoliko pređete kursorom preko njega. Detaljnije informacije o svakom dijagramu se nalaze u pdf dokumentima koje možete odmah preuzeti. ' +
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
    );
  }

  Widget uvodniText() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 10), // Animation duration
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 163, 202),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: AnimatedDefaultTextStyle(
            duration: Duration(seconds: 10),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Text(
              'Ova aplikacija je namjenjena administratoru i zaposlenicima. Služi za upravljanje funkcionalnostima salona, za uvid u zadovoljstvo kupaca sa uslugama i uslužnicima, za praćenje aktivnosti korisnika, kao i za kreiranje marketinga.',
              textAlign: TextAlign.center,
            ),
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
                    child: _hoverImage(novostSlika, novost, index),
                  );
                },
              ),
            ),
          )
        : Container();
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
            // Image widget
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

                    // Container(
                    //   // width:100,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(width: 2.0, color: Colors.pink),
                    //       color: Colors.pink,
                    //       shape: BoxShape.rectangle,
                    //       borderRadius:
                    //           BorderRadius.all(Radius.circular(10.0))),
                    //   //color:Colors.pink,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       "Naslov: ${novost?.naslov}",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(color: Colors.white, fontSize: 20),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // Button that appears on hover
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NovostiDetailsScreen(
                                  novost: novost,
                                )));
                      },
                      child:
                          Tooltip(message: "Detalji", child: Icon(Icons.info)),
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
                  imageBytes: slika != null ? base64Decode(slika) : null,
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
}
