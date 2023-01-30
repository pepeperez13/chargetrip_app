import 'dart:async';

import 'package:chargetrip_app/bottom_navigation/navigator_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chargetrip_app/routes/locations.dart';
import 'package:chargetrip_app/bottom_navigation/navigator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChargeTrip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({required this.user});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int page = 0;
  NavigatorBar? navigatorBar;

  @override
  void initState() {
    super.initState();
    navigatorBar = NavigatorBar(currentPage: (i){
      setState(() {
        page = i;
      });
    }, user: widget.user);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigatorBar,
      body: NavigatorPages(index: page, user: widget.user),
    );
  }
}

