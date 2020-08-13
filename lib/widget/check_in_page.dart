import 'package:checkin/utility/my_constant.dart';
import 'package:checkin/utility/my_style.dart';
import 'package:checkin/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CheckInPage extends StatefulWidget {
  CheckInPage({Key key}) : super(key: key);

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String nameUser, idUser;
  double lat, lng;
  @override
  void initState() {
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat, lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      idUser = preferences.getString('id');
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
                MyStyle().mySizebox(),
                lat == null ? MyStyle().showProgress() : showMap(),
                checkinButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkinButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: MyStyle().darkColor,
              onPressed: () {
                checkinThread();
              },
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              label: Text(
                'Checkin',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Future<Null> checkinThread() async {
    DateTime dateTime = DateTime.now();
    String checkinDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    print('$checkinDateTime');
    String lat = '12';
    String lng = '13';
    String url =
        '${MyConstant().domain}checkin.php?isAdd=true&user_id=$idUser&latitude=$lat&longitude=$lng';
    print('$url');
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        showToast('Insert Success');
      } else {
        normalDialog(context, 'กรุณาลองใหม่ มีอะไร ? ผิดพลาด');
      }
    });
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ต่ำแหน่งของคุณ',
          snippet: 'ละติจูด = $lat, ลองติจูต = $lng',
        ),
      )
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 300.0,
      child: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }
}
