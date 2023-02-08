import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Stack(children: [
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
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Sign Up',
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
                          child: Text(
                            'Firstname',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1B3823)),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'John',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Firstname is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lastname',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1B3823)),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Doe',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {},
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lastname is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1B3823)),
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
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {},
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1B3823)),
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
                            LengthLimitingTextInputFormatter(100),
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password must be at least 6  character';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        const Text(
                          'Creating an account means you agree to the Terms of Service and our Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              letterSpacing: 0.2,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff2E5F3B),
                                minimumSize: const Size.fromHeight(55),
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold)),
                            onPressed: !_loading
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                    }
                                  }
                                : null,
                            child: const Text('Create Account')),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account ?"),
                            TextButton(
                                style: TextButton.styleFrom(
                                    primary: Color(0xff418653)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Sign in')),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
        if (_loading)
          Center(
            child: SpinKitSquareCircle(
              color: Color(0xff2E5F3B),
              size: 100.0,
            ),
          )
      ]),
    );
  }
}
