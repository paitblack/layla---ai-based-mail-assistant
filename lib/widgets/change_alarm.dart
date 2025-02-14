import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';

class ChangeAlarm extends StatelessWidget {
  const ChangeAlarm({super.key});

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
                            "Change Alarm Sound",
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
                        shape: CircleBorder(),
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.background,
                          size: 75,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100,),
              Column(
                children: [
                  Container(
                      width: 975,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
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
                          SizedBox(width: 30),
                          Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 75,
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                double currentVolume = 0.5; 

                                return Slider(
                                  value: currentVolume,
                                  min: 0,
                                  max: 1,
                                  divisions: 10,
                                  label: (currentVolume * 100).toInt().toString(),
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onChanged: (double value) {
                                    setState(() {
                                      currentVolume = value;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                  width: 975, 
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(width: 30,),
                      Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 775,),
                      Switch(
                      
                      value: true,      // bool deger eklenecek ve onChanged tanimlanacak.
                      onChanged: (bool value) {
                        
                      },
                      activeColor: Colors.white, 
                      activeTrackColor: AppColors.greeny, 
                      inactiveThumbColor: Colors.grey, 
                      inactiveTrackColor: Colors.black26, 
                        ),
                    ],
                  ),
                  ),
                  SizedBox(height: 50,),
                ],
              )
          ]
        ),
      ),
      ),   
    );
  }
}