import 'package:flutter/material.dart';
import 'package:food/alert.dart';
import 'package:food/auth/singup.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var passe, email;
  GlobalKey<FormState> teststate = new GlobalKey<FormState>();

  singin() async {
    var datatest = teststate.currentState;
    if (datatest!.validate()) {
      datatest.save();
      try {
        showloding(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: passe);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.info,
              //btnOk: const Text("OK"),
              title: "Error",
              body: Text("this email inixiste"))
            ..show();
          print("user inewisting");
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.topSlide,
              dialogType: DialogType.info,
              //btnOk: const Text("OK"),
              title: "Error",
              body: Text("password incorecte"))
            ..show();
          print('wrong passeword');
        }
      }
    } else {
      print("not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(child: Image.asset("images/téléchargement.jpg")),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(10),
          child: Form(
              key: teststate,
              child: Column(
                children: [
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
                    decoration: const InputDecoration(
                        hintText: " mail",
                        hintStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
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
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "password",
                        hintStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                        )),
                  ),
                  Container(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //backgroundColor: Colors.black,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: (() async {
                          var reset = await singin();
                          if (reset != null) {
                            if (FirebaseAuth
                                    .instance.currentUser!.emailVerified ==
                                true) {
                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            } else {
                              AwesomeDialog(
                                  context: context,
                                  body: const Text(
                                    "email not verified",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  dialogType: DialogType.info,
                                  title: "Erreur")
                                ..show();
                            }
                          }
                          Navigator.of(context).pop();
                        }),
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline3,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          "si vous n'a pas un compte",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("singup");
                          },
                          child: Text(
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
    );
  }

  veri() {
    Navigator.of(context).pop();
  }
}
