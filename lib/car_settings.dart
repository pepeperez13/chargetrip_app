import 'package:flutter/material.dart';

class CarSettings extends StatefulWidget {
  const CarSettings({Key? key}) : super(key: key);

  @override
  State<CarSettings> createState() => CarSettingsState();
}

class CarSettingsState extends State<CarSettings> {

  



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: const [
          SizedBox(height: 80),
          Center(
            child: Text('Your car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          )





        ],

      )

    );


  }
}