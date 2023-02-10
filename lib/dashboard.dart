import 'package:art_market/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  String profileImageText = '';
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
        scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 30.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          radius: 38.0,
                          backgroundColor: Color(0xffC9E4D0),
                          child: Text(
                            profileImageText,
                            style: TextStyle(
                                color: Color(0xff1B3823),
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
      ),
    );
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });
    profileImageText =
        await databaseService.getImageText(context, _messangerKey);

    setState(() {
      _loading = false;
    });
  }
}
