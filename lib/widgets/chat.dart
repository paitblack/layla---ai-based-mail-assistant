import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  
  final ChatBot chatBot = ChatBot();
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [];  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatBot.initialize();
  }

  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add(Message(text: userMessage, sender: 'user')); 
    });

    _controller.clear();
    _scrollToBottom();

    setState(() {
      messages.add(Message(text: '...', sender: 'layla'));
    });

    _scrollToBottom();

    String response = await chatBot.sendMessage(userMessage);

    setState(() {
      messages.removeLast();  
      messages.add(Message(text: response, sender: 'layla'));  
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
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
                            "Chat with Layla",
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
              const SizedBox(height: 30),
              Flexible(
                child: Container(
                  width: 960,
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
                    padding: EdgeInsets.all(15),
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
                        Expanded(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                bool isUserMessage = messages[index].sender == "user";  

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Align(
                                    alignment: isUserMessage
                                        ? Alignment.centerRight  
                                        : Alignment.centerLeft,  
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, 
                                      children: [
                                        if (!isUserMessage)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: CircleAvatar(
                                              radius: 29, 
                                              backgroundColor: Colors.white, 
                                              backgroundImage: AssetImage('images/layla.png'), 
                                            ),
                                          ),
                                        
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.50, 
                                          ),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isUserMessage
                                                ? const Color.fromARGB(255, 208, 230, 250) 
                                                : const Color.fromARGB(255, 238, 221, 198),  
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            messages[index].text,
                                            style: TextStyle(fontSize: 18),
                                            softWrap: true, 
                                            overflow: TextOverflow.fade, 
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: "Message",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: AppColors.background, size: 50),
                              onPressed: sendMessage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


class Message {
  final String text;
  final String sender; 

  Message({required this.text, required this.sender});
}

class ChatBot {
  late GenerativeModel model;

  ChatBot();

  Future<void> initialize() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      String apiKey = remoteConfig.getString('gem_api_key');
      if (apiKey.isNotEmpty) {
        model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
      } else {
        throw Exception("API Key not found in RemoteConfig");
      }
    } catch (e) {
      print("Error fetching API Key: $e");
    }
  }

  Future<String> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return "Type.";

    try {
      final response = await model.generateContent([Content.text(userMessage)]);
      return response.text ?? "no feedback.";
    } catch (e) {
      print("Error sending message: $e");
      return "An error occured. Try later...";
    }
  }
}
