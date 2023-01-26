import 'package:flutter/material.dart';

class CarSettings extends StatefulWidget {
  const CarSettings({Key? key}) : super(key: key);

  @override
  State<CarSettings> createState() => CarSettingsState();
}

class CarSettingsState extends State<CarSettings> {



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Car Settings')

    );


  }
}