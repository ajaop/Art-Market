import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ArtItems.dart';
import 'database_service.dart';
import 'item_details.dart';
import 'package:intl/intl.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
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
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
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
                              child: TextFormField(
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
                    child: FutureBuilder(
                      future: itemsList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ArtItems>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            retrievedItemsList?.isEmpty == null) {
                          const Center(
                            child: Text(
                              'No Favourites Yet',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20.0),
                            ),
                          );
                        }

                        if (retrievedItemsList?.isEmpty ?? true) {
                          return const Center(
                            child: Text(
                              'No Favourites Yet',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20.0),
                            ),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: 7,
                              itemBuilder: (context, position) {
                                return FavouriteItems(
                                    position: position,
                                    retrievedArtItems: retrievedItemsList);
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

    databaseService.retrieveFavouriteArt();
    itemsList = databaseService.retrieveArt();
    retrievedItemsList = await databaseService.retrieveArt();

    setState(() {
      _loading = false;
    });
  }
}

class FavouriteItems extends StatelessWidget {
  const FavouriteItems(
      {Key? key, required this.position, required this.retrievedArtItems})
      : super(key: key);

  final int position;
  final List<ArtItems>? retrievedArtItems;
  @override
  Widget build(BuildContext context) {
    String artPrice = '₦ 0.0';

    artPrice = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(retrievedArtItems?[position].artPrice);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ItemDetails(retrievedArtItem: retrievedArtItems![position]),
            ));
      },
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
                  image: retrievedArtItems![position].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 50.0,
            ),
            Flexible(
              child: Column(
                children: [
                  Text(
                    retrievedArtItems![position].artName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(
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
    );
  }
}
