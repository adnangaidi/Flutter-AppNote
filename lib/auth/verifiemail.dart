import 'package:flutter/material.dart';
import 'package:food/auth/login.dart';
import 'package:food/homePage/home.dart';

class VerifyEmaim extends StatefulWidget {
  const VerifyEmaim({super.key});

  @override
  State<VerifyEmaim> createState() => _VerifyEmaimState();
}

class _VerifyEmaimState extends State<VerifyEmaim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("virifie emeil"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "le lien de virivication is send to your email",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                },
                child: const Text(
                  "Go to sing in",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
