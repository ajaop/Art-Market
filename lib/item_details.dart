import 'package:art_market/ArtItems.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key, required this.retrievedArtItem})
      : super(key: key);

  final ArtItems retrievedArtItem;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      print("user Id ${user.uid}");
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 4, 44, 76),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xffEEF7F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: [
            Column(children: [
              Container(
                height: 400.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffC1D0C5),
                ),
                child: Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.retrievedArtItem.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ])
          ])),
    );
  }
}
