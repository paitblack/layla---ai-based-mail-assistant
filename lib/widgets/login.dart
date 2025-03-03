import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
  
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
        'https://www.googleapis.com/auth/gmail.readonly', 
        'https://www.googleapis.com/auth/gmail.modify', 
        'https://www.googleapis.com/auth/gmail.labels', 
        'https://www.googleapis.com/auth/gmail.compose',
        'https://www.googleapis.com/auth/gmail.send'
          ],).signIn();
      if (googleUser == null) {
       
        return;
      }
  
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

    
      await FirebaseAuth.instance.signInWithCredential(credential);
 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(signedIN : FirebaseAuth.instance.currentUser)),
      );
    } catch (e) {
      print("Hata: $e");
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
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  offset: Offset(0, 4), 
                  blurRadius: 10, 
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Image.asset(
                    "images/layla.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        "Hi! My name is Layla. I can't wait to be your mail assistant. Let's log in and get started.",
                        textAlign: TextAlign.center,
                      )
                    ],
                    totalRepeatCount: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _signInWithGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "images/gmail.png",
                        height: MediaQuery.of(context).size.width * 0.05,
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Log in via Google",
                        selectionColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}