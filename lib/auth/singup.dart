import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food/alert.dart';
import 'package:food/auth/verifiemail.dart';

class Singup extends StatefulWidget {
  const Singup({super.key});

  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  var passe, email, user;
  bool isVisible = false;

  GlobalKey<FormState> teststate = new GlobalKey<FormState>();

  condirm() async {
    var datatest = teststate.currentState;
    if (datatest!.validate()) {
      datatest.save();
      try {
        showloding(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: passe);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              btnOk: const Text("OK"),
              title: "Error",
              body: Text("the password is provider is too work"))
            ..show();
          print("the password is provider is too work");
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              btnOk: const Text("OK"),
              title: "Error",
              body: Text("the account already exists for that email"))
            ..show();
          print('the account already exists for that email');
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(child: Image.asset("images/téléchargement.jpg")),
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: teststate,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: ((value) {
                          setState(() {
                            user = value;
                          });
                        }),
                        validator: (value) {
                          if (value!.length > 100) {
                            return "username can't to be larger than 100 letter";
                          }
                          if (value.length < 3) {
                            return "username can't to be less than 100 letter";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: " username",
                            hintStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onSaved: ((newValue) {
                          setState(() {
                            email = newValue;
                          });
                        }),
                        validator: (value) {
                          if (value!.length > 100) {
                            return "email can't to be larger than 100 letter";
                          }
                          if (value.length < 4) {
                            return "email can't to be less than 100 letter";
                          }
                          return null;
                        },
                        //obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onSaved: ((newValue) {
                          setState(() {
                            passe = newValue;
                          });
                        }),
                        validator: (value) {
                          if (value!.length > 80) {
                            return "password can't to be larger than 100 letter";
                          }
                          if (value.length < 4) {
                            return "password can't to be less than 100 letter";
                          }
                          return null;
                        },
                        obscureText: isVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: (() {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                }),
                                icon: isVisible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            hintText: "password",
                            hintStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            )),
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            onPressed: (() async {
                              UserCredential rep = await condirm();
                              print(
                                  "//==================FireStore=================");
                              if (rep != null) {
                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .add({"usernme": user, "email": email});
                                if (!FirebaseAuth
                                    .instance.currentUser!.emailVerified) {
                                  await FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                }

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return VerifyEmaim();
                                }));
                              } else {
                                print("sing up failed");
                              }
                              print(
                                  "//==================FireStore=================");
                            }),
                            child: Text(
                              "Sing Up",
                              style: Theme.of(context).textTheme.headline3,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              "vous avais  un compte",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("login");
                              },
                              child: const Text(
                                " Click ici",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ]),
        )
      ]),
    );
  }
}
