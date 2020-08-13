import 'dart:convert';

import 'package:checkin/model/history_model.dart';
import 'package:checkin/utility/my_constant.dart';
import 'package:checkin/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String nameUser;
  List<HistoryModel> historyModels = List();
  List<int> _counter = List();
  @override
  void initState() {
    super.initState();
    findUser();
    readHistory();
  }

  Future<Null> readHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url = '${MyConstant().domain}history.php?isAdd=true&user_id=$id';
    print('$url');
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          HistoryModel historyModel = HistoryModel.fromJson(map);
          setState(() {
            historyModels.add(historyModel);
          });
        }
      } else {}
    });
    print('$historyModels');
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildName(nameUser),
            buildHeadTitle(),
            buildList(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget buildList() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: historyModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(''),
            ),
            Expanded(
              flex: 2,
              child: Text(historyModels[index].datetime),
            ),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () => showMapCheckIn(historyModels[index]),
                )),
          ],
        ),
      );
  Future<Null> showMapCheckIn(HistoryModel historyModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('สถานที่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: MyStyle().primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                label: Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildName(nameUser) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('ชื่อ $nameUser'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('#'),
          ),
          Expanded(
            flex: 2,
            child: MyStyle().showTitleH3('เวลา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('สถานที่'),
          ),
        ],
      ),
    );
  }
}
