import 'dart:ui';

import 'package:art_market/Orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'database_service.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  Future<List<Orders>>? ordersList;
  List<Orders>? retrievedOrdersList;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        //   scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
          body: SafeArea(
              child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 25.0, 15.0, 0),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'My Profile',
                    style:
                        TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 220.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 223, 220, 220),
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Color(0xffEEF7F0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 25.0,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 15.0, 25.0, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                  size: 30.0,
                                )),
                            radius: 22.0,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 45.0,
                        backgroundColor: Color(0xffC9E4D0),
                        child: Text(
                          'AS',
                          style: const TextStyle(
                              color: Color(0xff1B3823),
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'AJAO SEMILOORE',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Recent Orders',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 85.0,
                  decoration: BoxDecoration(
                      color: Color(0xffEEF7F0),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
                          child: overlapped()),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '21, Thur 10.00',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600]),
                            ),
                            Text(
                              '\$38.50',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
                        child: Container(
                          height: 35.0,
                          decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Pending',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            const Center(
              child: SpinKitSquareCircle(
                color: Color(0xff2E5F3B),
                size: 100.0,
              ),
            )
        ],
      ))),
    );
  }

  Widget overlapped() {
    final overlap = 25.0;
    final items = [
      CircleAvatar(
        child: Text('1'),
        backgroundColor: Colors.white,
        radius: 27.0,
      ),
      CircleAvatar(
        child: Text('2'),
        backgroundColor: Colors.yellow,
        radius: 27.0,
      ),
      CircleAvatar(
          child: Text('3'), backgroundColor: Colors.green, radius: 27.0),
    ];

    List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });

    return Stack(children: stackLayers);
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });

    ordersList = databaseService.retrieveOrders();
    retrievedOrdersList = await databaseService.retrieveOrders();

    print(retrievedOrdersList!.first.orderDate);

    setState(() {
      _loading = false;
    });
  }
}
