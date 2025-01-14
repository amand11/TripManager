import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmanager/Home/additem.dart';
import 'package:tripmanager/Home/item3.dart';
import 'package:tripmanager/addexpense.dart';
import 'package:tripmanager/classes/otherexpense.dart';
import 'package:tripmanager/classes/personal.dart';
import 'package:tripmanager/createotherpdf.dart';
import 'package:tripmanager/createsheet.dart';
import 'package:tripmanager/homepage.dart';
import 'package:tripmanager/item2.dart';
import 'package:tripmanager/createpdf.dart';
// import 'package:tripmanager/Home/item3.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'classes/tripclass.dart';
import 'classes/itemclass.dart';
import 'package:tripmanager/Home/item.dart';
import 'package:tripmanager/editTrip.dart';
import 'classes/travelexpense.dart';
import 'package:flutter/scheduler.dart';
import 'package:currency_picker/currency_picker.dart';

DateFormat format = new DateFormat("ddMMMMyyyy hh:mm");

Future<String> gettotalinstring(int id) async {
  List<Map> l1 = await GetTotal(id);
  List<Map> l2 = await GetOtherTotal(id);
  Map<String, double> m = {};

  for (int i = 0; l1 != null && i < l1.length; i++) {
    if (m.containsKey(l1[i]['currency']) == true) {
      m[l1[i]['currency']] += l1[i]['am'];
    } else {
      m[l1[i]['currency']] = l1[i]['am'];
    }
  }
  for (int i = 0; l2 != null && i < l2.length; i++) {
    if (m.containsKey(l2[i]['currency']) == true) {
      m[l2[i]['currency']] += l2[i]['am'];
    } else {
      m[l2[i]['currency']] = l2[i]['am'];
    }
  }
  String out = '';
  m.forEach((key, value) {
    out = out + key + " " + value.toString() + " + ";
  });
  if (out.length != 0) {
    out = out.substring(0, out.length - 2);
  } else {
    out = ' INR 0.0';
  }
  print(out);
  return out;
}

double sum = 0;

bool _value = false;

// String getCurrency() {
//   print(Platform.localeName);
//   var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
//   return format.currencySymbol;
// }

class Temp extends StatefulWidget {
  Temp(
    this.trip_id,
  );
  final int trip_id;

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  callback1() {
    setState(() {
      _tripinstance = getTripById(this.widget.trip_id);
      ex2 = gettotalinstring(this.widget.trip_id);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  callback2() {
    setState(() {});
  }

  Future<String> ex2;
  double expense = 2200;
  String tripName = 'IIT Bombay';
  String date = '09/03/2021';
  String lastModified = 'NA';

  List<bool> isSelected = [true, false, false, false];
  bool isTravelEmpty = true;
  bool isOtherEmpty = true;
  bool isPersonalEmpty = true;
  Future<tripclass> _tripinstance;
  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _tripinstance = getTripById(this.widget.trip_id);
    ex2 = gettotalinstring(this.widget.trip_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // CurrencyUtils.currencyToEmoji(Currency(code: 'INR',));
    // print(DateFormat('yyyy-MM-dd – hh:mm').parse(lastModified));
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder<tripclass>(
                future: _tripinstance,
                builder:
                    (BuildContext context, AsyncSnapshot<tripclass> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // print(ex2);
                    // print('sdfasg');
                    expense = snapshot.data.total;
                    tripName = snapshot.data.title;
                    date = snapshot.data.start_date;
                    lastModified = snapshot.data.last_modified;
                    return Container(
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.blue, Colors.purple])),
                      // height: 200,
                      // color: Colors.,
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width * .7,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    child: FutureBuilder<String>(
                                      future: ex2,
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              snap.data,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            'INR 0.0',
                                            style: TextStyle(
                                                fontSize: 30,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, bottom: 10),
                                      child: Container(
                                        // width: 200,
                                        child: Text(
                                          tripName,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 30),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      // width: ,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(date),
                                          Text(
                                            '(Modified: ' +
                                                format
                                                    .format(DateFormat(
                                                            'yyyy-MM-dd – hh:mm')
                                                        .parse(lastModified))
                                                    .toString() +
                                                ')',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Column(
                              children: [
                                Container(),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(2.0,
                                            2.0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  // color: Colors.red,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (ct) {
                                              return editTrip(
                                                  callback1, snapshot.data);
                                            });
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(2.0,
                                            2.0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  // color: Colors.red,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (ct) {
                                            return createpopup(widget.trip_id);
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.blue, Colors.purple])),
                  // color: Colors.lightGreen,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                if (isSelected[0] == true) {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {},
                                    child: Text(
                                      'All',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.purple, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      setState(() {
                                        isSelected[0] = true;
                                        isSelected[1] = false;
                                        isSelected[2] = false;
                                        isSelected[3] = false;
                                      });
                                    },
                                    child: Text(
                                      'All',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  );
                                }
                              }()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                if (isSelected[1] == true) {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {},
                                    child: Text(
                                      'Travel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.purple, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      setState(() {
                                        isSelected[1] = true;
                                        isSelected[0] = false;
                                        isSelected[2] = false;
                                        isSelected[3] = false;
                                      });
                                    },
                                    child: Text(
                                      'Travel',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  );
                                }
                              }()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                if (isSelected[2] == true) {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {},
                                    child: Text(
                                      'Others',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.purple, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      setState(() {
                                        isSelected[2] = true;
                                        isSelected[1] = false;
                                        isSelected[0] = false;
                                        isSelected[3] = false;
                                      });
                                    },
                                    child: Text(
                                      'Others',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  );
                                }
                              }()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                if (isSelected[3] == true) {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {},
                                    child: Text(
                                      'Personal',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return RaisedButton(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.purple, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      setState(() {
                                        isSelected[3] = true;
                                        isSelected[1] = false;
                                        isSelected[2] = false;
                                        isSelected[0] = false;
                                      });
                                    },
                                    child: Text(
                                      'Personal',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  );
                                }
                              }()),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          // height: 200,
                          // color: Colors.purple,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                            // border: Border.all(
                            //   width: 3,
                            //   // color: Colors.green,
                            //   style: BorderStyle.solid,
                            // ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(),
                                (() {
                                  if (isSelected[0] == true) {
                                    return Column(
                                      children: [
                                        Container(),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElements(
                                                    this.widget.trip_id)),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                isTravelEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        print(snapshot
                                                            .data[index]);
                                                        // return Text('Hi');
                                                        sum = sum +
                                                            snapshot.data[index]
                                                                ["fare"];
                                                        return new Item(
                                                          snapshot.data[index]
                                                              ["tripid"],
                                                          snapshot.data[index]
                                                              ["serial_number"],
                                                          snapshot.data[index]
                                                              ["dep_time"],
                                                          snapshot.data[index]
                                                              ["dep_date"],
                                                          snapshot.data[index]
                                                              ["dep_station"],
                                                          snapshot.data[index]
                                                              ["arr_time"],
                                                          snapshot.data[index]
                                                              ["arr_date"],
                                                          snapshot.data[index]
                                                              ["arr_station"],
                                                          snapshot.data[index]
                                                              ["mot"],
                                                          snapshot.data[index]
                                                              ["km"],
                                                          snapshot.data[index]
                                                              ["fare"],
                                                          snapshot.data[index]
                                                              ["pnr"],
                                                          snapshot.data[index]
                                                              ["remarks"],
                                                          snapshot.data[index][
                                                              "ticket_address"],
                                                          snapshot.data[index][
                                                              "receipt_location"],
                                                          snapshot.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),
                                                    // Container(
                                                    //   child: Image.network(
                                                    //     'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                    //     height: 30,
                                                    //     width: 30,
                                                    //   ),
                                                    // ),
                                                  ],
                                                );
                                              } else {
                                                isTravelEmpty = true;
                                                return Container();
                                              }
                                            }),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElementsPersonalExpense(
                                                    widget.trip_id)),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                // print("Hi in");
                                                // print(isSelected);
                                                isPersonalEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        print(snapshot
                                                            .data[index]);
                                                        // return Item2(
                                                        //     1,
                                                        //     0,
                                                        //     'Food',
                                                        //     'Stay at IIT Bombay hostel',
                                                        //     1000,
                                                        //     'sdfgasdg',
                                                        //     'GMail',
                                                        //     'NA',
                                                        //     '21-01-21',
                                                        //     callback1);
                                                        // print(
                                                        //     snapshot.data);
                                                        return Item3(
                                                          snapshot.data[index]
                                                              ["tripid"],
                                                          snapshot.data[index]
                                                              ["serial_number"],
                                                          snapshot.data[index]
                                                              ["type"],
                                                          snapshot.data[index]
                                                              ["details"],
                                                          snapshot.data[index]
                                                              ["amount_paid"],
                                                          snapshot.data[index]
                                                              ["date"],
                                                          snapshot.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),
                                                    // Container(
                                                    //   child: Image.asset(
                                                    //       'assets/tick.png'),

                                                    //   // child: Image.network(
                                                    //   //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                    //   height: 30,
                                                    //   width: 30,
                                                    // ),
                                                    // Container(
                                                    //   height: 50,
                                                    // ),
                                                  ],
                                                );
                                              } else {
                                                print("hi");
                                                isPersonalEmpty = true;
                                                return Container();
                                              }
                                            }),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElementsOtherExpense(
                                                    widget.trip_id)),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                // print("Hi in");

                                                // print(isSelected);
                                                isOtherEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        sum = sum +
                                                            snapshot.data[index]
                                                                ["amount_paid"];
                                                        print(snapshot
                                                            .data[index]);
                                                        // return Item2(
                                                        //     1,
                                                        //     0,
                                                        //     'Food',
                                                        //     'Stay at IIT Bombay hostel',
                                                        //     1000,
                                                        //     'sdfgasdg',
                                                        //     'GMail',
                                                        //     'NA',
                                                        //     '21-01-21',
                                                        //     callback1);
                                                        print(snapshot.data);
                                                        return new Item2(
                                                          snapshot.data[index]
                                                              ["tripid"],
                                                          snapshot.data[index]
                                                              ["serial_number"],
                                                          snapshot.data[index]
                                                              ["type"],
                                                          snapshot.data[index]
                                                              ["details"],
                                                          snapshot.data[index]
                                                              ["amount_paid"],
                                                          snapshot.data[index][
                                                              "receipt_details"],
                                                          snapshot.data[index][
                                                              "receipt_location"],
                                                          snapshot.data[index][
                                                              "receipt_address"],
                                                          snapshot.data[index]
                                                              ["date"],
                                                          snapshot.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),

                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Image.asset(
                                                              'assets/tick.png'),
                                                          // child: Image.network(
                                                          //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        Container(
                                                          height: 50,
                                                        )
                                                      ],
                                                    ),
                                                    // if(snapshot.connectionState==ConnectionState.active)
                                                  ],
                                                );
                                              } else if (isTravelEmpty ==
                                                      true &&
                                                  isPersonalEmpty == true) {
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'Welcome! You have created a new Trip.',
                                                        style: TextStyle(
                                                            fontSize: 40),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'Add an Expense to view here',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                print("hi");
                                                isOtherEmpty = true;
                                                return Column(
                                                  children: [
                                                    Container(
                                                      child: Image.asset(
                                                          'assets/tick.png'),

                                                      // child: Image.network(
                                                      //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                    )
                                                  ],
                                                );
                                              }
                                            }),
                                      ],
                                    );
                                  } else if (isSelected[1] == true) {
                                    return Column(
                                      children: [
                                        Container(),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElements(
                                                    this.widget.trip_id)),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snapshot) {
                                              print(snapshot.connectionState);
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                // isTravelEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        print(snapshot
                                                            .data[index]);
                                                        // return Text('Hi');
                                                        return new Item(
                                                          snapshot.data[index]
                                                              ["tripid"],
                                                          snapshot.data[index]
                                                              ["serial_number"],
                                                          snapshot.data[index]
                                                              ["dep_time"],
                                                          snapshot.data[index]
                                                              ["dep_date"],
                                                          snapshot.data[index]
                                                              ["dep_station"],
                                                          snapshot.data[index]
                                                              ["arr_time"],
                                                          snapshot.data[index]
                                                              ["arr_date"],
                                                          snapshot.data[index]
                                                              ["arr_station"],
                                                          snapshot.data[index]
                                                              ["mot"],
                                                          snapshot.data[index]
                                                              ["km"],
                                                          snapshot.data[index]
                                                              ["fare"],
                                                          snapshot.data[index]
                                                              ["pnr"],
                                                          snapshot.data[index]
                                                              ["remarks"],
                                                          snapshot.data[index][
                                                              "ticket_address"],
                                                          snapshot.data[index][
                                                              "receipt_location"],
                                                          snapshot.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Image.asset(
                                                              'assets/tick.png'),

                                                          // child: Image.network(
                                                          //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        Container(
                                                          height: 50,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                // isTravelEmpty = true;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'Add a Travel expense to view here',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }),
                                      ],
                                    );
                                  } else if (isSelected[2] == true) {
                                    return Column(
                                      children: [
                                        Container(),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElementsOtherExpense(
                                                    widget.trip_id)),
                                            builder: (BuildContext cont,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snap) {
                                              if (snap.hasData &&
                                                  snap.connectionState ==
                                                      ConnectionState.done) {
                                                print("Hi in dsfdsaf");
                                                print(snap.data);
                                                // print(isSelected);
                                                // isOtherEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snap.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        print("temp is luckly");
                                                        print(snap.data[index]);
                                                        print(
                                                            "temp is unlucky");
                                                        return new Item2(
                                                          snap.data[index]
                                                              ["tripid"],
                                                          snap.data[index]
                                                              ["serial_number"],
                                                          snap.data[index]
                                                              ["type"],
                                                          snap.data[index]
                                                              ["details"],
                                                          snap.data[index]
                                                              ["amount_paid"],
                                                          snap.data[index][
                                                              "receipt_details"],
                                                          snap.data[index][
                                                              "receipt_location"],
                                                          snap.data[index][
                                                              "receipt_address"],
                                                          snap.data[index]
                                                              ["date"],
                                                          snap.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'assets/tick.png'),

                                                      // child: Image.network(
                                                      //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                print("hi");
                                                // isOtherEmpty = true;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'Add a Non Travel expense to view here',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Container(),
                                        StreamBuilder<
                                                List<Map<dynamic, dynamic>>>(
                                            stream: Stream.fromFuture(
                                                getElementsPersonalExpense(
                                                    widget.trip_id)),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<dynamic,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                // print("Hi in");
                                                // print(isSelected);
                                                isPersonalEmpty = false;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        print(snapshot
                                                            .data[index]);
                                                        // return Item2(
                                                        //     1,
                                                        //     0,
                                                        //     'Food',
                                                        //     'Stay at IIT Bombay hostel',
                                                        //     1000,
                                                        //     'sdfgasdg',
                                                        //     'GMail',
                                                        //     'NA',
                                                        //     '21-01-21',
                                                        //     callback1);
                                                        // print(
                                                        //     snapshot.data);
                                                        return Item3(
                                                          snapshot.data[index]
                                                              ["tripid"],
                                                          snapshot.data[index]
                                                              ["serial_number"],
                                                          snapshot.data[index]
                                                              ["type"],
                                                          snapshot.data[index]
                                                              ["details"],
                                                          snapshot.data[index]
                                                              ["amount_paid"],
                                                          snapshot.data[index]
                                                              ["date"],
                                                          snapshot.data[index]
                                                              ["currency"],
                                                          callback1,
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'assets/tick.png'),

                                                      // child: Image.network(
                                                      //   'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimage.flaticon.com%2Ficons%2Fpng%2F512%2F339%2F339821.png&f=1&nofb=1',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                print("hi");
                                                isPersonalEmpty = true;
                                                return Column(
                                                  children: [
                                                    Container(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'Add a Personal expense to view here',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }),
                                        Container(),
                                      ],
                                    );
                                  }
                                }()),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items:[
        //     BottomNavigationBarItem(icon: Icons.back)
        //   ]
        // ),
        floatingActionButton:
            button(this.widget.trip_id, callback1, isSelected));
  }
}

class button extends StatefulWidget {
  button(this.trip_id, this.callback1, this.isSelected);
  final int trip_id;
  Function() callback1;
  List<bool> isSelected;
  // bool isfabactive = false;
  @override
  _buttonState createState() => _buttonState();
}

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        // padding: const EdgeInsets.only(top: 4.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (ct) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyHomePage(this.widget.trip_id,
                        this.widget.callback1, this.widget.isSelected),
                  );
                });
          },
          heroTag: "btn2",
          elevation: 15,
          splashColor: Colors.blue,
          backgroundColor: Colors.purple,
          icon: Icon(Icons.addchart_rounded),
          label: Text("Add Expense"),
        ),
      ),
    );
  }
}

class createpopup extends StatefulWidget {
  createpopup(this.tripid);
  final int tripid;
  @override
  _createpopupState createState() => _createpopupState();
}

class _createpopupState extends State<createpopup> {
  List<bool> buttons = [false, true];
  List<bool> buttons2 = [true, false];
  bool iscreatepdfcompleted = false;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(8, 10, 8, 20),
      margin: EdgeInsets.all(30.0),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  // width: 0,
                  // ),

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: (() {
                      if (buttons[1] == true) {
                        return RaisedButton(
                          elevation: 5,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {},
                          child: Text(
                            'Simple',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return RaisedButton(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.redAccent, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            setState(() {
                              buttons[1] = true;
                              buttons[0] = false;
                            });
                          },
                          child: Text(
                            'Simple',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        );
                      }
                    }()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (() {
                      if (buttons[0] == true) {
                        return RaisedButton(
                          elevation: 5,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {},
                          child: Text(
                            'IIT Ropar Form',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return RaisedButton(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.redAccent, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            setState(() {
                              buttons[0] = true;
                              buttons[1] = false;
                            });
                          },
                          child: Text(
                            'IIT Ropar Form',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        );
                      }
                    }()),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (() {
                    if (buttons2[0] == false) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Icons.radio_button_off),
                                onPressed: () {
                                  setState(() {
                                    buttons2[0] = true;
                                    buttons2[1] = false;
                                  });
                                }),
                          ),
                          Container(
                            child: Text('PDF'),
                          )
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Icons.radio_button_checked),
                                onPressed: () {
                                  setState(() {
                                    // buttons2[1] = true;
                                    // buttons2[0] = false;
                                  });
                                }),
                          ),
                          Container(
                            child: Text('PDF'),
                          )
                        ],
                      );
                    }
                  }()),
                  (() {
                    if (buttons2[1] == false) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Icons.radio_button_off),
                                onPressed: () {
                                  setState(() {
                                    buttons2[1] = true;
                                    buttons2[0] = false;
                                  });
                                }),
                          ),
                          Container(
                            child: Text('Excel(.xlsx)'),
                          )
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Icons.radio_button_checked),
                                onPressed: () {
                                  setState(() {
                                    // buttons2[1] = true;
                                    // buttons2[0] = false;
                                  });
                                }),
                          ),
                          Container(
                            child: Text('Excel(.xlsx)'),
                          )
                        ],
                      );
                    }
                  }())
                ],
              ),
              (() {
                if (buttons[0] == true &&
                    buttons2[0] == true &&
                    iscreatepdfcompleted == true) {
                  return Container(
                    child: Text('This will take some time. Please wait.'),
                  );
                } else {
                  return Container();
                }
              }()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (() {
                  if (iscreatepdfcompleted == false) {
                    return RaisedButton(
                      onPressed: () async {
                        setState(() {
                          iscreatepdfcompleted = true;
                        });
                        Future<bool> tt;
                        print("hihihaha");
                        print(tt);
                        if (buttons[0] == true && buttons2[0] == true) {
                          await createPDF(widget.tripid);
                        } else if (buttons[1] == true && buttons2[0] == true) {
                          await createotherPDF(widget.tripid);
                        } else if (buttons2[1] == true) {
                          await generateExcel(widget.tripid);
                        }
                        print("huihuihui");
                        print(tt);
                        // if()
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Generate & Download',
                        style: TextStyle(color: Colors.white),
                      ),
                      elevation: 5,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.redAccent, width: 2),
                          borderRadius: BorderRadius.circular(5)),
                    );
                  } else {
                    return RaisedButton(
                      onPressed: () {},
                      child: Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(),
                      ),
                      disabledColor: Colors.grey,
                    );
                  }
                }()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class progress extends StatefulWidget {
  @override
  _progressState createState() => _progressState();
}

class _progressState extends State<progress> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
