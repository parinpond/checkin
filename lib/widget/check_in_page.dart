import 'package:checkin/utility/my_style.dart';
import 'package:checkin/utility/signout_process.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInPage extends StatefulWidget {
  CheckInPage({Key key}) : super(key: key);

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String nameUser;
  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.pink[50],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                MyStyle().showTitle('Check in'),
                Center(
                    child: Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25.0),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
