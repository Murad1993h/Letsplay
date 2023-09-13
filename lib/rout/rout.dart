import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Exam/exan.dart';
import '../Screen/MainHome/main_home.dart';
import '../Screen/auth/Login_screen.dart';
import '../SplashScreen/splash_screen.dart';


const String splash = '/splash-screen';

 const String loginScreen = '/LoginScreen';
 const String mapExam = '/MapExam';
// const String homePage= '/home-page';
 const String mainHome= '/MainHome';
// const String videiPlayy= '/videi-playy';
// const String subscrib= '/subscrib';
// const String exampal= '/Exampal';
// const String myHomePage= '/MyHomePage';








List<GetPage> getPages = [
  GetPage(name: splash, page: () => const SplashScreen(),
  ),

   GetPage(name:loginScreen, page: () => LoginScreen(),

  ),
  GetPage(name: mapExam, page: () => MapExam(),

  ),
  // GetPage(name: homePage, page: () => HomePage(),
  //
  // ),
  GetPage(name: mainHome, page: () => MainHome(),

  ),
  // GetPage(name: videiPlayy, page: () => VideiPlayy(),
  //
  // ),
  // GetPage(name:  subscrib, page: () =>  Subscrib(),
  //
  // ),
  // GetPage(name:  exampal, page: () =>  Exampal(),
  //
  // ),
  // GetPage(name:  myHomePage, page: () =>  MyHomePage(),
  //
  // ),












];
