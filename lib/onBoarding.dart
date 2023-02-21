import 'package:art_market/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    _storeOnboardInfo() async {
      int isViewed = 1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('onBoard', isViewed);
      print('preferences ${prefs.getInt('onBoard')}');
    }

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Stack(children: [
        Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Container(
                      height: 500.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/onboarding_image.jpg'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0)),
                      )),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              'The Art Market Place',
                              style: TextStyle(
                                color: Color(0xff1B3823),
                                fontSize: 32.0,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              'Welcome to the Mobile market place for all your art needs compiled by various artistes from around the world',
                              style: TextStyle(
                                color: Color(0xff1B3823),
                                wordSpacing: 1.0,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff2E5F3B),
                                    minimumSize: const Size.fromHeight(65),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  _storeOnboardInfo();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const SignUp())));
                                },
                                child: const Text('Get Started')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
