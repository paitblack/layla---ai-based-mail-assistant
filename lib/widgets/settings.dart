import 'package:flutter/material.dart';
import 'package:layla/widgets/change_alarm.dart';

class Settingss extends StatelessWidget {
  const Settingss({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeAlarm()));
                  },
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.9,MediaQuery.of(context).size.height * 0.08))
                  ) , 
                  child: Text(
                    'Change Alarm Sound',                   
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9 ,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, 
                        blurRadius: 3,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.solid
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * 0.05 ,),
                      Text(
                        'Alarm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      
                      Switch(
                      
                      value: true, 
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: Colors.grey.withOpacity(0.5), 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9 ,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, 
                        blurRadius: 3,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.solid
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * 0.05 ,),
                      Text(
                        'Alarm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      
                      Switch(
                      
                      value: true, 
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: Colors.grey.withOpacity(0.5), 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9 ,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, 
                        blurRadius: 3,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.solid
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * 0.05 ,),
                      Text(
                        'Alarm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      
                      Switch(
                      
                      value: true, 
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: Colors.grey.withOpacity(0.5), 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  )
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

