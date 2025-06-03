import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  String recognizedText = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFile(File(pickedFile.path));
      final textRecognizer = TextRecognizer();
      final RecognizedText result = await textRecognizer.processImage(inputImage);

      setState(() {
        recognizedText = result.text;
        textController.text = recognizedText;
      });
    }
  }

  void showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Use Camera"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: textController.text,
      subject: subjectController.text,
      recipients: [emailController.text],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
                title: const Text(
                  "OCR Mailer",
                  style: TextStyle(color: Colors.black),
                ),
                automaticallyImplyLeading: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: showImageSourceSelector,
                        child: const Text("Scan Text From Image"),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: textController,
                        maxLines: 25,
                        decoration: const InputDecoration(
                          labelText: "Scanned/Edited Text",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          floatingLabelStyle: TextStyle(
                            backgroundColor: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Recipient Email",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            backgroundColor: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            backgroundColor: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendEmail,
                        child: const Text("Send Mail"),
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
