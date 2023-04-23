import 'package:art_market/address_page.dart';
import 'package:art_market/dashboard.dart';
import 'package:art_market/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ArtItems.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess(
      {Key? key,
      required this.title,
      required this.amount,
      required this.retrievedItemsList,
      required this.itemsList})
      : super(key: key);
  final String title;
  final String amount;
  final List<ArtItems>? retrievedItemsList;
  final Future<List<ArtItems>>? itemsList;

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  var dialogColor = Colors.green[700];
  var dialogColor2 = Colors.green[800];
  var dialogIcon = Icons.check;
  var orderTitle = '', orderDescription = '', orderBtn = '';
  bool orderSuccess = true;
  final DateFormat formatter = DateFormat('dd, E H:m');

  @override
  Widget build(BuildContext context) {
    String status = 'Ordered';
    final String orderDate = formatter.format(DateTime.now());

    if (widget.title.contains('SUCCESS')) {
      setState(() {
        dialogColor = Colors.green[700];
        dialogColor2 = Colors.green[800];
        dialogIcon = Icons.check_outlined;
        orderTitle = 'ORDER SUCCESSFUL';
        orderDescription =
            'Your Order was successful and you should recieve your package in 14 days';
        orderBtn = 'View Order Details';
        orderSuccess = true;
      });
    } else {
      setState(() {
        dialogColor = Colors.red[700];
        dialogColor2 = Colors.red[800];
        dialogIcon = Icons.cancel_outlined;
        orderTitle = 'ORDER FAILED';
        orderDescription =
            'Your Order Failed Due to Some reasons we are really sorry for the incovenience';
        orderBtn = 'Go Back';
        orderSuccess = false;
      });
    }
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(
                  0xff2E5F3B,
                ),
              ),
        ),
        home: Scaffold(
            body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 100.0,
                ),
                CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dialogColor,
                    ),
                    child: Icon(
                      dialogIcon,
                      size: 100.0,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                  ),
                  radius: 70.0,
                ),
                SizedBox(
                  height: 100.0,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      orderTitle,
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  orderDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 150.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: dialogColor2,
                        minimumSize: const Size.fromHeight(65),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () {
                      orderSuccess
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => OrderDetails(
                                        orderItems: widget.itemsList,
                                        orderDate: orderDate,
                                        status: status,
                                        amount: widget.amount,
                                      ))))
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => AddressPage(
                                        amount: widget.amount,
                                        retrievedItemsList:
                                            widget.retrievedItemsList,
                                        itemsList: widget.itemsList,
                                      ))));
                    },
                    child: Text(orderBtn))
              ],
            ),
          ),
        )));
  }
}
