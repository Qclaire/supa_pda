import 'package:flutter/material.dart';
import 'package:superpda/stop_watch/main.dart';

class HomePage extends StatelessWidget {
  static String routeName = "home_page";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, TimerPage.routeName)},
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/images/timer.png"),
                        ),
                        Text("Timer"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
