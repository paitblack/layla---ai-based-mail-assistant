import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layla/widgets/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Classify extends StatefulWidget {
  const Classify({super.key});

  @override
  _ClassifyState createState() => _ClassifyState();
}

class _ClassifyState extends State<Classify> {
  GmailApi? _gmailApi;

  final List<String> labels = ["Work and Business","Friends and Family","News and Promotions","Orders and Bills","Application Notifications"];

  Future<void> _initGmailApi() async {
    _gmailApi = await HomePage(signedIN: FirebaseAuth.instance.currentUser)
        .gmailAPIaccess(context);
  }

  @override
  void initState() {
    super.initState();
    _initGmailApi();
  }

  Future<void> _createLabels() async {
    if (_gmailApi == null) {
      await _initGmailApi();
    }

    final labelsToCreate = ["Work and Business","Friends and Family","News and Promotions","Orders and Bills","Application Notifications"];

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
        SnackBar(content: Text('Labels created successfully'))
      );
    } catch (e) {
      print("Failed to create labels: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create labels: ${e.toString().substring(0, 100)}'))
      );
    }
  }

  Future<void> _classifyEmails() async {
  if (_gmailApi == null) {
    await _initGmailApi();
  }

  try {
    var messages = await _gmailApi!.users.messages.list("me");

    Map<String, String> emailData = {};
    Map<String, String> formattedTextToIdMap = {};
    
    for (var message in messages.messages!) {
      var msg = await _gmailApi!.users.messages.get("me", message.id!);
      
      var subjectHeader = msg.payload?.headers?.firstWhere(
        (header) => header.name == 'Subject', 
        orElse: () => MessagePartHeader()..value = 'No Subject'
      );
      String subject = subjectHeader?.value ?? 'No Subject';
      
      var fromHeader = msg.payload?.headers?.firstWhere(
        (header) => header.name == 'From', 
        orElse: () => MessagePartHeader()..value = 'Unknown Sender'
      );
      String fromValue = fromHeader?.value ?? 'Unknown Sender';
      
      String senderName = '';
      String senderEmail = '';
      
      if (fromValue.contains('<') && fromValue.contains('>')) {
        var parts = fromValue.split('<');
        senderName = parts[0].trim();
        senderEmail = parts[1].replaceAll('>', '').trim();
      } else if (fromValue.contains('@')) {
        senderEmail = fromValue.trim();
        senderName = senderEmail.split('@')[0]; 
      } else {
        senderName = fromValue.trim();
        senderEmail = fromValue.trim();
      }
      
      if (senderName.startsWith('"') && senderName.endsWith('"')) {
        senderName = senderName.substring(1, senderName.length - 1);
      }
      
      String formattedText = '$senderName $senderEmail Subject: $subject';
      
      emailData[formattedText] = message.id!;
      formattedTextToIdMap[formattedText] = message.id!;
    }

    final response = await _sendEmailToApi(emailData);

    if (response != null) {
      print("API response: ${response.toString()}");

      List<dynamic> results = response['results'];
      
      for (var item in results) {
        String formattedText = item['mail_title'] ?? '';
        String label = item['category'] ?? 'Others';
        String messageId = formattedTextToIdMap[formattedText] ?? '';
        
        if (messageId.isNotEmpty) {
          await _addLabelToEmail(messageId, label);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-mails classified succesfuly.'))
      );
    }
  } catch (e) {
    print("Error occured: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('E-mails could not classified.'))
    );
  }
}

  Future<Map<String, dynamic>?> _sendEmailToApi(Map<String, String> emailData) async {
  const String apiUrl = "http://192.168.1.17:8000/classify";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'text_list': emailData}),
  );

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    return json.decode(responseBody);
  } else {
    print('API request failed: ${response.statusCode}');
    return null;
  }
}

  // ignore: unused_element
  Future<void> _applyLabelsToEmails(Map<String, dynamic> predictedLabels) async {
  try {
    var messages = await _gmailApi!.users.messages.list("me");
    Map<String, String> subjectToIdMap = {};
    
    for (var message in messages.messages!) {
      var msg = await _gmailApi!.users.messages.get("me", message.id!);
      
      var subjectHeader = msg.payload?.headers?.firstWhere(
        (header) => header.name == 'Subject', 
        orElse: () => MessagePartHeader()..value = 'No Subject'
      );
      String subject = subjectHeader?.value ?? 'No Subject';
      
      subjectToIdMap[subject] = message.id!;
    }
    
    for (var entry in predictedLabels.entries) {
      String subject = entry.key;
      String label = entry.value;
      
      if (subjectToIdMap.containsKey(subject)) {
        String messageId = subjectToIdMap[subject]!;
        await _addLabelToEmail(messageId, label);
      }
    }
  } catch (e) {
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('failed..'))
    );
  }
}

  Future<void> _addLabelToEmail(String messageId, String label) async {
  try {
    var labelsList = await _gmailApi!.users.labels.list("me");
    var labelItem = labelsList.labels?.firstWhere((labelItem) => labelItem.name == label);
    
    if (labelItem != null) {
      var labelId = labelItem.id;
      
      if (labelId != null) {
        await _gmailApi!.users.messages.modify(
          ModifyMessageRequest()..addLabelIds = [labelId],
          "me", messageId
        );
      }
    } else {
      print("Label not found: $label");
    }
  } catch (e) {
    print("Label adding error: $e");
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
                    'On this page, you can classify your emails.\n\nOur classes are labeled as "Work and Business","Friends and Family","News and Promotions","Orders and Bills","Application Notifications".\n\nFirst, create your labels by clicking the "Set Labels" button.\n\nThen, you can label all your emails by clicking the "Classify All" button.\n\nThis will provide you with an organized email environment.',
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
                        onPressed: () {
                                _createLabels();
                              },
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                ElevatedButton(
                        onPressed: () async {
                          _classifyEmails();
                        },
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
