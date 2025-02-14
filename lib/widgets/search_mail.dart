import 'package:flutter/material.dart';
import 'package:layla/theme/colors.dart';

class SearchMail extends StatelessWidget {
  const SearchMail({super.key});

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
                            "Search a mail",
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
                          Icons.home_filled,
                          color: AppColors.background,
                          size: 75,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 90),
              Column(
                children: [
                  Container(
                    width: 985,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                    child: Center(
                      child: Container(
                        width: 960,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter a few key words...",  ///Search button eklenecek.
                              border: InputBorder.none, 
                            ),
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: 985,
                    height: 1400,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Container(
                        width: 960,
                        height: 90,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                    child: Text(
                      'Gonderen mail veya isim',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                        width: 960,
                        height: 1265,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        "Mail icerigi(scrollable).......\n.\n.\n.\n.\n.\n.\n.\n.\n.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}