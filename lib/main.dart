import 'package:flutter/material.dart';
import 'package:checkin/screens/home.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      title: 'Checkin',
      home: Home(),
    );
  }
}
