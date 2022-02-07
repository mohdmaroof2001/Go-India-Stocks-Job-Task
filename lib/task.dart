// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobtask2/all_data.dart';
import 'package:jiffy/jiffy.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<Data> userData = [];
  List<Data> nameArrForDisplay = [];
  bool all = true;
  bool buyy = false;
  bool sell = false;
  final price = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    dataSource("Bulk_Deal");
    _controller = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          if (_controller.index == 0) {
            dataSource("Bulk_Deal");
          } else if (_controller.index == 1) {
            dataSource("Block_Deal");
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: nameArrForDisplay.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Colors.white,
                color: Colors.pink,
              ),
            )
          : TabBarView(
              controller: _controller,
              children: [
                dataShow(),
                dataShow(),
              ],
            ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      title: Text("Go India Stocks", style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: TabBar(
        indicatorColor: Colors.red,
        controller: _controller,
        tabs: [
          Tab(
              child: Text('Bulk Deal',
                  style: TextStyle(color: Colors.blue, fontSize: 18))),
          Tab(
              child: Text('Block Deal',
                  style: TextStyle(color: Colors.blue, fontSize: 18)))
        ],
      ),
    );
  }

  dataShow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.teal, Colors.blue),
                    ),
                    // ElevatedButton.styleFrom(primary: Colors.teal[300]),
                    onPressed: () {
                      if (_controller.index == 0) {
                        setState(() {
                          all = true;
                          buyy = false;
                          sell = false;
                        });
                      } else if (_controller.index == 1) {
                        setState(() {
                          all = true;
                          buyy = false;
                          sell = false;
                        });
                      }
                    },
                    child: Text("All"),
                  )),
              SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.green, Colors.blue),
                    ),
                    onPressed: () {
                      if (_controller.index == 0) {
                        setState(() {
                          all = false;
                          buyy = true;
                          sell = false;
                        });
                      } else if (_controller.index == 1) {
                        setState(() {
                          all = false;
                          buyy = true;
                          sell = false;
                        });
                      }
                    },
                    child: Text("Buy"),
                  )),
              SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.red, Colors.blue),
                    ),
                    onPressed: () {
                      if (_controller.index == 0) {
                        setState(() {
                          all = false;
                          buyy = false;
                          sell = true;
                        });
                      } else if (_controller.index == 1) {
                        setState(() {
                          all = false;
                          buyy = false;
                          sell = true;
                        });
                      }
                    },
                    child: Text("Sell"),
                  )),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // searchBar(),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemBuilder: (context, indexNo) {
                    return indexNo == 0
                        ? searchBar()
                        : Column(
                            children: [
                              if (all) ...[
                                showAll(context, indexNo - 1),
                              ] else if (buyy) ...[
                                showBuy(context, indexNo - 1)
                              ] else if (sell) ...[
                                showSell(context, indexNo - 1)
                              ],
                              // SizedBox(
                              //   height: 5,
                              // )
                            ],
                          );
                  },
                  itemCount: nameArrForDisplay.length + 1),
            ),
          ),
        ],
      ),
    );
  }

  Container searchBar() {
    return Container(
      height: 50,
      child: Column(
        children: [
          TextField(
              decoration: InputDecoration(
                  hintText: "Search .. ",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(new Radius.circular(30.0)),
                  ),
                  contentPadding: EdgeInsets.all(10)),
              onChanged: (text) {
                text = text.toLowerCase();
                nameArrForDisplay = userData
                    .where((tName) {
                      var tNameTitle = tName.clientName!.toLowerCase();
                      return tNameTitle.contains(text);
                    })
                    .toSet()
                    .toList();
                setState(() {});
              }),
          //
        ],
      ),
    );
  }

  Container showAll(BuildContext context, int indexNo) {
    var a = Jiffy(nameArrForDisplay[indexNo].dealDate!).format('dd-MMM-yyyy');
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: -5,
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              nameArrForDisplay[indexNo].dealType == "BUY"
                  ? Container(
                      width: 5,
                      height: MediaQuery.of(context).size.height - 671,
                      color: Colors.green,
                    )
                  : Container(
                      width: 5,
                      height: MediaQuery.of(context).size.height - 671,
                      color: Colors.red,
                    ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameArrForDisplay[indexNo].clientName!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        nameArrForDisplay[indexNo].dealType == "BUY"
                            ? Text(
                                "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "@ Rs ${nameArrForDisplay[indexNo].tradePrice}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Value Rs ${nameArrForDisplay[indexNo].value} Cr",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 331,
                  child: Text(
                    a,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ));
  }

  Container showBuy(BuildContext context, int indexNo) {
    var a = Jiffy(nameArrForDisplay[indexNo].dealDate!).format('dd-MMM-yyyy');
    return nameArrForDisplay[indexNo].dealType == "BUY"
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  spreadRadius: -5,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nameArrForDisplay[indexNo].dealType == "BUY"
                      ? Container(
                          width: 5,
                          height: MediaQuery.of(context).size.height - 671,
                          color: Colors.green,
                        )
                      : Container(
                          width: 5,
                          height: MediaQuery.of(context).size.height - 671,
                          color: Colors.red,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameArrForDisplay[indexNo].clientName!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            nameArrForDisplay[indexNo].dealType == "BUY"
                                ? Text(
                                    "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "@ Rs ${nameArrForDisplay[indexNo].tradePrice}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Value Rs ${nameArrForDisplay[indexNo].value} Cr",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 331,
                      child: Text(
                        a,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          )
        : buy();
  }

  Container showSell(BuildContext context, int indexNo) {
    var a = Jiffy(nameArrForDisplay[indexNo].dealDate!).format('dd-MMM-yyyy');
    return nameArrForDisplay[indexNo].dealType == "SELL"
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  spreadRadius: -5,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nameArrForDisplay[indexNo].dealType == "BUY"
                      ? Container(
                          width: 5,
                          height: MediaQuery.of(context).size.height - 671,
                          color: Colors.green,
                        )
                      : Container(
                          width: 5,
                          height: MediaQuery.of(context).size.height - 671,
                          color: Colors.red,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameArrForDisplay[indexNo].clientName!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            nameArrForDisplay[indexNo].dealType == "BUY"
                                ? Text(
                                    "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Bought ${price.format(int.parse(nameArrForDisplay[indexNo].quantity!))} shares",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "@ Rs ${nameArrForDisplay[indexNo].tradePrice}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Value Rs ${nameArrForDisplay[indexNo].value} Cr",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 331,
                      child: Text(
                        a,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          )
        : buy();
  }

  buy() {
    return Container();
  }

  dataSource(String catName) async {
    final uri = Uri.parse(
        'https://www.goindiastocks.com/api/service/GetBulkBlockDeal?fincode=100114&DealType=${catName}');
    var recp = await http.get(uri);
    // print(recp.body);
    var jsonResp = json.decode(recp.body);
    // print(jsonResp);
    var allData = AllData.fromJson(jsonResp);

    // for (var item in allData.data!) {
    //   if (item.dealType == "BUY") {
    //     buyData.add(item);
    //   } else {
    //     sellData.add(item);
    //   }
    // }
    // print(buyData.length);
    if (allData.data != null) {
      setState(() {
        userData = allData.data!;
        nameArrForDisplay = userData;
      });
    }
    // print(userData.length);
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith((getColor));
  }
}
