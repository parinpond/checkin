import 'dart:convert';

import 'package:checkin/model/user_model.dart';
import 'package:checkin/screens/main_user.dart';
import 'package:checkin/utility/my_constant.dart';
import 'package:checkin/utility/my_style.dart';
import 'package:checkin/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Field
  String user, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
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
                MyStyle().showTitle('Checkin'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
  Widget loginButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().darkColor,
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบ คะ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  Future<Null> checkAuthen() async {
    String url = '${MyConstant().domain}checkUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      //print(url);
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);

        if (password == userModel.password) {
          routeTuService(MainUser(), userModel);
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่ ');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('Name', userModel.name);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
