import 'package:flutter/material.dart';

class ChangeAlarm extends StatelessWidget {
  const ChangeAlarm({super.key});

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
          child: SingleChildScrollView( 
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white24,
                  elevation: 4,
                  title: Text(
                    "Change Alarm Sound",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                          Icon(
                            Icons.volume_up,
                            color: Colors.grey,
                            size: 45,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
                                  activeColor: Colors.black,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context), 
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildSwitchContainer(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchContainer(BuildContext context) { 
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            spreadRadius: 0,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          Text(
            'Alarm',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: true,
            onChanged: (bool value) {},
            activeColor: Colors.white,
            activeTrackColor: Colors.grey.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black26,
          ),
        ],
      ),
    );
  }
}
