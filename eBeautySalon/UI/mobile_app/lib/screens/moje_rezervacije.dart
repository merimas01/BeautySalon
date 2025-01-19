import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/korisnik.dart';
import 'package:mobile_app/screens/rezervacija_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../providers/rezervacije_provider.dart';
import '../utils/util.dart';

class MojeRezervacije extends StatefulWidget {
  Korisnik? korisnik;
  MojeRezervacije({super.key, this.korisnik});

  @override
  State<MojeRezervacije> createState() => _MojeRezervacijeState();
}

class _MojeRezervacijeState extends State<MojeRezervacije> {
  late RezervacijeProvider _rezervacijeProvider;
  SearchResult<Rezervacija>? _rezervacijeResult;
  bool isLoadingData = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("Korisnik: ${widget.korisnik?.korisnikId}");
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    getData();
  }

  //DUGME NA DETALJE REZERVACIJE (ili samo klik na element): SVE INFO + INFO O NACINU PLACANJA + STATUS
  //u detaljima: DUGME OTKAZI REZERVACIJU
  // dugme obrisi rezervaciju ili Arhviraj (isArhivaKorisnik). Ako je arhivirano, promjeniti ikonicu na dearhiviraj
  //SEARCH PO STATUSU, PO DATUMU, po Arhivi (klik na dugme filter i da se pojavi dijalog box)
  //oboji status rezervacije

  void getData() async {
    var rezervacije = await _rezervacijeProvider
        .get(filter: {'FTS': "", 'korisnikId': widget.korisnik!.korisnikId});

    setState(() {
      _rezervacijeResult = rezervacije;
      isLoadingData = false;
    });
  }

  var dropdown_lista = [
    {'opis': 'da', 'vrijednost': true},
    {'opis': 'ne', 'vrijednost': false}
  ];

  String? selectedOpis = "ne";

  Widget _searchByIsArhiva() {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOpis,
            // isExpanded: true,
            hint: Text("Arhiva?"),
            items: dropdown_lista.map((item) {
              return DropdownMenuItem<String>(
                value: item['opis'] as String,
                child: Text(item['opis'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOpis = value;
              });
              print(selectedOpis);
            },
          ),
        ),
      ),
    );
  }

  _showFilterDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Example Dialog"),
          content: Container(
            height: 300,
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: [
                    _searchByIsArhiva(),
                    SizedBox(width: 8),
                    selectedOpis != null
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                selectedOpis = null;
                              });
                            },
                            child: Tooltip(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              message: "Poništi selekciju",
                            ),
                          )
                        : Container(),
                  ],
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                var data = await _rezervacijeProvider.get(filter: {
                  //'statusId': selectedStatus?.statusId,
                  'isArhiva': selectedOpis
                });

                setState(() {
                  _rezervacijeResult = data;
                });
              },
              child: const Icon(Icons.search),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _searchByIsArhiva(),

          SizedBox(width: 8),
          selectedOpis != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOpis = null;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),

          // searchByStatus(),
          // SizedBox(width: 8),
          // selectedStatus != null
          //     ? TextButton(
          //         onPressed: () {
          //           setState(() {
          //             selectedStatus = null;
          //           });
          //         },
          //         child: Tooltip(
          //           child: Icon(
          //             Icons.close,
          //             color: Colors.red,
          //           ),
          //           message: "Poništi selekciju",
          //         ),
          //       )
          //     : Container(),
          // SizedBox(width: 10),

          // ElevatedButton(
          //   style: TextButton.styleFrom(
          //       foregroundColor: Colors.pink, backgroundColor: Colors.white),
          //   onPressed: () => _selectDate(context),
          //   child: Text(_selectedDate == null
          //       ? 'Izaberi datum'
          //       : formatDate(_selectedDate!)),
          // ),
          // SizedBox(
          //   width: 8,
          // ),
          // _selectedDate != null
          //     ? TextButton(
          //         onPressed: () {
          //           setState(() {
          //             _selectedDate = null;
          //           });
          //         },
          //         child: Tooltip(
          //           child: Icon(
          //             Icons.close,
          //             color: Colors.red,
          //           ),
          //           message: "Poništi datum",
          //         ),
          //       )
          //     : Container(),
          // SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Traži");

                var data = await _rezervacijeProvider.get(filter: {
                  //'statusId': selectedStatus?.statusId,
                  'isArhiva': selectedOpis
                });

                setState(() {
                  _rezervacijeResult = data;
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

  _buildRezervacijeListView() {
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
                    3 / 1, // Adjust the width-to-height ratio here
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
              scrollDirection: Axis.vertical,
              children: _buildRezervacijeList(_rezervacijeResult!.result),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRezervacijeList(data) {
    if (data.length == 0) {
      return [Text("Ucitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RezervacijaDetails(
                              rezervacija: x,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${x.sifra ?? ""}"),
                          Text("${x.usluga?.naziv ?? ""}"),
                          Text("${formatDate(x.datumRezervacije)}"),
                          Text("${x.termin?.opis ??""}h"),
                          Text(
                            "${x.status?.opis ?? ""}",
                            style: TextStyle(color: _colorReservationStatus(x)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                //Kad se klikne na ovo dugme, brise se rezervacija (odnosno arhivira se samo za korisnika, isArhivaKorisnik)
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  _colorReservationStatus(Rezervacija e) {
    if (e.status?.opis == "Prihvacena")
      return Colors.green[500];
    else if (e.status?.opis == "Odbijena")
      return Colors.red[500];
    else if (e.status?.opis == "Nova") return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Moje rezervacije",
        child: isLoadingData == false
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    //_buildSearch(),
                    TextButton(
                        onPressed: () {
                          _showFilterDialog();
                        },
                        child: Icon(Icons.sort)),
                    _buildRezervacijeListView()
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
