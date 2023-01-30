import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../account_settings.dart';
import '../car_info/car_settings.dart';
import '../routes/route_map.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({Key? key, required this.currentPage, required this.user}) : super(key: key);

  final Function currentPage;
  final User? user;

  @override
  NavigatorBarState createState() => NavigatorBarState();
}

class NavigatorBarState extends State<NavigatorBar> {
  int index = 0;
  late List<Widget> children;

  // Implementamos con un PageController para que los datos de una pantalla se mantengan aunque salgamos de la pantalla
  final pageController = PageController();
  void onPageChanged(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  void initState() {
    super.initState();
    children = [MapSample(), CarSettings(), AccountSettings(user: widget.user)];
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        body: PageView(
          // EL scroll entre páginas debe deshabilitarse para que el scroll del mapa funcione
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: children,
        ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int i){
          pageController.jumpToPage(i);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.electric_bolt_outlined),
              label: 'Route'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Your Car'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account'
          ),
        ]
    )
    );
  }
}