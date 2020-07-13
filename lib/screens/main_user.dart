import 'package:checkin/utility/my_style.dart';
import 'package:checkin/utility/signout_process.dart';
import 'package:checkin/widget/check_in_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  MainUser({Key key}) : super(key: key);

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  Widget currentWidget;
  @override
  void initState() {
    super.initState();
    currentWidget = CheckInPage();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                menuCheckin(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  ListTile menuCheckin() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = CheckInPage();
        });
      },
      leading: Icon(Icons.home),
      title: Text('Check in'),
      subtitle: Text('Check in สถานที่ วัน เวลา'),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.pink),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'การออกจากแอพ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.pink,
      ),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser == null ? 'Name Login' : nameUser,
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
