import 'package:chargetrip_app/account_settings.dart';
import 'package:chargetrip_app/routes/route_map.dart';
import 'package:chargetrip_app/car_info/car_settings.dart';
import 'package:chargetrip_app/main.dart';
import 'package:flutter/material.dart';

class NavigatorPages extends StatelessWidget {
  final int index;
  const NavigatorPages({Key? key, required this.index}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    List<Widget> list = [
      const MapSample(),
      const CarSettings(),
      const AccountSettings()
    ];
    return list[index];
  }
}