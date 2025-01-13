import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/master_screen.dart';

import '../models/usluga.dart';
import '../utils/util.dart';

class UslugaDetails extends StatefulWidget {
  Usluga? usluga;
  UslugaDetails({super.key, this.usluga});

  @override
  State<UslugaDetails> createState() => _UslugaDetailsState();
}

class _UslugaDetailsState extends State<UslugaDetails> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "",
      child: _showDetails(),
    );
  }

  _showDetails() {
    return Container(
      width: 800,
      child: Card(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            Text(
              "${widget.usluga?.naziv ?? ""}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'BeckyTahlia',
                  fontSize: 26,
                  color: Colors.pinkAccent),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.usluga?.kategorija?.naziv ?? ""}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'BeckyTahlia',
                  fontSize: 20,
                  color: Colors.pinkAccent),
            ),
            SizedBox(
              height: 10,
            ),
            widget.usluga?.slikaUsluge != null &&
                    widget.usluga?.slikaUsluge?.slika != null &&
                    widget.usluga?.slikaUsluge?.slika != ""
                ? Container(
                    height: 200,
                    width: 200,
                    child: ImageFromBase64String(
                        widget.usluga!.slikaUsluge!.slika),
                  )
                : Container(
                    child: Image.asset(
                      "assets/images/noImage.jpg",
                    ),
                    height: 200,
                    width: 200,
                  ),
            SizedBox(
              height: 10,
            ),
            Text("${formatNumber(widget.usluga?.cijena)}KM", style: TextStyle(fontSize: 16),),
            SizedBox(
              height: 10,
            ),
            Text("${widget.usluga?.opis}", style: TextStyle(fontSize: 16),),
            SizedBox(height: 10,),
            Text("Usluznik/ci: ??", style: TextStyle(fontSize: 16),),
            //prikazati prosjecnu ocjenu usluge u obliku zvjezdica i brojcano
            //isto tako i za usluznika/ke
          
            //prikaz svih recenzija usluga/usluznika - NA NOVOM SCREENU
            //klikom na recenziraj uslugu/usluznika - otvara se dijalog i tu se unosi komentar i ocjena
            //recommender
          ]),
        ),
      )),
    );
  }

  _rateUsluga(){
    return Column(children: [],);
  }

  _rateUsluznik(){

  }
}
