import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:layla/theme/colors.dart';
import 'package:layla/widgets/home_page.dart';

class SearchMail extends StatefulWidget {
  const SearchMail({super.key});

  @override
  _SearchMailState createState() => _SearchMailState();
}

class _SearchMailState extends State<SearchMail> {
  final TextEditingController _searchController = TextEditingController();
  List<Message> _emails = [];
  String _emailContent = '';
  GmailApi? _gmailApi;

  @override
  void initState() {
    super.initState();
    _initGmailApi();
  }

  Future<void> _initGmailApi() async {
    _gmailApi = await HomePage(signedIN: null).gmailAPIaccess(context);
  }

  Future<void> _searchEmails() async {
    if (_gmailApi == null) {
      print("Gmail API baslatilmadi.");
      return;
    }

    try {
      var query = _searchController.text;
      var response = await _gmailApi!.users.messages.list('me', q: query);

      setState(() {
        _emails = response.messages ?? [];
        _emailContent = '';
      });
    } catch (e) {
      print("E-posta arama hatasi: $e");
    }
  }

  Future<void> _getEmailContent(String messageId) async {
    if (_gmailApi == null) {
      print("Gmail API baslatilmadi.");
      return;
    }

    try {
      var message = await _gmailApi!.users.messages.get('me', messageId);
      setState(() {
        _emailContent = message.snippet ?? 'E-posta alinamadi.';
      });
    } catch (e) {
      print("E-posta getirme hatasi: $e");
    }
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
                  "Search a mail",
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
              child: Icon(Icons.home_filled, color: AppColors.background, size: 75),
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
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            width: 960,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Text(
              'Sender mail or name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: 960,
            height: 1265,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: _emails.map((message) {
                  return ListTile(
                    title: Text(message.snippet ?? 'No Subject'),
                    onTap: () => _getEmailContent(message.id!),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
