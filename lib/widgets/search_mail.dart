import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:layla/widgets/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchMail extends StatefulWidget {
  @override
  _SearchMailState createState() => _SearchMailState();
}

class _SearchMailState extends State<SearchMail> {
  final TextEditingController _searchController = TextEditingController();
  List<Message> _emails = [];
  String emailContent = '';
  GmailApi? _gmailApi;
  String senderName = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initGmailApi();
  }

  Future<void> _initGmailApi() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _gmailApi = await HomePage(signedIN: user).gmailAPIaccess(context);
    }
  }

  Future<void> _searchEmails() async {
    if (_gmailApi == null) return;

    setState(() => _isLoading = true);

    try {
      var query = _searchController.text;
      var response = await _gmailApi!.users.messages.list('me', q: query);

      if (response.messages != null && response.messages!.isNotEmpty) {
        List<Message> fetchedEmails = [];

        for (var msg in response.messages!) {
          var fullMessage = await _gmailApi!.users.messages.get('me', msg.id!);
          String? subject, from;
          
          fullMessage.payload?.headers?.forEach((header) {
            if (header.name == "Subject") subject = header.value;
            if (header.name == "From") from = header.value;
          });

          msg.payload = MessagePart(headers: [
            MessagePartHeader(name: "Subject", value: subject ?? "No Subject"),
            MessagePartHeader(name: "From", value: from ?? "Unknown Sender")
          ]);

          fetchedEmails.add(msg);
        }

        setState(() => _emails = fetchedEmails);
      } else {
        setState(() => _emails = []);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white24,
                elevation: 4,
                title: Text("Search Mails", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Enter a few key words...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: _searchEmails,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _emails.isEmpty
                          ? Center(child: Text("No emails found"))
                          : ListView.separated(
                              itemCount: _emails.length,
                              separatorBuilder: (context, index) => Divider(color: Colors.black26, thickness: 0.5),
                              itemBuilder: (context, index) {
                                var message = _emails[index];
                                String subject = "No Subject";
                                String from = "Unknown Sender";

                                message.payload?.headers?.forEach((header) {
                                  if (header.name == "Subject") subject = header.value!;
                                  if (header.name == "From") from = header.value!;
                                });

                                return ListTile(
                                  title: Text(subject, style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(from),
                                );
                              },
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
