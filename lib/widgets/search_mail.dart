import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:layla/theme/colors.dart';
import 'package:layla/widgets/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchMail extends StatefulWidget {
  const SearchMail({super.key});

  @override
  _SearchMailState createState() => _SearchMailState();
}

class _SearchMailState extends State<SearchMail> {
  final TextEditingController _searchController = TextEditingController();
  List<Message> _emails = [];
  String emailContent = '';
  GmailApi? _gmailApi;
  String senderName = "";
  int index = 1;
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _initGmailApi();
  }

  Future<void> _initGmailApi() async {
    _gmailApi = await HomePage(signedIN: FirebaseAuth.instance.currentUser)
        .gmailAPIaccess(context);
  }

  Future<void> _searchEmails() async {
    if (_gmailApi == null) {
      print("1.");
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    try {
      var query = _searchController.text;
      var response = await _gmailApi!.users.messages.list('me', q: query);

      if (response.messages != null && response.messages!.isNotEmpty) {
        List<Message> fetchedEmails = [];

        for (var msg in response.messages!) {
          var fullMessage = await _gmailApi!.users.messages.get('me', msg.id!);
          
          String? subject;
          String? from;

          if (fullMessage.payload != null && fullMessage.payload!.headers != null) {
            for (var header in fullMessage.payload!.headers!) {
              if (header.name == "Subject") {
                subject = header.value;
              }
              if (header.name == "From") {
                from = header.value;
              }
            }
          }

          msg.payload = MessagePart(headers: [
            MessagePartHeader(name: "Subject", value: subject ?? "No Subject"),
            MessagePartHeader(name: "From", value: from ?? "Unknown Sender")
          ]);

          fetchedEmails.add(msg);
        }

        setState(() {
          _emails = fetchedEmails;
        });
      } else {
        setState(() {
          _emails = [];
          emailContent = "2.";
        });
      }
    } catch (e) {
      print("3: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getEmailContent(String messageId) async {
    if (_gmailApi == null) {
      print("4.");
      return;
    }

    try {
      var message = await _gmailApi!.users.messages.get('me', messageId);
      String? subject;
      String? from;

      if (message.payload != null && message.payload!.headers != null) {
        for (var header in message.payload!.headers!) {
          if (header.name == "Subject") {
            subject = header.value;
          }
          if (header.name == "From") {
            from = header.value;
          }
        }
      }

      setState(() {
        emailContent = subject ?? '5';
        senderName = from ?? '6';
      });
    } catch (e) {
      print("7: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildHeader(context),
                  SizedBox(height: 90),
                  _buildSearchBox(),
                  SizedBox(height: 20),
                  _buildEmailList(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Row(
          children: [
            Image.asset('images/layla.png', width: 150, height: 150),
            Expanded(
              child: Center(
                child: Text(
                  "Search mails",
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
              onPressed: () => Navigator.pop(context),
              shape: CircleBorder(),
              fillColor: Colors.white,
              padding: EdgeInsets.all(10),
              child:
                  Icon(Icons.home_filled, color: AppColors.background, size: 75),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 985,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Row(
          children: [
            SizedBox(width: 10),
            Container(
              width: 850,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Enter a few key words...",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _searchEmails,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
              child: Icon(Icons.send, size: 50, color: AppColors.background),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailList() {
    return Container(
      width: 985,
      height: 1400,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _emails.length,
            itemBuilder: (context, index) {
              var message = _emails[index];

              String subject = "No Subject";
              String from = "Unknown Sender";

              if (message.payload != null && message.payload!.headers != null) {
                for (var header in message.payload!.headers!) {
                  if (header.name == "Subject") {
                    subject = header.value!;
                  }
                  if (header.name == "From") {
                    from = header.value!;
                  }
                }
              }

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      'Subject: $subject',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Sender: $from',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      _getEmailContent(message.id!);
                    },
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
