import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letsplay/Screen/me/transaction_history.dart';
import 'package:letsplay/Screen/me/transfare_blance.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';


import '../../Appurl/Appurl.dart';
import '../../rout/rout.dart';
import '../Daily_matches/Refer.dart';
import '../MainHome/main_home.dart';
import 'Withdraw.dart';
import 'depostie.dart';
import 'package:http/http.dart' as http;

class my_wallet extends StatefulWidget {
  @override
  _my_walletState createState() => _my_walletState();
}

class _my_walletState extends State<my_wallet> {
  var balance_ammount;
  Future? blaanceofuser;
  // Future balance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');
  //
  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };
  //
  //   var response = await http.get(Uri.parse(AppUrl.transaction_hostory), headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     print('Get post collected' + response.body);
  //     var userData1 = jsonDecode(response.body)['data'];
  //     print(userData1);
  //     print(userData1['balance']);
  //     setState(() {
  //       balance_ammount=userData1['balance'];
  //       win_earn=userData1['winingBalance'];
  //     });
  //     return userData1;
  //   } else {
  //     print("post have no Data${response.body}");
  //   }
  // }
  var win_earn, deposite_earn, refere_earn;
  Future details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.match_count), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['matchCount']);
      setState(() {
        deposite_earn = userData1['deposit'];
        refere_earn = userData1['ref_earn'];
        balance_ammount = userData1['balance'];
        win_earn = userData1['winingBalance'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  var telegram_link;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.telegram), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['link']);
      setState(() {
        telegram_link = userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future? det;
  Timer? notification_timer;
  @override
  void dispose() {
    // TODO: implement dispose
    // notification_timer.cancel();

    super.dispose();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      det = details();
    });
    if (mounted)
      setState(() {
        det = details();
      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // blaanceofuser=balance();
    det = details();
    // notification_timer=Timer.periodic(Duration(seconds: 10), (_) => det=details());
    telegram();
    get_playerd();
  }

  var p_id;
  get_playerd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? player_id = prefs.getString('player_ID');

    setState(() {
      p_id = player_id;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      appBar: AppBar(
        backgroundColor: Color(0xFF07031E),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          },
        ),
        title: InkWell(
          onTap: () {
            print(p_id);
          },
          child: Text("My Wallet",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height / 1.3,
                  width: width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      height: height / 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height / 40,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: height / 13,
                                  decoration: BoxDecoration(
                                    color: Color(0xfffffcdb),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        child: Text("Available Balance",
                                            style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16)),
                                      ),
                                      balance_ammount != null
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  'Images/t.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      balance_ammount
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18)),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Image.asset(
                                                  'Images/t.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text("..".toString(),
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18)),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                transaction_history()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0), // Set the border radius
                                      border: Border.all(
                                        color: Colors.blue, // Set the border color
                                        width: 2.0, // Set the border width
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("View Transaction History",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Center(
                          //   child: Row(
                          //     mainAxisAlignment:MainAxisAlignment.center,
                          //     children: [
                          //       Expanded(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: InkWell(
                          //             onTap: (){
                          //               Navigator.push(context, MaterialPageRoute(builder: (_)=>transaction_history()));
                          //
                          //             },
                          //             child: Container(
                          //
                          //               child: Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   Row(children: [
                          //                   Text("View Transaction History",
                          //                       style: GoogleFonts.lato(
                          //                           color: Colors.grey,
                          //                           fontWeight: FontWeight.w500,
                          //                           fontSize: 14)),
                          //                   Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                          //
                          //                 ],),
                          //                  ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //
                          //     ],
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.moneyBill,
                                            color: Colors.green,
                                          ),
                                          Text(" Winning Balance",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          // Icon(
                                          //   Icons.info,
                                          //   color: Colors.grey,
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'Images/t.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                              win_earn != null
                                                  ? " " + win_earn.toString()
                                                  : "..",
                                              style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => withdraw()));
                                  },
                                  child: Container(
                                    height: height / 20,
                                    width: width / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.transfer_within_a_station,
                                            color: Colors.white,
                                          ), onPressed: () {  },
                                        ),
                                        Text(
                                          "Withdraw",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.moneyBill,
                                            color: Colors.blue,
                                          ),
                                          Text(" Deposit Cash",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          // Icon(
                                          //   Icons.info,
                                          //   color: Colors.grey,
                                          // ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset(
                                      //       'Images/t.png',
                                      //       height: 30,
                                      //       width: 30,
                                      //     ),
                                      //     Text(
                                      //         deposite_earn != null
                                      //             ? " " +
                                      //                 deposite_earn.toString()
                                      //             : "...",
                                      //         style: GoogleFonts.lato(
                                      //             color: Colors.black,
                                      //             fontWeight: FontWeight.w700,
                                      //             fontSize: 18)),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => deposite()));
                                  },
                                  child: Container(
                                    height: height / 20,
                                    width: width / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle,
                                            color: Colors.white,
                                          ), onPressed: () {  },
                                        ),
                                        Text(
                                          "Add Coins",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.peopleArrows,
                                            color: Colors.green,
                                          ),
                                          Expanded(
                                            child: Text(
                                                "  Refer ( Earning till Now )",
                                                style: GoogleFonts.lato(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
                                          ),
                                          // Icon(
                                          //   Icons.info,
                                          //   color: Colors.grey,
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'Images/t.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                              refere_earn != null
                                                  ? " " + refere_earn.toString()
                                                  : "..",
                                              style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => refere()));
                                  },
                                  child: Container(
                                    height: height / 20,
                                    width: width / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.deepPurpleAccent),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ), onPressed: () {  },
                                        ),
                                        Text(
                                          "Refer&Earn",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),








                      //TO DO Transfer

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.moneyBill,
                                            color: Colors.blue,
                                          ),
                                          Text(" Wining To Total Blance",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                          // Icon(
                                          //   Icons.info,
                                          //   color: Colors.grey,
                                          // ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset(
                                      //       'Images/t.png',
                                      //       height: 30,
                                      //       width: 30,
                                      //     ),
                                      //     Text(
                                      //         deposite_earn != null
                                      //             ? " " +
                                      //                 deposite_earn.toString()
                                      //             : "...",
                                      //         style: GoogleFonts.lato(
                                      //             color: Colors.black,
                                      //             fontWeight: FontWeight.w700,
                                      //             fontSize: 18)),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => TransfareBlance()));
                                  },
                                  child: Container(
                                    height: height / 20,
                                    width: width / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ), onPressed: () {  },
                                        ),
                                        Text(
                                          "Transfar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),








                          Divider(
                            color: Colors.black,
                          ),

                          // Container(
                          //     constraints: BoxConstraints(),
                          //     child: FutureBuilder(
                          //         future: det,
                          //         builder: (_, AsyncSnapshot snapshot) {
                          //           switch (snapshot.connectionState) {
                          //             case ConnectionState.waiting:
                          //               return SizedBox(
                          //                 width:
                          //                     MediaQuery.of(context).size.width,
                          //                 height: MediaQuery.of(context)
                          //                         .size
                          //                         .height /
                          //                     5,
                          //                 child: SpinKitThreeInOut(
                          //                   color: Colors.white,
                          //                   size: 20,
                          //                 ),
                          //               );
                          //             default:
                          //               if (snapshot.hasError) {
                          //                 Text('Error: ${snapshot.error}');
                          //               } else {
                          //                 return snapshot.hasData
                          //                     ? ListView.builder(
                          //                         shrinkWrap: true,
                          //                         itemCount: snapshot
                          //                             .data['tutorial'].length,
                          //                         itemBuilder: (_, index) {
                          //                           return Column(
                          //                             children: [
                          //                               Container(
                          //                                 child: Row(
                          //                                   mainAxisAlignment:
                          //                                       MainAxisAlignment
                          //                                           .spaceBetween,
                          //                                   children: [
                          //                                     Expanded(
                          //                                       child: Padding(
                          //                                         padding:
                          //                                             const EdgeInsets
                          //                                                     .all(
                          //                                                 8.0),
                          //                                         child: Column(
                          //                                           crossAxisAlignment:
                          //                                               CrossAxisAlignment
                          //                                                   .start,
                          //                                           children: [
                          //                                             Row(
                          //                                               children: [
                          //                                                 Flexible(
                          //                                                     child: Icon(
                          //                                                   Icons.play_circle_fill_outlined,
                          //                                                   color:
                          //                                                       Colors.redAccent,
                          //                                                 )),
                          //                                                 Flexible(
                          //                                                   child:
                          //                                                       Text(snapshot.data['tutorial'][index]['english_title'], style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14)),
                          //                                                 ),
                          //                                               ],
                          //                                             ),
                          //                                             Text(
                          //                                                 snapshot.data['tutorial'][index]
                          //                                                     [
                          //                                                     'bangla_title'],
                          //                                                 style: GoogleFonts.lato(
                          //                                                     color: Colors.black,
                          //                                                     fontWeight: FontWeight.w600,
                          //                                                     fontSize: 14)),
                          //                                           ],
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                     Expanded(
                          //                                       child: Padding(
                          //                                           padding: const EdgeInsets
                          //                                                   .only(
                          //                                               left:
                          //                                                   8.0,
                          //                                               right:
                          //                                                   8,
                          //                                               bottom:
                          //                                                   20),
                          //                                           child:
                          //                                               ElevatedButton
                          //                                                   .icon(
                          //                                             onPressed:
                          //                                                 () async {
                          //                                               var url =
                          //                                                   snapshot.data['tutorial'][index]['links'];
                          //                                               if (await canLaunch(
                          //                                                   url))
                          //                                                 await launch(
                          //                                                     url);
                          //                                               else
                          //                                                 // can't launch url, there is some error
                          //                                                 throw "Could not launch $url";
                          //                                             },
                          //                                             icon:
                          //                           Icon(
                          //                           Icons
                          //                               .play_circle_fill_outlined,
                          //                           color:
                          //                           Colors.redAccent,
                          //                           ),
                          //                                             label: Flexible(
                          //                                                 child: Text(
                          //                                               "ভিডিও দেখুন",
                          //                                               style:
                          //                                                   TextStyle(
                          //                                                 color:
                          //                                                     Colors.white,
                          //                                                 fontWeight:
                          //                                                     FontWeight.bold,
                          //                                               ),
                          //                                             )),
                          //                                             style:
                          //                                                 ButtonStyle(
                          //                                               backgroundColor:
                          //                                                   MaterialStateProperty.all(Colors.blue),
                          //                                             ),
                          //                                           )),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           );
                          //                         })
                          //                     : Text('No data');
                          //               }
                          //           }
                          //           return CircularProgressIndicator();
                          //         })),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('কয়েন অ্যাড না হলে এখানে টেক্সট করুন',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),

                          ElevatedButton.icon(
                            onPressed: () async {
                              var url = telegram_link;
                              if (await canLaunch(url))
                                await launch(url);
                              else
                                // can't launch url, there is some error
                                throw "Could not launch $url";
                            },
                            icon: Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Contact Us",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                          ),



                          // ElevatedButton(onPressed: ()=> Get.toNamed(mapExam),
                          //     child: Text("Map",style: TextStyle(color: Colors.yellow),))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
