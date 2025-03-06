import 'package:desktop_app/screens/novosti_list_screen.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../models/novost_like_comment.dart';
import '../models/novost_like_comment_insert_update.dart';
import '../models/search_result.dart';
import '../providers/novost_like_comment_provider.dart';
import '../utils/util.dart';

class NovostLikeCommentScreen extends StatefulWidget {
  Novost? novost;
  NovostLikeCommentScreen({super.key, this.novost});

  @override
  State<NovostLikeCommentScreen> createState() =>
      _NovostLikeCommentScreenState();
}

class _NovostLikeCommentScreenState extends State<NovostLikeCommentScreen> {
  late NovostLikeCommentProvider _novostLikeCommentProvider;
  SearchResult<NovostLikeComment>? _result;
  bool isLoadingData = true;
  TextEditingController _ftsController = new TextEditingController();
  String? search = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostLikeCommentProvider = context.read<NovostLikeCommentProvider>();

    getData();
  }

  void getData() async {
    var data = await _novostLikeCommentProvider.get(filter: {
      'isNovostIncluded': true,
      'isKorisnikIncluded': true,
      'novostId': widget.novost?.novostId,
      'FTS': ''
    });

    setState(() {
      _result = data;
      isLoadingData = false;
    });

    // Add a listener to get the value whenever the text changes
    _ftsController.addListener(() {
      String currentText = _ftsController.text; // Access the current text
      setState(() {
        search = currentText;
      });
      print('Current Text: $currentText');
    });
  }

  var dropdown_lista_lajkovi = [
    {'opis': 'da', 'value': 'Lajkane novosti'},
    {'opis': 'ne', 'value': 'Nelajkane novosti'},
    {'opis': 'Oboje', 'value': 'Sve'}
  ];

  String? selectedOpisLike = "da";

  Widget _searchByIsLike() {
    return Container(
      width: 150,
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOpisLike,
            isExpanded: true,
            hint: Text("Izaberi opciju"),
            items: dropdown_lista_lajkovi.map((item) {
              return DropdownMenuItem<String>(
                value: item['opis'] as String,
                child: Text(item['value'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOpisLike = value;
              });
              print(selectedOpisLike);
            },
          ),
        ),
      ),
    );
  }

  var dropdown_lista_komentari = [
    {'opis': 'da', 'value': 'Komentarisane novosti'},
    {'opis': 'ne', 'value': 'Nekomentarisane novosti'},
    {'opis': 'oboje', 'value': 'Sve'}
  ];

  String? selectedOpisComment = "da";

  Widget _searchByIsComment() {
    return Container(
      width: 160,
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOpisComment,
            isExpanded: true,
            hint: Text("Izaberi opciju"),
            items: dropdown_lista_komentari.map((item) {
              return DropdownMenuItem<String>(
                value: item['opis'] as String,
                child: Text(item['value'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOpisComment = value;
              });
              print(selectedOpisComment);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _nazad(),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "korisnik/komentar",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          search != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController.text = '';
                      search = _ftsController.text;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    message: "Izbriši tekst",
                  ),
                )
              : Container(),
          SizedBox(width: 8),
          _searchByIsLike(),
          SizedBox(width: 8),
          selectedOpisLike != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOpisLike = null;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),
          SizedBox(
            width: 8,
          ),
          _searchByIsComment(),
          SizedBox(width: 8),
          selectedOpisComment != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOpisComment = null;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Traži");

                var data = await _novostLikeCommentProvider.get(filter: {
                  'isNovostIncluded': true,
                  'isKorisnikIncluded': true,
                  'novostId': widget.novost?.novostId,
                  'FTS': _ftsController.text,
                  'isLike': selectedOpisLike == "da"
                      ? true
                      : selectedOpisLike == "ne"
                          ? false
                          : null,
                  'isComment': selectedOpisComment == "da"
                      ? true
                      : selectedOpisComment == "ne"
                          ? false
                          : null
                });

                setState(() {
                  _result = data;
                  isLoadingData = false;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Korisnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Slika korisnika"),
            )),
            DataColumn(
                label: Expanded(
              child: Icon(Icons.thumb_up),
            )),
            DataColumn(
                label: Expanded(
              child: Icon(Icons.comment),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum kreiranja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum modifikovanja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            )),
          ],
          rows: _result?.result
                  .map((NovostLikeComment e) => DataRow(cells: [
                        DataCell(
                            Text("${e.korisnik?.ime} ${e.korisnik?.prezime}")),
                        DataCell(e.korisnik?.slikaProfila?.slika != null &&
                                e.korisnik?.slikaProfila?.slika != ""
                            ? Container(
                                width: 100,
                                height: 100,
                                child: ImageFromBase64String(
                                    e.korisnik!.slikaProfila!.slika),
                              )
                            : Container(
                                child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 250,
                                width: 100,
                              ))),
                        DataCell(e.isLike == true
                            ? Icon(Icons.thumb_up_alt_outlined)
                            : Text("")),
                        DataCell(Text(e.komentar ?? "")),
                        DataCell(Container(
                            width: 130,
                            child: Text(formatDate(e.datumKreiranja!)))),
                        DataCell(Container(
                            width: 130,
                            child: e.datumModifikovanja != null
                                ? Text(formatDate(e.datumModifikovanja!))
                                : Text("-"))),
                        DataCell(
                          e.komentar != null
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    _deleteConfirmationDialog(e);
                                  },
                                  child: Text('Obriši komentar'),
                                )
                              : Container(),
                        ),
                      ]))
                  .toList() ??
              []),
    ));
  }

  void _deleteConfirmationDialog(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o brisanju komentara',
                  textAlign: TextAlign.center),
              content: Text(
                  'Jeste li sigurni da želite izbrisati ovaj komentar?',
                  textAlign: TextAlign.center),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Ne'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                ElevatedButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _obrisiZapis(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapis(e) async {
    var deleted = await _novostLikeCommentProvider.update(
        e.novostLikeCommentId!,
        NovostLikeCommentInsertUpdate(
            e.korisnikId, e.novostId, e.isLike, null));

    var data = await _novostLikeCommentProvider.get(filter: {
      'isNovostIncluded': true,
      'isKorisnikIncluded': true,
      'novostId': widget.novost?.novostId,
      'FTS': _ftsController.text,
      'isLike': selectedOpisLike == "da"
          ? true
          : selectedOpisLike == "ne"
              ? false
              : null,
      'isComment': selectedOpisComment == "da"
          ? true
          : selectedOpisComment == "ne"
              ? false
              : null
    });

    setState(() {
      _result = data;
      isLoadingData = false;
    });
  }

  Widget _showResultCount() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text:
                'Broj rezultata: ${_result?.count == null ? 0 : _result?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }

  _nazad() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 255, 255, 255)),
          foregroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 139, 132, 134)),
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NovostiListScreen()));
        },
        child: Text("Nazad na novosti"));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Detalji novosti: ${widget.novost?.sifra}",
        child: isLoadingData == false
            ? Column(
                children: [
                  _buildSearch(),
                  Text(
                    "Za pretragu zapisa pritisnite dugme Traži",
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 3,),
                  _showResultCount(),
                  _buildDataListView()
                ],
              )
            : Container(
                child: CircularProgressIndicator(),
              ));
  }
}
