import 'package:art_market/ArtItems.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';
import 'database_service.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails(
      {Key? key, required this.retrievedArtItem, required this.isLiked})
      : super(key: key);

  final ArtItems retrievedArtItem;
  final bool isLiked;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  bool _loading = false;
  DatabaseService databaseService = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  String buttonText = 'Add To Cart';

  @override
  void initState() {
    super.initState();
    retrieveDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(widget.retrievedArtItem.artPrice);

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
            Column(
              children: [
                Expanded(
                  child: ListView(
                      padding: EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      children: [
                        Column(children: [
                          Container(
                            height: 450.0,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40.0)),
                              child: Stack(
                                children: [
                                  FadeInImage.memoryNetwork(
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder: kTransparentImage,
                                    image: widget.retrievedArtItem.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.retrievedArtItem.artName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0),
                                    ),
                                    CircleAvatar(
                                      radius: 23.0,
                                      backgroundColor: Colors.grey[300],
                                      child: LikeButton(
                                        isLiked: widget.isLiked,
                                        onTap: onLikeButtonTapped,
                                        size: 25.0,
                                        circleColor: const CircleColor(
                                            start: Color(0xffC1D0C5),
                                            end: Color(0xff69B47D)),
                                        bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xffC1D0C5),
                                            dotSecondaryColor:
                                                Color(0xff69B47D)),
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Color(0xff69B47D),
                                                  size: 25.0,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  color: Color(0xff69B47D),
                                                  size: 25.0,
                                                );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    artPrice,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "It is dedicated to the low life people of konoha village who lived through tough times during the hokages reaign bla bla vla vla",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18.0,
                                      color: Colors.grey[600]),
                                )
                              ],
                            ),
                          )
                        ])
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff2E5F3B),
                          minimumSize: const Size.fromHeight(57),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: _loading
                          ? null
                          : () async {
                              setState(() {
                                _loading = true;
                              });
                              addItemToCart();

                              setState(() {
                                _loading = false;
                              });
                            },
                      child: Text(buttonText)),
                ),
              ],
            ),
            if (_loading && buttonText.contains('Add To Cart'))
              const Center(
                child: SpinKitSquareCircle(
                  color: Color(0xff2E5F3B),
                  size: 100.0,
                ),
              )
          ],
        ),
      )),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (isLiked == true) {
      await databaseService.removeItemFromLIked(
          widget.retrievedArtItem.docId, _messangerKey);
    } else {
      await databaseService.addItemToLIked(widget.retrievedArtItem.docId,
          widget.retrievedArtItem.artName, _messangerKey);
    }

    return !isLiked;
  }

  Future<void> addItemToCart() async {
    await databaseService.addItemToCart(widget.retrievedArtItem.docId,
        widget.retrievedArtItem.artName, _messangerKey);

    bool isInCart = await databaseService
        .checkIfItemIsInCart(widget.retrievedArtItem.docId);

    if (isInCart == true) {
      setState(() {
        buttonText = 'Already Added To Cart';
        _loading = isInCart;
      });
    } else {
      setState(() {
        buttonText = 'Add To Cart';
        _loading = isInCart;
      });
    }
  }

  void retrieveDefaultValues() async {
    /*  bool isFavourite =
        await databaseService.checkIfItemIsLIked(widget.retrievedArtItem.docId);

    bool isInCart = await databaseService
        .checkIfItemIsInCart(widget.retrievedArtItem.docId);

    if (isInCart = true) {
      setState(() {
        buttonText = 'Already Added To Cart';
      });
    } else {
      print('here');
      setState(() {
        buttonText = 'Add To Cart';
      });
    }
    

    setState(() {
      isLiked = isFavourite;
      _loading = isInCart;
    });
    */
  }
}
