import 'package:art_market/onBoarding.dart';
import 'package:art_market/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_services.dart';
import 'homepage.dart';
import 'signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

int? isviewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => isviewed == 0 || isviewed == null
          ? const OnBoardingPage()
          : authService.checkIfLoggedIn2(context)
              ? HomePage()
              : SignIn(),
      '/homepage': (context) => const HomePage(),
      '/signup': (context) => const SignUp(),
    });
  }
}
