import 'package:flutter/material.dart';

Future showloding(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("please waite"),
          content: Container(
              height: 50,
              child: const Center(child: CircularProgressIndicator())),
        );
      });

  // Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Basic dialog title'),
        content: const Text('A dialog is a type of modal window that\n'
            'appears in front of app content to\n'
            'provide critical information, or prompt\n'
            'for a decision to be made.'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
//}

//}







   //User = <String, dynamic>{
       // "title": title,
        //"note": note,
       // "imageurl": imageurel,
       // "userid": FirebaseAuth.instance.currentUser!.uid
     // await FirebaseFirestore.instance.collection("Notepath").add(User);
     // };
