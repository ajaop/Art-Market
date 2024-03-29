import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ArtItems.dart';
import 'database_service.dart';
import 'item_details.dart';
import 'package:intl/intl.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  Future<List<ArtItems>>? itemsList;
  List<ArtItems>? retrievedItemsList;
  DatabaseService databaseService = DatabaseService();
  final _searchTextController = TextEditingController();
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
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0),
              child: Column(
                children: [
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
                                      hintText: 'BUJU BNXN',
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
                                'No Favourites Yet',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 20.0),
                              ),
                            );
                          }

                          if (retrievedItemsList?.isEmpty ?? true) {
                            return const Center(
                              child: Text(
                                'No Favourites Yet',
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
                                  return FavouriteItems(
                                      position: position,
                                      retrievedArtItems: retrievedItemsList,
                                      getValues: getDefaultValues,
                                      messangerKey: _messangerKey);
                                },
                                separatorBuilder: (context, index) => SizedBox(
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
        ),
      )),
    );
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });

    itemsList = databaseService.retrieveFavouriteArt();
    retrievedItemsList = await databaseService.retrieveFavouriteArt();

    setState(() {
      _loading = false;
    });
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

    // Refresh the UI
    setState(() {
      retrievedItemsList = results;
    });
  }
}

class FavouriteItems extends StatefulWidget {
  const FavouriteItems(
      {Key? key,
      required this.position,
      required this.retrievedArtItems,
      this.getValues,
      this.messangerKey})
      : super(key: key);

  final int position;
  final List<ArtItems>? retrievedArtItems;
  final getValues, messangerKey;

  @override
  State<FavouriteItems> createState() => _FavouriteItemsState();
}

DatabaseService databaseService = DatabaseService();

class _FavouriteItemsState extends State<FavouriteItems> {
  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(widget.retrievedArtItems?[widget.position].artPrice);
    return InkWell(
      onTap: () async {
        bool inCart = await checkAddedToCart();

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetails(
                retrievedArtItem: widget.retrievedArtItems![widget.position],
                isLiked: true,
                inCart: inCart,
              ),
            )).then((value) {
          widget.getValues();
        });
      },
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        onDismissed: (direction) {
          databaseService.removeItemFromLIked(
              widget.retrievedArtItems![widget.position].docId,
              widget.messangerKey);
        },
        background: Container(
          decoration: BoxDecoration(
              color: Colors.red[600],
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Remove Art',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
              color: Color(0xffEEF7F0),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
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
                width: 50.0,
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkAddedToCart() async {
    return await databaseService
        .checkIfItemIsInCart(widget.retrievedArtItems![widget.position].docId);
  }
}
