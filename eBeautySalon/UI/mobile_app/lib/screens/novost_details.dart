import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/master_screen.dart';

import '../models/novost.dart';
import '../utils/util.dart';

class NovostDetailsScreen extends StatefulWidget {
  Novost? novost;
  NovostDetailsScreen({super.key, this.novost});

  @override
  State<NovostDetailsScreen> createState() => _NovostDetailsScreenState();
}

class _NovostDetailsScreenState extends State<NovostDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.novost?.naslov ?? "",
        child: Container(
            width: 800,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Text(
                          "${widget.novost?.naslov ?? ""}",
                          style: const TextStyle(
                              fontFamily: 'BeckyTahlia',
                              fontSize: 26,
                              color: Colors.pinkAccent),
                        ),
                        widget.novost?.slikaNovost != null &&
                                widget.novost?.slikaNovost!.slika != ""
                            ? Container(
                                height: 100,
                                width: 100,
                                child: ImageFromBase64String(
                                    widget.novost!.slikaNovost!.slika),
                              )
                            : Container(
                                child: Image.asset(
                                  "assets/images/noImage.jpg",
                                  height: 180,
                                  width: null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Autor: ${widget.novost?.korisnik?.ime ?? ""}"),
                        Text(
                            "Datum objavljivanja: ${formatDate(widget.novost!.datumKreiranja!)}"),
                        Text("${widget.novost?.sadrzaj}"),
                      ]),
                    )))));
  }
}
