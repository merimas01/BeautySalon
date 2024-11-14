import 'dart:math';
import 'dart:ui';

import 'package:desktop_app/main.dart';
import 'package:desktop_app/screens/recenzije_list_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../widgets/master_screen.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

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
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  List<dynamic> listUsluge = [];
  List<dynamic> listUsluznici = [];
  int listUslugeCount = 0;
  int listUsluznikCount = 0;
  List<String> nazivUslugeList = [];
  List<String> nazivUsluznikaList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();

    initForm();
  }

  void initForm() async {
    listUsluge = await _recenzijaUslugeProvider.GetProsjecnaOcjena();
    listUsluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();

    for (var item in listUsluge) {
      print("${item}");
    }

    for (var item in listUsluznici) {
      print("${item}");
    }

    setState(() {
      nazivUslugeList =
          listUsluge.map((usluga) => usluga['nazivUsluge'] as String).toList();
      listUslugeCount = listUsluge.length;
      isLoadingUsluge = false;
    });

    setState(() {
      nazivUsluznikaList = listUsluznici
          .map((usluznik) => usluznik['nazivUsluznik'] as String)
          .toList();
      listUsluznikCount = listUsluznici.length;
      isLoadingUsluznici = false;
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
              height: 30,
            ),
            uvodniText(),
            SizedBox(
              height: 30,
            ),
            iznadBarChart(),
            SizedBox(
              height: 30,
            ),
            buttonRecenzije(),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Prosječne ocjene usluga",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RepaintBoundary(
                      key: chartKey,
                      child: isLoadingUsluge == false
                          ? buildBarChartUsluge()
                          : Container(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    nazivUslugeList.length != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonPrintajPDFUsluge(),
                            ],
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
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
                      height: 30,
                    ),
                    RepaintBoundary(
                      key: chartKey2,
                      child: isLoadingUsluznici == false
                          ? buildBarChartUsluznici()
                          : Container(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    nazivUsluznikaList.length != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonPrintajPDFUsluznici(),
                            ],
                          )
                        : Container(),
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
              text: '! Želimo Vam ugodno korištenje aplikacije!',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        textAlign: TextAlign.center,
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
                text:
                    '\nNa narednim slikama, prikazani su dijagami (bar chart) sa prosječnim ocjenama usluga/uslužnika (prikazane od najbolje ocijenjenih ka najlošije ocijenjenim).',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
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
    return nazivUslugeList.length !=0 ? SizedBox(
      width: 400,
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
              ),),
          barGroups: generateData(listUsluge),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final labels = nazivUslugeList;

                  return Text(
                    labels[index],
                    style: TextStyle(fontSize: 10),
                    softWrap: true, // Allows text to wrap to the next line
                    overflow: TextOverflow.visible, // Ensures all text is shown
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
    ) : Text("Nema podataka.");
  }

  Widget buildBarChartUsluznici() {
    return nazivUsluznikaList.length != 0 ? SizedBox(
      width: 400,
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
              ),),
          barGroups: generateData(listUsluznici),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final labels = nazivUsluznikaList;

                  return Text(
                    labels.isNotEmpty ? labels[index] : "empty",
                    style: TextStyle(fontSize: 10),
                    softWrap: true, // Allows text to wrap to the next line
                    overflow: TextOverflow.visible, // Ensures all text is shown
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceEvenly,
        ),
      ),
    ) : Text("Nema podataka.");
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
        child: Text("Isprintaj PDF dokument"));
  }

  Widget buttonPrintajPDFUsluznici() {
    return ElevatedButton(
        onPressed: () {
          generatePDFUsluznici();
        },
        child: Text("Isprintaj PDF dokument"));
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
                  fontSize: 30,
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
                "Usluge",
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "U sljedećoj tabeli prikazane su sve ocijenjivane usluge, sa svim ocijenama koje imaju. Prikazana je i prosječna ocjena za svaku od njih.",
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
                          "Naziv usluge",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Ocjene",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Prosječna ocjena",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
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
                          child: pw.Text(item['nazivUsluge'],
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
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                "Na dijagramu su prikazane sve usluge koje su ocjenjivane. Uslužnici koje nisu prikazani na dijagramu, nisu nijednom recenzirani.\nNa osnovu dijagrama se primjećuje koje usluge imaju najveću prosječnu ocjenu, kao i one koje imaju najnižu.",
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 15,
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
    final file = File("${output.path}/izvjestajRecenzijaUsluga.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");

    openPDFUsluge();
  }

  void openPDFUsluge() async {
    final output = await getApplicationDocumentsDirectory();
    final filePath = "${output.path}/izvjestajRecenzijaUsluga.pdf";
    OpenFile.open(filePath);
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
                  fontSize: 30,
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
                "Uslužnici",
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "U sljedećoj tabeli prikazane su svi ocijenjivani uslužnici, sa svim ocijenama koje imaju. Prikazana je i prosječna ocjena za svakog od njih.",
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
                          "Uslužnik",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Ocjene",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                              font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "Prosječna ocjena",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
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
                          child: pw.Text(item['nazivUsluznik'],
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
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                "Na dijagramu su prikazani svi uslužnici koji su ocjenjivani. Usluge koje nisu prikazane na dijagramu, nisu nijednom recenzirane.\nNa osnovu dijagrama se primjećuje koje usluge imaju najveću prosječnu ocjenu, kao i one koje imaju najnižu.",
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 15,
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
    final file = File("${output.path}/izvjestajRecenzijaUsluznika.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");

    openPDFUsluznik();
  }

  void openPDFUsluznik() async {
    final output = await getApplicationDocumentsDirectory();
    final filePath = "${output.path}/izvjestajRecenzijaUsluznika.pdf";
    OpenFile.open(filePath);
  }

  Future<Uint8List> captureChartImageUsluge() async {
    RenderRepaintBoundary boundary =
        chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
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
}
