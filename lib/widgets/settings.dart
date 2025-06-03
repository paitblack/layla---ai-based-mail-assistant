import 'package:flutter/material.dart';

class Settingss extends StatelessWidget {
  const Settingss({super.key});

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
                  "Settings",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black), 
                ),
              ),
              
                  
                  
                
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}

