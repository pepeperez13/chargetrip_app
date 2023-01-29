import 'package:flutter/material.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({Key? key, required this.currentPage}) : super(key: key);

  final Function currentPage;

  @override
  NavigatorBarState createState() => NavigatorBarState();
}

class NavigatorBarState extends State<NavigatorBar> {
  int index = 0;
  @override
  Widget build (BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
        onTap: (int i){
        setState(() {
          index = i;
          widget.currentPage(i);
          });
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
        ]);
  }
}