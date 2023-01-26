import 'dart:async';

import 'package:chargetrip_app/bottom_navigation/routes_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chargetrip_app/locations.dart';
import 'package:chargetrip_app/bottom_navigation/navigator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int page = 0;
  NavigatorBar ?navigatorBar;
  @override
  void initState() {
    super.initState();
    navigatorBar = NavigatorBar(currentPage: (i){
      setState(() {
        page = i;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigatorBar,
      body: RoutesNav(index: page),
    );
  }


}

