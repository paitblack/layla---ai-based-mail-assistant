import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';
import 'package:layla/widgets/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/gmail/v1.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
      "Friends & Family",
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

  Future<void> _assignLabelsToEmails() async {
  if (_gmailApi == null) {
    await _initGmailApi();
  }

  List<String> mailSubjects = [];
  Map<String, String> mailIdMap = {};

  await runZonedGuarded(() async {
    try {
      var messagesResponse = await _gmailApi!.users.messages.list("me");

      if (messagesResponse.messages == null) {
        throw Exception("No messages found.");
      }

      for (var message in messagesResponse.messages!) {
        var messageDetails = await _gmailApi!.users.messages.get("me", message.id!);

        var headers = messageDetails.payload?.headers;
        var subjectHeader = headers?.firstWhere(
          (header) => header.name == "Subject",
          orElse: () => MessagePartHeader(name: "Subject", value: "No Subject"),
        );

        String mailTitle = subjectHeader!.value!;
        mailSubjects.add(mailTitle);
        mailIdMap[mailTitle] = message.id!;
      }

      Map<String, dynamic> requestBody = {"text_list": mailSubjects};

      var response = await http
          .post(
            Uri.parse("http://192.168.56.1/classify"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(requestBody),
          )
          .timeout(Duration(minutes: 30));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<dynamic> classifiedEmails = responseData["results"];

        var labelsResponse = await _gmailApi!.users.labels.list("me");
        var existingLabels = labelsResponse.labels ?? [];

        Map<String, String> labelIdMap = {
          for (var label in existingLabels) label.name!: label.id!
        };

        for (var email in classifiedEmails) {
          String mailTitle = email["mail_title"];
          String category = email["category"];

          if (labelIdMap.containsKey(category)) {
            String? messageId = mailIdMap[mailTitle];
            if (messageId != null) {
              await _gmailApi!.users.messages.modify(
                "me" as ModifyMessageRequest,
                messageId,
                ModifyMessageRequest(addLabelIds: [labelIdMap[category]!]) as String,
              );
            }
          }
        }

        print("Mails categorized successfully!");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Mails categorized successfully!")),
          );
        }
      } else {
        print("Failed to send data: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error: $e");
      print("StackTrace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error categorizing emails: $e")),
        );
      }
    }
  }, (error, stackTrace) {
    print("Uncaught error: $error");
    print("StackTrace: $stackTrace");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 0),
                      Image.asset(
                        'images/layla.png',
                        width: 150,
                        height: 150,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Classify",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: const CircleBorder(),
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.home_filled,
                          color: AppColors.background,
                          size: 75,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 525),
              Container(
                width: 960,
                height: 1100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  width: 930,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'images/cls.png',
                          width: 1100,
                          height: 500,
                        ),
                      ),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: _createLabels,
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 50, horizontal: 200)),
                          backgroundColor: WidgetStatePropertyAll(AppColors.background),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          'Set Labels',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          _assignLabelsToEmails();
                        },
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 50, horizontal: 200)),
                          backgroundColor: WidgetStatePropertyAll(AppColors.background),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          'Classify all',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
