import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';
import 'package:layla/widgets/settings.dart';
import 'package:layla/widgets/search_mail.dart';
import 'package:layla/widgets/chat.dart';
import 'package:layla/widgets/classify.dart';
import 'package:layla/widgets/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layla/widgets/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.modify', 
    'https://www.googleapis.com/auth/gmail.labels', 
    'https://www.googleapis.com/auth/gmail.compose',
]);
final mail = FirebaseAuth.instance.currentUser?.email;
final bool isSignedIn = FirebaseAuth.instance.currentUser != null;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class HomePage extends StatelessWidget {
  final User? signedIN;
  const HomePage({super.key, required this.signedIN});

  Future<GmailApi?> gmailAPIaccess(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser == null) {
        print("Google hesabina giris yapilmamis.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        print("Google Access Token alinamadi.");
        return null;
      }

      final authHeaders = {'Authorization': 'Bearer $accessToken'};
      final authenticateClient = GoogleAuthClient(authHeaders);

      final GmailApi gmailApi = GmailApi(authenticateClient);
      print("Gmail API basariyla olusturuldu!");

      return gmailApi;
    } catch (e) {
      print("Gmail API erisim hatasi: $e");
      return null;
    }
  }


static const IconData notifications = IconData(0xe44f, fontFamily: 'MaterialIcons'); 
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
              SizedBox(height: 20),
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
                      SizedBox(width: 0),  
                      Image.asset(
                        'images/layla.png',
                        width: 150,
                        height: 150,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Home Page",
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Notifications'),
                                content: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: 200, 
                                  /*child: ListView(
                                    children: notifications.isEmpty
                                        ? [
                                            Center(child: Text('There is no notification')),
                                          ]
                                        : [
                                            ...notifications.map((notification) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  height: 50,
                                                  color: Colors.amber[100],
                                                  child: Center(child: Text(notification)),
                                                ),
                                              );
                                            }).toList(),
                                            Divider(),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  notifications.clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Clear',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                  ),*/
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();  // Dialogu kapat
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        
                        },
                        shape: CircleBorder(),
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.notifications,
                          color: AppColors.background,
                          size: 75,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 100), 

              Align(
                alignment: Alignment.center,
                child: Container( ///container right???? check
                  width: MediaQuery.of(context).size.width * 0.90, 
                  height: MediaQuery.of(context).size.height * 0.25,
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85, 
                      height: MediaQuery.of(context).size.height * 0.225,  
                      decoration: BoxDecoration(
                        color: Colors.white,  
                        borderRadius: BorderRadius.circular(20),  
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
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.15, 
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
                                    ]
                                  ),
                                  child: Image.asset(
                                    'images/gmail.png'
                                  ),
                                ),
                              ),
                              SizedBox(width: 65),
                              Align(
                                
                                alignment: Alignment.center,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.60, 
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
                                  
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                    
                                    width: MediaQuery.of(context).size.width * 0.575, 
                                    height: MediaQuery.of(context).size.height * 0.07,  
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
                                    child: Center(
                                      child: Text(
                                    mail!,
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(
                                      color: Colors.black, 
                                      fontSize: 36, 
                                      fontWeight: FontWeight.bold, 
                                    ),
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              ),
                          
                            ],
                          ),
                          SizedBox(height: 40),
                          ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Settingss()));
                          },                                         
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20,horizontal: 200)),
                            backgroundColor: WidgetStatePropertyAll(AppColors.background),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                          SizedBox(height: 40),
                          ElevatedButton(
                          onPressed: () async {
                            try {
                              
                              await _googleSignIn.signOut();

                              
                              await FirebaseAuth.instance.signOut();

                              
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            } catch (e) {
                              print('Error during sign out: $e');
                            }
                          },                                       
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20,horizontal: 203)),
                            backgroundColor: WidgetStatePropertyAll(AppColors.background),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          child: Text(
                            'Log  out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
              Align(
                alignment: Alignment.center,
                child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 60),
                          ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMail()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(AppColors.bluey),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(400, 400)),
                          ),
                          child: Text(
                            'Search \n mails', 
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          ),
                          
                          SizedBox(width: 100),
                          ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(AppColors.greeny),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(400, 400)),
                          ),
                          child: Text(
                            'Chat with \n assistant', 
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height:100),
                      Row(
                        children: [
                          SizedBox(width: 60),
                          ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Classify()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(AppColors.redy),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(400, 400)),
                          ),
                          child: Text(
                            'Classify', 
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          ),
                          
                          SizedBox(width: 100),
                          ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Alarm()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(AppColors.yellowy),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(400, 400)),
                          ),
                          child: Text(
                            'Set an alarm', 
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                ),     
            ],
          ),
        ),
      ),
    );
  }
}