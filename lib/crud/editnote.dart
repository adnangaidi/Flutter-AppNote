import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food/alert.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNote extends StatefulWidget {
  final eddoc;
  final list;
  const EditNote({Key? key, this.eddoc, this.list}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Reference? ref;
  File? file;
  var title, note;
  var pecker, imageurel;
  var User;

  GlobalKey<FormState> addstate = new GlobalKey<FormState>();
  add(context) async {
    var addtest = addstate.currentState;
    if (file == null) {
      if (addtest!.validate()) {
        showbottomsheet(context);
        showloding(context);
        addtest.save();
        await FirebaseFirestore.instance
            .collection("notepath")
            .doc(widget.eddoc)
            .update({
          "title": title,
          "note": note,
        }).then((value) {
          Navigator.of(context).pushNamed("home");
        }).catchError((e) {
          print("$e");
        });
      }

      if (addtest.validate()) {
        showbottomsheet(context);
        showloding(context);
        addtest.save();
        await ref!.putFile(file!);
        imageurel = ref!.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("notepath")
            .doc(widget.eddoc)
            .update({
          "title": title,
          "note": note,
          "imageurl": imageurel,
        }).then((value) {
          Navigator.of(context).pushReplacementNamed("home");
        }).catchError((e) {
          print("$e");
        });
        ;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
                key: addstate,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.list!['title'],
                      onSaved: ((newValue) {
                        title = newValue;
                      }),
                      validator: (value) {
                        if (value!.length > 32) {
                          return "the title if note sup 300";
                        }
                        if (value.length < 4) {
                          return "the title is not inf a than 4 lettres";
                        }
                        return null;
                      },
                      maxLines: 1,
                      maxLength: 30,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Title Note",
                          prefixIcon: Icon(Icons.note)),
                    ),
                    TextFormField(
                      initialValue: widget.list!['note'],
                      onSaved: ((newValue) {
                        note = newValue;
                      }),
                      validator: (value) {
                        if (value!.length > 300) {
                          return "the note if note sup 300";
                        }
                        if (value.length < 4) {
                          return "the note is not inf a than 4 lettres";
                        }
                        return null;
                      },
                      maxLines: 3,
                      minLines: 1,
                      maxLength: 300,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Note",
                          prefixIcon: Icon(Icons.note)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showbottomsheet(this.context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        backgroundColor: Theme.of(context).buttonColor,
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      child: Text("Edit image "),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await add(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).buttonColor,
                        textStyle: Theme.of(context).textTheme.headline3,
                      ),
                      child: const Text("Enregistrer"),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  showbottomsheet(context) {
    return showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose image please",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: (() async {
                    pecker = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (pecker != null) {
                      file = File(pecker.path);
                      var round = Random().nextInt(1000000);
                      var imagpath = "$round" + basename(pecker.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagpath");
                      Navigator.of(context).pop();
                    }
                  }),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.photo_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "from galery",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                InkWell(
                  onTap: (() async {
                    pecker = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (pecker != null) {
                      file = File(pecker.path);
                      var round = Random().nextInt(1000000);
                      var imagpath = "$round" + basename(pecker.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagpath");
                      Navigator.of(context).pop();
                    }
                  }),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 20,
                          ),
                          Text("from camera",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      )),
                )
              ],
            ),
          );
        });
  }
}
