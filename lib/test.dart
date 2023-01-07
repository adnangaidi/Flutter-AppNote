import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestState();
    throw UnimplementedError();
  }
}

class TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            child: ElevatedButton(
                onPressed: () {
                  print(DateTime.utc(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day));
                },
                child: Text("Login")),
          ),
        ));
  }
}
