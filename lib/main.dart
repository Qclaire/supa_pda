import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superpda/stop_watch/main.dart';

import 'index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]).then((_) {
    runApp(MainPage());
  });
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        TimerPage.routeName: (context) => TimerPage(),
      },
    );
  }
}
