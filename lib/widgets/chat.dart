import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

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
                title: Text(
                  "Chat with Layla",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26, width: 1),
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
                                              radius: 15, 
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
                                                ? const Color.fromARGB(255, 246, 216, 252) 
                                                : const Color.fromARGB(255, 255, 254, 225),  
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            messages[index].text,
                                            style: TextStyle(fontSize: 12),
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
                                hintText: "Type a message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                               style: TextStyle(fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.black12, size: 30),
                            onPressed: sendMessage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
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
    if (userMessage.isEmpty) return "Type something...";
    try {
      final response = await model.generateContent([Content.text(userMessage)]);
      return response.text ?? "No response available.";
    } catch (e) {
      print("Error sending message: $e");
      return "An error occurred. Please try again later.";
    }
  }
}