import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/recenzija_usluge.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/recenzija_usluge_insert_update.dart';

class EditRecenzijaUsluge extends StatefulWidget {
  RecenzijaUsluge? recenzijaUsluge;
  EditRecenzijaUsluge({super.key, this.recenzijaUsluge});

  @override
  State<EditRecenzijaUsluge> createState() => _EditRecenzijaUslugeState();
}

class _EditRecenzijaUslugeState extends State<EditRecenzijaUsluge> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  TextEditingController _ocjenaController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ocjena': widget.recenzijaUsluge?.ocjena.toString(),
      'komentar': widget.recenzijaUsluge?.komentar,
    };

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();

    setState(() {
      _ocjenaController.text = widget.recenzijaUsluge?.ocjena?.toString() ?? "";
      _commentController.text = widget.recenzijaUsluge?.komentar ?? "";
    });
  }

  _showDetails() {
    return Container(
        width: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Text(
                //   "${widget.recenzijaUsluge?.usluga?.naziv ?? ""}",
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //       fontFamily: 'BeckyTahlia',
                //       fontSize: 26,
                //       color: Colors.pinkAccent),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // widget.recenzijaUsluge?.usluga?.slikaUsluge != null &&
                //         widget.recenzijaUsluge?.usluga?.slikaUsluge?.slika !=
                //             null &&
                //         widget.recenzijaUsluge?.usluga?.slikaUsluge?.slika != ""
                //     ? Container(
                //         height: 200,
                //         width: 200,
                //         child: ImageFromBase64String(
                //             widget.recenzijaUsluge!.usluga!.slikaUsluge!.slika),
                //       )
                //     : Container(
                //         child: Image.asset(
                //           "assets/images/noImage.jpg",
                //         ),
                //         height: 200,
                //         width: 200,
                //       ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: "Kategorija:"),
                //   initialValue:
                //       "${widget.recenzijaUsluge?.usluga?.kategorija?.naziv}",
                //   enabled: false,
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: "Datum kreiranja:"),
                //   initialValue:
                //       "${formatDate(widget.recenzijaUsluge!.datumKreiranja!)}",
                //   enabled: false,
                // ),
                // widget.recenzijaUsluge?.datumModificiranja != null
                //     ? TextFormField(
                //         decoration:
                //             InputDecoration(labelText: "Datum modificiranja:"),
                //         initialValue:
                //             "${formatDate(widget.recenzijaUsluge!.datumModificiranja!)}",
                //         enabled: false,
                //       )
                //     : Container(),
                // TextFormField(
                //   decoration: InputDecoration(labelText: "Ocjena:"),
                //   initialValue: "${widget.recenzijaUsluge?.ocjena}",
                //   enabled: true,
                //   //  controller: _ocjenaController,
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: "Komentar:"),
                //   initialValue: "${widget.recenzijaUsluge?.komentar}",
                //   enabled: true,
                //   //controller: _commentController,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                
               
              ],
            ),
          ),
        ));
  }

  _form() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Container(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "ocjena",
                    decoration: InputDecoration(labelText: "Ocjena:"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo Vas unesite ocjenu';
                      }
                      if (!RegExp(r'(1|2|3|4|5)$').hasMatch(value)) {
                        return 'Unesite 1, 2, 3, 4 ili 5';
                      }
                      return null;
                    },
                  ),
                  FormBuilderTextField(
                    name: "komentar",
                    decoration: InputDecoration(labelText: "Komentar:"),
                  ),
                   ElevatedButton(
                          onPressed: () async {
                            try {
                              var request = RecenzijaUslugeInsertUpdate(
                                  int.parse(_ocjenaController.text),
                                  _commentController.text,
                                  LoggedUser.id,
                                  widget.recenzijaUsluge?.usluga?.uslugaId);
                              var obj = await _recenzijaUslugeProvider.update(
                                  widget.recenzijaUsluge!.recenzijaUslugeId!,
                                  request);
                              if (obj != null) {
                                showSuccessMessage();
                              }
                            } catch (err) {
                              print(err.toString());
                              _showValidationError();
                            }
                          },
                          child: Text("Spasi promjene"))
                ],
              ),
            ),
          ),
        ));
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(child: _form());
  }
}
