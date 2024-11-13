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
import '../models/recenzija_usluge.dart';
import '../models/search_result.dart';
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
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  SearchResult<RecenzijaUsluge>? _result;
  List<dynamic>? _resultProsjecnaOcjena;
  bool isLoading = true;
  List<dynamic> list = [];
  int listCount = 0;
  List<String> nazivUslugeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();

    initForm();
  }

  void initForm() async {
    _result = await _recenzijaUslugeProvider.get();
    list = await _recenzijaUslugeProvider.GetProsjecnaOcjena();

    for (var item in list) {
      print("${item}");
    }

    setState(() {
      nazivUslugeList =
          list.map((usluga) => usluga['nazivUsluge'] as String).toList();
      listCount = list.length;
      isLoading = false;
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
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: chartKey,
                  child: isLoading == false ? buildBarChart() : Container(),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            isLoading == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttonRecenzije(),
                      SizedBox(
                        width: 10,
                      ),
                      buttonPrintajPDF(),
                    ],
                  )
                : Container(),
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
                    '\nNa narednoj slici, prikazan je bar chart sa prosječnim ocjenama usluga (prikazane od najbolje ocijenjenih ka najlošije ocijenjenim).',
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

  SizedBox buildBarChart() {
    return SizedBox(
      width: 500,
      height: 400,
      child: BarChart(
        BarChartData(
          barGroups: generateData(list),
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
    );
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

  Widget buttonPrintajPDF() {
    return ElevatedButton(
        onPressed: () {
          generatePDF();
        },
        child: Text("Isprintaj PDF dokument"));
  }

  void generatePDF() async {
    // Capture chart image
    final chartImage = await captureChartImage();

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
                  for (var item in list)
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
                "Na dijagramu su prikazane sve usluge koje su ocjenjivanje. Usluge koje nisu prikazane na dijagramu, nisu nijednom recenzirane.\nNa osnovu dijagrama se primjećuje koje usluge imaju najveću prosječnu ocjenu, kao i one koje imaju najnižu.",
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
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");

    openPDF();
  }

  void openPDF() async {
    final output = await getApplicationDocumentsDirectory();
    final filePath = "${output.path}/example.pdf";
    OpenFile.open(filePath);
  }

  Future<Uint8List> captureChartImage() async {
    RenderRepaintBoundary boundary =
        chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  List<BarChartGroupData> generateData(List<dynamic> dataset) {
    dataset
        .sort((a, b) => b['prosjecnaOcjena'].compareTo(a['prosjecnaOcjena']));
    final random = Random();
    return List.generate(dataset.length, (index) {
      final usluga = dataset[index];
      final double value = usluga['prosjecnaOcjena'].toDouble();

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
