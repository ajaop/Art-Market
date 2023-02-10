import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Favourites'),
        ),
      ),
    );
  }
}
