import 'dart:math';

import 'package:desktop_app/screens/recenzije_list_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/recenzija_usluge.dart';
import '../models/search_result.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../widgets/master_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading == false ? buildBarChart() : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonRecenzije(),
                SizedBox(
                  width: 10,
                ),
                buttonSeePdf(),
                SizedBox(
                  width: 10,
                ),
                buttonPrintajPDF(),
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

  TextButton buttonOdjava() =>
      TextButton(onPressed: () {}, child: Text("Odjava"));

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
          barGroups: generateRandomData(list),
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
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RecenzijeListScreen()));
        },
        child: Text("Pogledaj sve recenzije"));
  }

  Widget buttonPrintajPDF() {
    return ElevatedButton(onPressed: () {}, child: Text("Isprintaj PDF"));
  }

  Widget buttonSeePdf() {
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
        onPressed: () {},
        child: Text("Pregledaj PDF"));
  }

  List<BarChartGroupData> generateRandomData(List<dynamic> dataset) {
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
