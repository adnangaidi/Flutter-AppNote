import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/auth/login.dart';
import 'package:food/auth/singup.dart';
import 'package:food/crud/addnote.dart';
import 'package:food/crud/editnote.dart';
import 'package:food/homePage/home.dart';
import 'package:food/test.dart';
import 'package:firebase_core/firebase_core.dart';

bool? islogin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  user == null ? islogin = false : islogin = true;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin == false ? Login() : Home(),
      theme: ThemeData(
          primaryColor: Colors.black,
          buttonColor: Colors.black,
          textTheme: TextTheme(
              headline3: TextStyle(fontSize: 20, color: Colors.white))),
      routes: {
        "login": (context) => Login(),
        "singup": (context) => Singup(),
        "home": (context) => Home(),
        "add": (context) => AddNote(),
        // "edit": (context) =>
      },
    );
  }
}
