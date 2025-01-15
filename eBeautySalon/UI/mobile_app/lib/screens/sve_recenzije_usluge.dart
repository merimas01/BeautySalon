import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/recenzija_usluge.dart';
import 'package:mobile_app/models/recenzija_usluge_insert_update.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/screens/edit_recenzija_usluge.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';

class SveRecenzijeUsluge extends StatefulWidget {
  Usluga? usluga;
  SveRecenzijeUsluge({super.key, this.usluga});

  @override
  State<SveRecenzijeUsluge> createState() => _SveRecenzijeUslugeState();
}

class _SveRecenzijeUslugeState extends State<SveRecenzijeUsluge> {
  bool isLoadingData = true;
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  bool imaRecenziju = false;
  bool makeAReview = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    getData();
  }

  void getData() async {
    var data = await _recenzijaUslugeProvider
        .get(filter: {'uslugaId': widget.usluga!.uslugaId});

    setState(() {
      _recenzijaUslugeResult = data;
      isLoadingData = false;
    });

    setState(() {
      imaRecenziju = _recenzijaUslugeResult?.result
              .any((item) => item.korisnikId == LoggedUser.id) ??
          false;
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
                'Ukupan broj recenzija: ${_recenzijaUslugeResult?.count == null ? 0 : _recenzijaUslugeResult?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }

  Widget _naslov() {
    return Text(
      "Recenzije usluge: ${widget.usluga?.naziv}",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.pinkAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoadingData == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  _naslov(),
                  SizedBox(
                    height: 10,
                  ),
                  _showResultCount(),
                  SizedBox(
                    height: 10,
                  ),
                  imaRecenziju == false
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              makeAReview = !makeAReview;
                            });
                          },
                          child: Text("Napisi recenziju?"))
                      : Container(),
                  imaRecenziju == false
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  makeAReview == true ? _rateUsluga() : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildListView()
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }

  _buildListView() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 700,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Number of items in a row (1 in this case)
                childAspectRatio:
                    4 / 2, // Adjust the width-to-height ratio here
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
              scrollDirection: Axis.vertical,
              children: _buildList(_recenzijaUslugeResult!.result),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(data) {
    if (data.length == 0) {
      return [Text("Nema nijedna recenzija za ovu uslugu.")];
    }

    List<Widget> list = data
        .map((x) => Container(
              decoration: BoxDecoration(
                  //color: Colors.amber,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    if (x.korisnikId == LoggedUser.id) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditRecenzijaUsluge(
                                recenzijaUsluge: x,
                              )));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${x.korisnik?.ime} ${x.korisnik?.prezime}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.grade),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    child: Icon(
                                      Icons.star,
                                      color: index < x.ocjena
                                          ? Colors.amber
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          x.komentar != null &&  x.komentar.trim().isNotEmpty
                              ? Row(
                                  children: [
                                    Icon(Icons.comment),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("${x.komentar}"),
                                  ],
                                )
                              : SizedBox.shrink(),
                          x.datumModificiranja == null
                              ? Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("${formatDate(x.datumKreiranja)}"),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${formatDate(x.datumModificiranja)} (modifikovano)"),
                                  ],
                                ),
                        ],
                      ),
                      x.korisnikId == LoggedUser.id
                          ? IconButton(
                              onPressed: () {
                                _deleteConfirmationDialog(x);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  final TextEditingController _textController = TextEditingController();
  int _rating = 0;
  String? comment;

  _rateUsluga() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.pink,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1; // Update rating on tap
                    print("rating: $_rating");
                  });
                },
                child: Icon(
                  Icons.star,
                  color: index < _rating ? Colors.amber : Colors.grey,
                  size: 40,
                ),
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelText: "Ovdje napisite komentar, maksimalno 15 rijeci",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            onChanged: (String? newValue) {
              setState(() {
                comment = newValue;
              });
            },
            maxLines: 1,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                _saveRating();
              },
              child: Text("Spasi recenziju"))
        ]),
      )),
    );
  }

  _saveRating() async {
    try {
      var request = RecenzijaUslugeInsertUpdate(
          _rating, comment, LoggedUser.id, widget.usluga?.uslugaId);
      var obj = await _recenzijaUslugeProvider.insert(request);
      if (obj != null) {
        showSuccessMessage();
      }
    } catch (err) {
      print(err.toString());
      _showValidationError();
    }

    setState(() {
      _rating = 0;
      _textController.text = "";
      comment = null;
      makeAReview = !makeAReview;
    });

    var data = await _recenzijaUslugeProvider
        .get(filter: {'uslugaId': widget.usluga!.uslugaId});
    setState(() {
      _recenzijaUslugeResult = data;
    });
  }

  void _showValidationError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Nije zadovoljena validacija. Molimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }

  void showSuccessMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Informacija o uspjehu"),
              content: Text("Uspješno izvršena akcija!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  void _deleteConfirmationDialog(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o brisanju zapisa',
                  textAlign: TextAlign.center),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?',
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
    var deleted = await _recenzijaUslugeProvider.delete(e.recenzijaUslugeId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijaUslugeProvider.get(filter: {
      'uslugaId': widget.usluga?.uslugaId,
    });

    setState(() {
      _recenzijaUslugeResult = data;
      imaRecenziju = false;
    });
  }
}
