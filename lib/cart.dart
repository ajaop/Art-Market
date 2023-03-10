import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ArtItems.dart';
import 'database_service.dart';
import 'item_details.dart';
import 'package:intl/intl.dart';

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
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 15.0, 0),
                  child: Column(children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Cart',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Expanded(
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
                              return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: retrievedItemsList?.length ?? 0,
                                  itemBuilder: (context, position) {
                                    return CartItems(
                                      position: position,
                                      retrievedArtItems: retrievedItemsList,
                                      getValues: getDefaultValues,
                                    );
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
                    )
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

    setState(() {
      _loading = false;
    });
  }
}

class CartItems extends StatelessWidget {
  const CartItems(
      {Key? key,
      required this.position,
      required this.retrievedArtItems,
      this.getValues})
      : super(key: key);

  final int position;
  final List<ArtItems>? retrievedArtItems;
  final getValues;

  @override
  Widget build(BuildContext context) {
    String artPrice = '??? 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "???")
        .format(retrievedArtItems?[position].artPrice);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ItemDetails(retrievedArtItem: retrievedArtItems![position]),
            )).then((value) {
          getValues();
        });
      },
      child: Container(
        decoration: const BoxDecoration(
            //color: Color(0xffEEF7F0),
            borderRadius: BorderRadius.all(Radius.circular(15))),
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
                  image: retrievedArtItems![position].imageUrl,
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
                    retrievedArtItems![position].artName,
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
                ],
              ),
            ),
            SizedBox(
              width: 50.0,
            ),
            CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                  size: 27.0,
                )),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
