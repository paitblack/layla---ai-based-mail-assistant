import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';
import 'package:layla/widgets/settings.dart';
import 'package:layla/widgets/search_mail.dart';
import 'package:layla/widgets/chat.dart';
import 'package:layla/widgets/classify.dart';
import 'package:layla/widgets/ocr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layla/widgets/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.modify', 
    'https://www.googleapis.com/auth/gmail.labels', 
    'https://www.googleapis.com/auth/gmail.compose'
    'https://www.googleapis.com/auth/gmail.send',
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
                  "Home Page",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black), 
                ),
                actions: <Widget>[
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
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.notifications,
                      color: Colors.black, 
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                width: MediaQuery.of(context).size.width * 0.90, 
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                    color:  Colors.white,
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
                      SizedBox(height:MediaQuery.of(context).size.height * 0.02 ,),
                      Row(
                        children: [
                          SizedBox(width:MediaQuery.of(context).size.height * 0.02 ,),
                          Image.asset("images/gmail.png",width: MediaQuery.of(context).size.height * 0.05,height:MediaQuery.of(context).size.height * 0.05 ,),
                          SizedBox(width:MediaQuery.of(context).size.height * 0.02 ,),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                mail!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,  
                                ),
                                softWrap: true,  
                                overflow: TextOverflow.ellipsis, 
                              ),
                            ),
                          )

                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: (){  
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Settingss()));
                                },
                                style: ButtonStyle(
                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.02 ,horizontal: MediaQuery.of(context).size.height * 0.05)),
                                backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(248, 255, 234, 241)),
                                shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                              ),
                                child: Text("Settings",
                                style: TextStyle(
                                  color: Colors.black,
                                ),)
                                ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                              ElevatedButton(
                                onPressed: ()async {
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
                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.02 ,horizontal: MediaQuery.of(context).size.height * 0.05)),
                                backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 253, 243, 215)),
                                shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                              ),
                                child:Text("Log out",
                                style: TextStyle(
                                  color: Colors.black
                                ),)
                                ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMail()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.175),),
                          ),
                          child: Text(
                            'Search mails', 
                            style: TextStyle(
                            color: AppColors.redy,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          ),
                          ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.175),),
                          ),
                          child: Text(
                            'Chat with Layla', 
                            style: TextStyle(
                            color: AppColors.greeny,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          ),
                          ),

                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Classify()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.175),),
                          ),
                          child: Text(
                            'Classify', 
                            style: TextStyle(
                            color: AppColors.yellowy,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          ),
                          ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Alarm()));
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                            shape : WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.175),),
                          ),
                          child: Text(
                            'OCR Mailer', 
                            style: TextStyle(
                            color: AppColors.bluey,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          ),
                          ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}