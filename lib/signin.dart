import 'package:art_market/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'auth_services.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true, _loading = false;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.checkIfLoggedIn(context);
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
            body: Center(
                child: SafeArea(
                    child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      const Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                              letterSpacing: 0.6,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1B3823)),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1B3823)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'test@gmail.com',
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1B3823)),
                            ),
                          )),
                      const SizedBox(
                        height: 4.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: '*******'),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xff2E5F3B),
                              minimumSize: const Size.fromHeight(55),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold)),
                          onPressed: !_loading
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _loading = true;
                                    });

                                    await authService.login(
                                        _emailController.text.toString(),
                                        _passwordController.text.toString(),
                                        context,
                                        _messangerKey);

                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                }
                              : null,
                          child: const Text('Sign in')),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dont have an account ?"),
                          TextButton(
                              style: TextButton.styleFrom(
                                  primary: Color(0xff418653)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const SignUp())));
                              },
                              child: const Text('Sign up'))
                        ],
                      )
                    ]),
                  ),
                ),
              ],
            ))),
          ),
          if (_loading)
            Center(
              child: SpinKitSquareCircle(
                color: Color(0xff2E5F3B),
                size: 100.0,
              ),
            )
        ],
      ),
    );
  }
}
