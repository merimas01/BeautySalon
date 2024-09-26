import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/master_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: Column(children: [
        Text("home page"),
        Text("implementirati logout button"),
        ]),
      ),
      title_widget: Text("Home page"),
      
    );
  }
}