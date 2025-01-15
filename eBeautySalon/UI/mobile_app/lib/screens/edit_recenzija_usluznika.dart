import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/recenzija_usluznika.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class EditRecenzijaUsluznika extends StatefulWidget {
  RecenzijaUsluznika? recenzijaUsluznika;
  EditRecenzijaUsluznika({super.key, this.recenzijaUsluznika});

  @override
  State<EditRecenzijaUsluznika> createState() => _EditRecenzijaUsluznikaState();
}

class _EditRecenzijaUsluznikaState extends State<EditRecenzijaUsluznika> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(child: Container());
  }
}