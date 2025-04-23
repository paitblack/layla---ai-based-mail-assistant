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

  final List<String> labels = ["Advertisement", "News", "Work", "Family & Friends", "Others"];

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

    final labelsToCreate = ["Work", "Advertisement", "News","Family & Friends", "Others"];

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

  // E-posta baþlýklarýný ve ID'lerini alýp API'ye göndermek
  Future<void> _classifyEmails() async {
  if (_gmailApi == null) {
    await _initGmailApi();
  }

  try {
    // Get all emails from Gmail API
    var messages = await _gmailApi!.users.messages.list("me");

    Map<String, String> emailData = {};
    Map<String, String> subjectToIdMap = {};
    
    // Set up email headers and IDs
    for (var message in messages.messages!) {
      var msg = await _gmailApi!.users.messages.get("me", message.id!);
      
      var subjectHeader = msg.payload?.headers?.firstWhere(
        (header) => header.name == 'Subject', 
        orElse: () => MessagePartHeader()..value = 'No Subject'
      );
      String subject = subjectHeader?.value ?? 'No Subject';
      
      emailData[subject] = message.id!;
      subjectToIdMap[subject] = message.id!;
    }

    // Send to API
    final response = await _sendEmailToApi(emailData);

    // Process API response
    if (response != null) {
      print("API response: ${response.toString()}");

      // Get the results array from the response
      List<dynamic> results = response['results'];
      
      // Process each result
      for (var item in results) {
        String subject = item['mail_title'] ?? 'No Subject';
        String label = item['category'] ?? 'Others';
        String messageId = subjectToIdMap[subject] ?? '';
        
        // Apply label to the email
        if (messageId.isNotEmpty) {
          await _addLabelToEmail(messageId, label);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-postalar baþarýyla sýnýflandýrýldý.'))
      );
    }
  } catch (e) {
    print("Hata oluþtu: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('E-posta sýnýflandýrma baþarýsýz oldu.'))
    );
  }
}


  // API'ye e-posta verilerini gönderme fonksiyonu
  Future<Map<String, dynamic>?> _sendEmailToApi(Map<String, String> emailData) async {
  const String apiUrl = "http://10.0.2.2:8000/classify";

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

  // Tahmin edilen etiketlere göre e-postalarý etiketleme fonksiyonu
  Future<void> _applyLabelsToEmails(Map<String, dynamic> predictedLabels) async {
  try {
    // Get messages to find the IDs
    var messages = await _gmailApi!.users.messages.list("me");
    Map<String, String> subjectToIdMap = {};
    
    // First, build a map of subject to message ID
    for (var message in messages.messages!) {
      var msg = await _gmailApi!.users.messages.get("me", message.id!);
      
      var subjectHeader = msg.payload?.headers?.firstWhere(
        (header) => header.name == 'Subject', 
        orElse: () => MessagePartHeader()..value = 'No Subject'
      );
      String subject = subjectHeader?.value ?? 'No Subject';
      
      subjectToIdMap[subject] = message.id!;
    }
    
    // Now apply labels using the map
    for (var entry in predictedLabels.entries) {
      String subject = entry.key;
      String label = entry.value;
      
      if (subjectToIdMap.containsKey(subject)) {
        String messageId = subjectToIdMap[subject]!;
        await _addLabelToEmail(messageId, label);
      }
    }
  } catch (e) {
    print("Hata oluþtu: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('E-posta etiketleme baþarýsýz oldu.'))
    );
  }
}

  // E-posta ID'sine etiket ekleme fonksiyonu
  Future<void> _addLabelToEmail(String messageId, String label) async {
  try {
    var labelsList = await _gmailApi!.users.labels.list("me");
    var labelItem = labelsList.labels?.firstWhere((labelItem) => labelItem.name == label);
    
    if (labelItem != null) {
      var labelId = labelItem.id;
      
      if (labelId != null) {
        // Etiketi e-postaya ekliyoruz
        await _gmailApi!.users.messages.modify(
          ModifyMessageRequest()..addLabelIds = [labelId],
          "me", messageId
        );
      }
    } else {
      print("Label not found: $label");
    }
  } catch (e) {
    print("Etiket ekleme hatasý: $e");
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
