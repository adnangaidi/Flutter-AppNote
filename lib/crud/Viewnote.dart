import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Viewnote extends StatelessWidget {
  final docid, list;
  const Viewnote({Key? key, this.docid, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View note")),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  "${list!['imageurl']}",
                  fit: BoxFit.fill,
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              "${list['title']}",
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${list['note']}",
              style: TextStyle(fontSize: 19),
            )
          ],
        ),
      ),
    );
  }
}
