import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food/crud/Viewnote.dart';
import 'package:food/crud/editnote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference noteref =
      FirebaseFirestore.instance.collection("notepath");
  getuser() {
    var emailuser = FirebaseAuth.instance.currentUser;
    print(emailuser!.email);
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("login");
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (() {
            Navigator.of(context).pushNamed("add");
          }),
          child: const Icon(
            Icons.add,
          ),
        ),
        body: FutureBuilder(
            future: noteref
                .where("userid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                          onDismissed: ((direction) async {
                            await noteref
                                .doc(snapshot.data?.docs[i].id)
                                .delete();
                            await FirebaseStorage.instance
                                .refFromURL(
                                    "${snapshot.data?.docs[i]['imageurl']}")
                                .delete()
                                .then((value) {
                              print("==============================");
                              print("operator successe");
                            });
                          }),
                          key: UniqueKey(),
                          child: ListNotes(
                              notes: snapshot.data?.docs[i],
                              eddoc: snapshot.data?.docs[i].id));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final eddoc;
  ListNotes({this.notes, this.eddoc});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Viewnote(
            docid: eddoc,
            list: notes,
          );
        }));
      }),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageurl']}",
                fit: BoxFit.fill,
                height: 100,
              ),
            ),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    "${notes['title']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${notes['note']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                      onPressed: (() {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EditNote(
                            eddoc: eddoc,
                            list: notes,
                          );
                        }));
                      }),
                      icon: Icon(Icons.edit)),
                )),
          ],
        ),
      ),
    );
  }
}
