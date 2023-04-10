import 'package:art_market/address_page.dart';
import 'package:art_market/favourites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ArtItems.dart';
import 'database_service.dart';
import 'item_details.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  Future<List<ArtItems>>? itemsList;
  List<ArtItems>? retrievedItemsList;
  DatabaseService databaseService = DatabaseService();
  bool _loading = false, _empty = false;
  String subTotalText = "₦ 0.0", vatText = "₦ 0.0", totalText = "₦ 0.0";

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
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 0),
                  child: ListView(children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Cart',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 450.0,
                      child: RefreshIndicator(
                        onRefresh: () {
                          return getDefaultValues();
                        },
                        child: FutureBuilder(
                          future: itemsList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ArtItems>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                retrievedItemsList?.isEmpty == null) {
                              _empty = true;
                              const Center(
                                child: Text(
                                  'No Item in Cart Yet',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20.0),
                                ),
                              );
                            }

                            if (retrievedItemsList?.isEmpty ?? true) {
                              return const Center(
                                child: Text(
                                  'No Item in Cart Yet',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20.0),
                                ),
                              );
                            }

                            if (snapshot.hasData && snapshot.data != null) {
                              _empty = false;

                              return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: retrievedItemsList?.length ?? 0,
                                  itemBuilder: (context, position) {
                                    return CartItems(
                                        position: position,
                                        retrievedArtItems: retrievedItemsList,
                                        deleteItem: deleteItem,
                                        getValues: getDefaultValues,
                                        messangerKey: _messangerKey);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 12.0,
                                      ));
                            } else {
                              return Center(
                                child: SpinKitSquareCircle(
                                  color: Color(0xff2E5F3B),
                                  size: 100.0,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    const Divider(
                      height: 5.0,
                      thickness: 1.6,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sub Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0)),
                        Text(subTotalText,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 17.0))
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('7.5% VAT',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0)),
                        Text(
                          vatText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    const Divider(
                      height: 5.0,
                      thickness: 1.6,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text(totalText,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff2E5F3B),
                            minimumSize: const Size.fromHeight(65),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: _loading || _empty
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressPage(
                                              amount: totalText,
                                              retrievedItemsList:
                                                  retrievedItemsList,
                                            ))).then((value) {
                                  getDefaultValues();
                                });
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('CHECKOUT'),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ))
                  ])),
              if (_loading)
                const Center(
                  child: SpinKitSquareCircle(
                    color: Color(0xff2E5F3B),
                    size: 100.0,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });

    itemsList = databaseService.retrieveCart();
    retrievedItemsList = await databaseService.retrieveCart();

    if (retrievedItemsList?.isEmpty ?? true) {
      setState(() {
        _empty = true;
      });
    }

    if (retrievedItemsList?.isNotEmpty ?? true) {
      int subTotal = await sumAllItems();
      double vat = (subTotal * 0.075), total = subTotal + vat;
      setState(() {
        subTotalText = NumberFormat.currency(locale: "en_NG", symbol: "₦")
            .format(subTotal);
        vatText =
            NumberFormat.currency(locale: "en_NG", symbol: "₦").format(vat);
        totalText =
            NumberFormat.currency(locale: "en_NG", symbol: "₦").format(total);
      });
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> deleteItem(itemId) async {
    setState(() {
      _loading = true;
    });

    await databaseService.removeItemFromCart(itemId, _messangerKey);
    await getDefaultValues();

    setState(() {
      _loading = false;
    });
  }

  Future<int> sumAllItems() async {
    List<int> price = [];
    int totalAmount = 0;
    for (int i = 0; i < retrievedItemsList!.length; i++) {
      price.add(
          retrievedItemsList![i].artPrice * retrievedItemsList![i].quantity);
    }
    totalAmount = price.sum;
    print(price);
    return totalAmount;
  }
}

class CartItems extends StatefulWidget {
  const CartItems(
      {Key? key,
      required this.position,
      required this.retrievedArtItems,
      this.deleteItem,
      this.getValues,
      this.messangerKey})
      : super(key: key);

  final int position;
  final List<ArtItems>? retrievedArtItems;
  final deleteItem, getValues, messangerKey;

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  DatabaseService databaseService = DatabaseService();
  int quantity = 0;
  bool minusDisable = true;

  @override
  void initState() {
    super.initState();
    quantity = widget.retrievedArtItems![widget.position].quantity;
    if (quantity > 1) {
      minusDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(widget.retrievedArtItems?[widget.position].artPrice);

    return Container(
      decoration: const BoxDecoration(
          color: Color(0xffEEF7F0),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: Row(
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
                  image: widget.retrievedArtItems![widget.position].imageUrl,
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
                    widget.retrievedArtItems![widget.position].artName,
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          QtyOperations(true);
                        },
                        child: const CircleAvatar(
                            backgroundColor: Color(0xff7BBE8C),
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            )),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      InkWell(
                        onTap: minusDisable
                            ? null
                            : () {
                                QtyOperations(false);
                              },
                        child: const CircleAvatar(
                            backgroundColor: Color(0xff7BBE8C),
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 30.0,
            ),
            InkWell(
              onTap: () {
                widget.deleteItem(
                    widget.retrievedArtItems![widget.position].docId);
              },
              child: Container(
                height: 100.0,
                width: 50.0,
                child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.black,
                      size: 27.0,
                    )),
              ),
            ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> QtyOperations(bool isIncrease) async {
    if (isIncrease) {
      if (quantity >= 1) {
        setState(() {
          quantity = quantity + 1;
        });
      }
    } else {
      if (quantity > 1) {
        setState(() {
          quantity = quantity - 1;
        });
      }
    }

    await databaseService.editQuantityInCart(
        widget.retrievedArtItems![widget.position].docId,
        quantity,
        widget.messangerKey);

    widget.getValues();

    if (quantity <= 1) {
      setState(() {
        minusDisable = true;
      });
    } else {
      setState(() {
        minusDisable = false;
      });
    }
  }
}
