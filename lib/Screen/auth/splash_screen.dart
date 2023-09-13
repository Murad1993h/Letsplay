import 'dart:async';
import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:letsplay/Appurl/Services/shareed_services.dart';
import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


import '../../Appurl/Appurl.dart';
import '../Daily_matches/no_internet.dart';
import '../MainHome/main_home.dart';
import '../Update_app.dart';
import 'Login_screen.dart';
import 'Maintanence.dart';

import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // static final String onesignal_app_id='185cc73a-68a3-4868-9058-5633f5aeb0a4';
  var token;
  // Future<void> initPlatformState(){  OneSignal.shared.setAppId(onesignal_app_id);
  // }
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }

  var check_main;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response =
        await http.get(Uri.parse(AppUrl.maintanence), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status']);
      setState(() {
        check_main = userData1['status'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future u() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response =
        await http.get(Uri.parse(AppUrl.mapk), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('ajib');
    print(userData1);
      setState(() {
        update = userData1['version'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  late AnimationController _controller;
var update;

getToken () async {
  final pref = await SharedPreferences.getInstance();
  print('Token ${pref.getString('my_token')}');
}
  @override
  void initState() {
    // TODO: implement initState
    getToken();
    isLoogedIn();
    // initPlatformState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    // Timer(Duration(milliseconds: 200),()=> );
    _controller.forward();
    telegram();
    super.initState();
    startTimer();
    u();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  startTimer() async {
    var duration = Duration(milliseconds: 2000);
    return new Timer(duration, () {
      SharedServices().checkLogin(context);
    });
  }

  Naviagate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainHome()));
  }

  Naviagatelogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  Naviagatemain() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => update_app()));
  }
Naviagatemain2() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => maintanence()));
  }no() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => no_internet()));
  }

  var main = 3;
  var version;
  // getversion()async{
  //   var packageInfo = await PackageInfo.fromPlatform();
  //   String appName = packageInfo.appName;
  //   String packageName = packageInfo.packageName;
  //   String version_ = packageInfo.version;
  //   String buildNumber = packageInfo.buildNumber;
  //   setState(() {
  //     version=version_;
  //   });
  //
  // }

  route() async{
    var packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version_ = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print('New');
    print(version_);
    setState(() {
      version=version_;
    });

    SharedServices().checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),
              Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          CircularProfileAvatar("",
                              borderColor: Colors.transparent,
                              child:Image.asset("Images/l.jpeg"),
                              elevation: 5,
                              radius: 40),                             SizedBox(
                            height: MediaQuery.of(context).size.height / 25,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue,
                            child: Text("AB ESPORTS".toUpperCase(),
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 140.0, right: 140),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white30,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        ],
                      ))),
            ],
          ),
        ));
  }
}
