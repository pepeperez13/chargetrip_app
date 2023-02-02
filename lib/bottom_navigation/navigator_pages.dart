import 'package:chargetrip_app/account_settings.dart';
import 'package:chargetrip_app/routes/route_map.dart';
import 'package:chargetrip_app/car_info/car_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Clase que contiene los elementos del BottomNavigatorBar que nos permitirá navegar por la app
class NavigatorPages extends StatelessWidget {
  final int index;
  final User? user;
  const NavigatorPages({Key? key, required this.index, required this.user}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    List<Widget> list = [
      MapSample(),
      CarSettings(),
      AccountSettings(user: user),
    ];
    return list[index];
  }
}