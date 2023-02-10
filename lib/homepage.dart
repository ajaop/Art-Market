import 'package:art_market/cart.dart';
import 'package:art_market/favourites.dart';
import 'package:art_market/profile.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    switch (_index) {
      case 0:
        widget = const Dashboard();
        break;

      case 1:
        widget = const Favourites();
        break;

      case 2:
        widget = const Cart();
        break;

      case 3:
        widget = const Profile();
        break;
    }

    return Scaffold(
        body: widget,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(35),
            topLeft: Radius.circular(35),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.white,
            backgroundColor: Color(0xffA2D1AE),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: 'FAVOURITE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'CART',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'PROFILE',
              ),
            ],
            currentIndex: _index,
            onTap: (int index) => setState(() => _index = index),
            selectedItemColor: Color(0xff1B3823),
          ),
        ));
  }
}
