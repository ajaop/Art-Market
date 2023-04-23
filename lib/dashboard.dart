import 'dart:ui';

import 'package:art_market/ArtItems.dart';
import 'package:art_market/database_service.dart';
import 'package:art_market/item_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _searchTextController = TextEditingController();
  Future<List<ArtItems>>? itemsList;
  List<ArtItems>? retrievedItemsList;
  var img = null;
  String profileImageText = '';
  bool _loading = false, _imageLoaded = false;
  dynamic allBtnColor = Color(0xff69B47D),
      sketchBtnColor = Colors.white,
      paintingBtnColor = Colors.white;

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 30.0, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _imageLoaded
                          ? CircleAvatar(
                              radius: 38.0,
                              backgroundColor: Color(0xffC9E4D0),
                              child: CachedNetworkImage(
                                imageUrl: user?.photoURL.toString() ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 160.0,
                                  height: 160.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ))
                          : CircleAvatar(
                              radius: 38.0,
                              backgroundColor: Color(0xffC9E4D0),
                              child: Text(
                                profileImageText,
                                style: const TextStyle(
                                    color: Color(0xff1B3823),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23.0),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ThemeData()
                                      .colorScheme
                                      .copyWith(primary: Color(0xff2E5F3B)),
                                ),
                                child: TextFormField(
                                    controller: _searchTextController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                    onChanged: (value) =>
                                        filterFavourites(value),
                                    decoration: const InputDecoration(
                                      hintText: 'Art Market',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff2E5F3B),
                              minimumSize: const Size(80, double.infinity),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                            ),
                            child: Icon(Icons.search_outlined)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            allBtnColor = Color(0xff69B47D);
                            sketchBtnColor = Colors.white;
                            paintingBtnColor = Colors.white;
                            retrievedItemsList = [];
                            _loading = true;
                          });

                          retrievedItemsList =
                              await databaseService.retrieveArt();

                          setState(() {
                            _loading = false;
                          });
                        },
                        child: const Text('All',
                            style: TextStyle(color: Color(0xff1B3823))),
                        style: ElevatedButton.styleFrom(
                            primary: allBtnColor,
                            shape: const StadiumBorder(),
                            side:
                                BorderSide(color: Color(0xff418653), width: 2)),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            allBtnColor = Colors.white;
                            sketchBtnColor = Color(0xff69B47D);
                            paintingBtnColor = Colors.white;
                            retrievedItemsList = [];
                            _loading = true;
                          });

                          retrievedItemsList =
                              await databaseService.retrieveArtBySketches();

                          setState(() {
                            _loading = false;
                          });
                        },
                        child: const Text('Sketches',
                            style: TextStyle(color: Color(0xff1B3823))),
                        style: ElevatedButton.styleFrom(
                            primary: sketchBtnColor,
                            shape: const StadiumBorder(),
                            side:
                                BorderSide(color: Color(0xff418653), width: 2)),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            allBtnColor = Colors.white;
                            sketchBtnColor = Colors.white;
                            paintingBtnColor = Color(0xff69B47D);
                            retrievedItemsList = [];
                            _loading = true;
                          });

                          retrievedItemsList =
                              await databaseService.retrieveArtByPaintings();

                          setState(() {
                            _loading = false;
                          });
                        },
                        child: const Text(
                          'Paintings',
                          style: TextStyle(color: Color(0xff1B3823)),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: paintingBtnColor,
                            shape: const StadiumBorder(),
                            side:
                                BorderSide(color: Color(0xff418653), width: 2)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Expanded(
                      child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
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
                                'No Art Yet',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 20.0),
                              ),
                            );
                          }

                          if (retrievedItemsList?.isEmpty ?? true) {
                            return const Center(
                              child: Text(
                                'No Art Yet',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 20.0),
                              ),
                            );
                          }

                          if (snapshot.hasData && snapshot.data != null) {
                            return GridView.custom(
                              shrinkWrap: true,
                              gridDelegate: SliverWovenGridDelegate.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                pattern: [
                                  const WovenGridTile(1),
                                  const WovenGridTile(
                                    5 / 7,
                                    crossAxisRatio: 0.9,
                                    alignment: AlignmentDirectional.centerEnd,
                                  ),
                                ],
                              ),
                              childrenDelegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return CardArtItem(
                                    index: index,
                                    retrievedArtItems: retrievedItemsList);
                              }, childCount: retrievedItemsList?.length ?? 0),
                            );
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
                  )),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            ),
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
    );
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });
    profileImageText =
        await databaseService.getImageText(context, _messangerKey);

    itemsList = databaseService.retrieveArt();
    retrievedItemsList = await databaseService.retrieveArt();
    getProfilePic();

    setState(() {
      _loading = false;
    });
  }

  Future<void> getProfilePic() async {
    final User? user = auth.currentUser;

    if (user!.photoURL?.isEmpty == null) {
      setState(() => _imageLoaded = false);
    } else {
      img = Image.network(user.photoURL.toString());

      img.image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
        if (mounted) {
          setState(() => _imageLoaded = true);
        }
      }));
    }
  }

  Future<void> filterFavourites(String enteredKeyword) async {
    retrievedItemsList = await databaseService.retrieveFavouriteArt();

    List<ArtItems> results = [];
    if (enteredKeyword.isEmpty) {
      results = await databaseService.retrieveFavouriteArt();
    } else {
      results = retrievedItemsList!
          .where((item) =>
              item.artName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      retrievedItemsList = results;
    });
  }
}

class CardArtItem extends StatefulWidget {
  const CardArtItem(
      {Key? key, required this.index, required this.retrievedArtItems})
      : super(key: key);

  final int index;
  final List<ArtItems>? retrievedArtItems;

  @override
  State<CardArtItem> createState() => _CardArtItemState();
}

DatabaseService databaseService = DatabaseService();

class _CardArtItemState extends State<CardArtItem> {
  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';
    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(widget.retrievedArtItems?[widget.index].artPrice);

    return InkWell(
      onTap: () async {
        bool isFavourite = await checkFavourite();
        bool inCart = await checkAddedToCart();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetails(
                  retrievedArtItem: widget.retrievedArtItems![widget.index],
                  isLiked: isFavourite,
                  inCart: inCart),
            ));
      },
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.retrievedArtItems![widget.index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xffEEF7F0),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                    child: Text(
                      widget.retrievedArtItems![widget.index].artName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff08110B),
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(13.0, 0, 10.0, 5.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(artPrice,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                              color: Color(0xff08110B),
                            ))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkFavourite() async {
    return await databaseService
        .checkIfItemIsLIked(widget.retrievedArtItems![widget.index].docId);
  }

  Future<bool> checkAddedToCart() async {
    return await databaseService
        .checkIfItemIsInCart(widget.retrievedArtItems![widget.index].docId);
  }
}
