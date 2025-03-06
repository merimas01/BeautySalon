import 'package:flutter/material.dart';
import 'package:mobile_app/models/recenzija_usluge.dart';
import 'package:mobile_app/models/recenzija_usluge_insert_update.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/screens/edit_recenzija_usluge.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';

class SveRecenzijeUsluge extends StatefulWidget {
  Usluga? usluga;
  String? prosjecnaOcjena;
  String? totalReviws;
  SveRecenzijeUsluge(
      {super.key, this.usluga, this.prosjecnaOcjena, this.totalReviws});

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
    getProsjecnaOcjenaITotalReviews();
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

  Widget _naslov() {
    return Text(
      "Recenzije usluge: ${widget.usluga?.naziv}",
      textAlign: TextAlign.center,
      style: const TextStyle(
          // fontFamily: 'BeckyTahlia',
          fontSize: 26,
          color: Colors.pinkAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: 1,
        title: "Sve recenzije usluge",
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoadingData == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      dugmeNazad(),
                      _naslov(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          prosjecnaOcjena != ""
                              ? displayAverageGrade(
                                  double.parse(prosjecnaOcjena))
                              : displayAverageGrade(double.parse("0")),
                          SizedBox(
                            width: 5,
                          ),
                          prosjecnaOcjena != ""
                              ? Text(prosjecnaOcjena)
                              : Text("0"),
                          SizedBox(
                            width: 5,
                          ),
                          totalReviws != ""
                              ? Text("(${totalReviws})")
                              : Text("(0)"),
                        ],
                      ),
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
                              child: Text("Napiši recenziju?"))
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

  Widget noResultsWidget() {
    return Container(
      width: 300,
      height: 300,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Ups!",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Nije pronađena nijedna recenzija. 😔",
            style: TextStyle(fontSize: 16))
      ]),
    );
  }

  List<Widget> _buildList(data) {
    if (data.length == 0) {
      return [noResultsWidget()];
    }

    List<Widget> list = data
        .map(
          (x) => Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: () {
                if (x.korisnikId == LoggedUser.id) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditRecenzijaUsluge(
                            recenzijaUsluge: x,
                          )));
                }
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, right: 60.0, bottom: 15.0, left: 15.0),
                    child: Column(
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
                        x.komentar != null && x.komentar.trim().isNotEmpty
                            ? Row(
                                children: [
                                  Icon(Icons.comment),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    // Ensures it takes the available space
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis
                                          .horizontal, // Scrolls horizontally
                                      child:
                                          Text("${splitText(x.komentar, 5)}"),
                                    ),
                                  ),
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
                                  Text("${formatDate(x.datumModificiranja)}"),
                                ],
                              ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 65,
                    right: 20,
                    child: x.korisnikId == LoggedUser.id
                        ? IconButton(
                            onPressed: () {
                              _deleteConfirmationDialog(x);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ),
        )
        .cast<Widget>()
        .toList();

    return list;
  }

  final TextEditingController _textController = TextEditingController();
  int _rating = 0;
  String? comment;

  _rateUsluga() {
    return Container(
      height: 250,
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
              labelText: "Ovdje napišite komentar, maksimalno 15 riječi",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            onChanged: (String? newValue) {
              setState(() {
                comment = newValue;
              });
            },
            maxLines: 3,
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
        setState(() {
          imaRecenziju = true;
        });
        getProsjecnaOcjenaITotalReviews();
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
              content: Text(
                  "Trebate dati ocjenu i zadovoljiti validaciju komentara. \nMolimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
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
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
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
      listProsjecneOcjeneUsluga = [];
      prosjecnaOcjena = "0";
      totalReviws = "0";
      isLoadingProsjecnaOcjena = true;
    });

    getProsjecnaOcjenaITotalReviews();
  }

  // split text every 5 words
  String splitText(String text, int wordsPerLine) {
    List<String> words = text.split(' '); // Split by space
    List<String> lines = [];

    for (int i = 0; i < words.length; i += wordsPerLine) {
      lines.add(words
          .sublist(i, (i + wordsPerLine).clamp(0, words.length))
          .join(' '));
    }

    return lines.join('\n'); // Join with new lines
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UslugaDetails(
                        usluga: widget.usluga,
                      )));
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }

  List<dynamic> listProsjecneOcjeneUsluga = [];
  String prosjecnaOcjena = "0";
  String totalReviws = "0";
  bool isLoadingProsjecnaOcjena = true;

  getProsjecnaOcjenaITotalReviews() async {
    var usluge = await _recenzijaUslugeProvider.GetProsjecnaOcjena();
    setState(() {
      listProsjecneOcjeneUsluga = usluge;
    });
    if (listProsjecneOcjeneUsluga.length != 0) {
      for (var o in listProsjecneOcjeneUsluga) {
        if (widget.usluga?.uslugaId == o['uslugaId']) {
          setState(() {
            prosjecnaOcjena = o['prosjecnaOcjena'].toString();
            totalReviws = o['sveOcjene'].length.toString();
          });
        }
      }
    } else {
      setState(() {
        prosjecnaOcjena = widget.prosjecnaOcjena.toString();
        totalReviws = widget.totalReviws.toString();
      });
    }

    print("${prosjecnaOcjena} ${totalReviws}");
    setState(() {
      isLoadingProsjecnaOcjena = false;
    });
  }

  displayAverageGrade(x) {
    return Row(
      children: List.generate(5, (index) {
        // Determine the star type
        if (index < x.floor()) {
          // Full star
          return Icon(
            Icons.star,
            color: Colors.pink,
            size: 20,
          );
        } else if (index < x) {
          // Half star
          return Icon(
            Icons.star_half,
            color: Colors.pink,
            size: 20,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 20,
          );
        }
      }),
    );
  }
}
