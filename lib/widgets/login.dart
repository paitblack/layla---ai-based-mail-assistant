import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layla/theme/colors.dart';
import 'home_page.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'images/layla.png',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              Container(
                width: 880,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 850,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
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
                        "Hi! My name is Layla. I can't wait to be your mail assistant. Let's log in and get started.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
             
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: RawMaterialButton(
                    onPressed: () => _signInWithGoogle(context),
                    child: Image.asset(
                      'images/gmail.png',
                      height: 200,
                      width: 200,
                    ),
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