import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsplay/Screen/auth/Login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screen/MainHome/main_home.dart';

class SharedServices {
  checkLogin (context) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('my_token');
    if(token != null){
      Get.offAll(() => MainHome());
    } else {
      Get.offAll(() => LoginScreen());

    }
  }
}