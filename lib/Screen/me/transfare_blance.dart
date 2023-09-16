import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../Appurl/Appurl.dart';
import '../MainHome/main_home.dart';

class TransfareBlance extends StatefulWidget {
  @override
  _TransfareBlanceState createState() => _TransfareBlanceState();
}

class _TransfareBlanceState extends State<TransfareBlance> {
  final _formKey = GlobalKey<FormState>();
  bool paytm = false;

  TextEditingController mobile = TextEditingController();
  TextEditingController amount = TextEditingController();
  bool isrequsted = false;
  var balance_ammount;
  Future? blaanceofuser;
  var am='0';
  Future withdraw(String wallettype, String phone, String Ammount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.withdraw),
    );
    request.fields.addAll({
      'wallet_type': wallettype,
      'phone_number': phone,
      'withdraw_money': Ammount,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data['status_code']);
          print('response.body ' + data.toString());
          if (data['status_code'] == 200) {
            setState(() {
              isrequsted = false;
            });
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
            Fluttertoast.showToast(
                msg: "Withdraw Request Placed Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            setState(() {
              isrequsted = false;
            });
            print("Fail! ");
            Fluttertoast.showToast(
                msg: "Insufficient Balance",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            return response.body;
          }
        }
      });
    });
  }


  var player_id;


  Future balance() async {
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
      print(userData1['balance']);
      setState(() {
        balance_ammount = userData1['balance'];
        win = userData1['winingBalance'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  var win;

  bool ischecked = false;
  bool rocket = false;
  bool Nagad = false;
  var selected_country;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blaanceofuser = balance();
    //func();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
        title: Text("Transfare",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 20,
            ),
            Text('Available Amount',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            Row(                                                                      mainAxisAlignment:MainAxisAlignment.center,

              children: [
                Image.asset('Images/t.png',height: 25,width: 25,),

                Text(' ' + win.toString(),
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),

            SizedBox(
              height: height / 20,
            ),
















            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        onChanged: (v){
                          setState(() {
                            am=v;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                        validator: (value) =>
                        value!.isEmpty ? "Field Can't be empty" : null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                            ),
                            hintText: "How much coin you want to transfare ?",
                            hintStyle: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),









            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Row(
                  children: [
                    Text(

                        "** Amount   "
                        ,
                        style: GoogleFonts.lato(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),Text(

                        am
                        ,
                        style: GoogleFonts.lato(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),Text(

                        ' =  '
                        ,
                        style: GoogleFonts.lato(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),Text(

                        am                              ,
                        style: GoogleFonts.lato(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ],
                ),  Image.asset('Images/t.png',height: 30,width: 30,),
              ],
            ),
            Text('*Minimum Transfare Ammount 100',
                style: GoogleFonts.lato(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(
              height: height / 20,
            ),
            isrequsted == false
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isrequsted = true;
                      });
                      if (int.parse(amount.text) >= 100) {
                        setState(() {
                          isrequsted = true;
                        });
                        if (int.parse(amount.text) <= win) {
                          withdraw(
                              selected_country, mobile.text, amount.text);
                        } else {
                          setState(() {
                            isrequsted = false;
                          });
                          Fluttertoast.showToast(
                              msg:
                              "Withdraw should exceed available ammount",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else {
                        setState(() {
                          isrequsted = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Transfare should be minimum 100 coins",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                      print(selected_country);
                    }
                  },
                  child: Container(
                    height: height / 20,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text("Transfare".toUpperCase(),
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                    ),
                  ),
                ),
              ),
            )
                : Center(
              child: SpinKitThreeInOut(
                color: Colors.orange,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
