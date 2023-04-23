import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ArtItems.dart';
import 'database_service.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails(
      {Key? key,
      required this.orderItems,
      this.orderDate,
      this.status,
      this.amount})
      : super(key: key);

  final Future<List<ArtItems>>? orderItems;
  final orderDate, status, amount;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
}

class _OrderDetailsState extends State<OrderDetails> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var statusColor = Colors.yellow[700];
    if (widget.status == "Pending") {
      statusColor = Colors.yellow[700];
    } else if (widget.status == "Delivered") {
      statusColor = Colors.green[700];
    }

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Order Details',
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 45.0),
                  Container(
                    height: 400.0,
                    child: FutureBuilder(
                      future: widget.orderItems,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ArtItems>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          const Center(
                            child: Text(
                              'No Ordered Items',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20.0),
                            ),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, position) {
                                return OrderItems(
                                    position: position,
                                    orderItems: snapshot.data);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 12.0,
                                  ));
                        } else {
                          return const Center(
                            child: SpinKitSquareCircle(
                              color: Color(0xff2E5F3B),
                              size: 100.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 7.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 21.0)),
                      Text(widget.amount,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 19.0))
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 21.0)),
                      Container(
                        height: 35.0,
                        decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date Ordered',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 21.0)),
                      Text(widget.orderDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 19.0))
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  const DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 7.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class OrderItems extends StatefulWidget {
  const OrderItems({Key? key, required this.position, required this.orderItems})
      : super(key: key);

  final int position;
  final List<ArtItems>? orderItems;

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(widget.orderItems?[widget.position].artPrice);

    return Container(
      decoration: const BoxDecoration(
          color: Color(0xffEEF7F0),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100.0,
                  width: 120.0,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.orderItems![widget.position].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30.0,
                ),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        widget.orderItems![widget.position].artName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      Text(
                        artPrice,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17.0),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.0,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: Color(0xff2E5F3B),
                  child: Text(
                    widget.orderItems![widget.position].quantity.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
