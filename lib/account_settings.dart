import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Text('Account Settings')

    );


  }
}