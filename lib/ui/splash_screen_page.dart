import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_management/utility/sharedpreferences_helper.dart';

class SplashScreenPage extends StatefulWidget {

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateTo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 8,
                    left: MediaQuery.of(context).size.width / 8),
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
            ),
          ],
        ));
  }

  _navigateTo(){
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, _navigateToPage);
  }

  Future<void> _navigateToPage() async {
    SharedPreferencesHelper.getDoLogin().then((onValue) async {
      if (onValue.isNotEmpty) {
        Navigator.of(context).pushReplacementNamed('/task_page');
      } else {
        Navigator.of(context).pushReplacementNamed('/login_page');
      }
    });
  }

}
