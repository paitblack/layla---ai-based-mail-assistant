import 'package:flutter/material.dart';
import 'package:layla/widgets/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/gmail/v1.dart';
import 'dart:async';

class Classify extends StatefulWidget {
  const Classify({super.key});

  @override
  _ClassifyState createState() => _ClassifyState();
}

class _ClassifyState extends State<Classify> {
  GmailApi? _gmailApi;

  Future<void> _initGmailApi() async {
    _gmailApi = await HomePage(signedIN: FirebaseAuth.instance.currentUser)
        .gmailAPIaccess(context);
  }

  Future<void> _createLabels() async {
    if (_gmailApi == null) {
      await _initGmailApi();
    }

    final labelsToCreate = [
      "Work",
      "Advertisement",
      "News",
      "Others"
    ];

    try {
      var existingLabels = await _gmailApi!.users.labels.list("me");
      var existingLabelNames =
          existingLabels.labels?.map((label) => label.name).toSet() ?? {};

      for (var labelName in labelsToCreate) {
        if (!existingLabelNames.contains(labelName)) {
          var newLabel = Label()
            ..name = labelName
            ..labelListVisibility = "labelShow"
            ..messageListVisibility = "show";

          await _gmailApi!.users.labels.create(newLabel, "me");
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Labels created successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create labels: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white24,
              elevation: 4,
              title: Text("Classify",style: TextStyle(color: Colors.black ),),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                  Image.asset("images/layla.png",
                  width:MediaQuery.of(context).size.width * 0.1 ,
                  height:MediaQuery.of(context).size.width * 0.1 ,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                  Text(
                    'On this page, you can classify your emails using our model trained with \n95% accuracy.\n\nOur classes are labeled as Advertisement, Work, News and Others.\n\nFirst, create your labels by clicking the "Set Labels" button.\n\nThen, you can label all your emails by clicking the "Classify All" button.\n\nThis will provide you with an organized email environment.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.024
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Column(
              children: [
                ElevatedButton(
                        onPressed: _createLabels,
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.15)),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          ' Set Labels ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.02,),
                ElevatedButton(
                        onPressed: (){},
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.15)),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          'Classify All',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ]
            ),
          ],
        )),
      ),
    );
  }
}
