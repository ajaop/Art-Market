import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:art_market/ArtItems.dart';
import 'package:art_market/Orders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'database_service.dart';
import 'package:path/path.dart' as p;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  Future<List<Orders>>? ordersList;
  List<Orders>? retrievedOrdersList;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false, _imageLoaded = false, _obscureText = true;
  String firstName = "", lastName = "", fullName = "", profileImageText = "";
  var img = null;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData().copyWith(
        //   scaffoldBackgroundColor: Color(0xffEEF7F0),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
          body: SafeArea(
              child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 25.0, 15.0, 0),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'My Profile',
                    style:
                        TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 45.0),
                Container(
                  height: 220.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 223, 220, 220),
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Color(0xffEEF7F0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 25.0,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 15.0, 25.0, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              _showPopupMenu();
                              /* 
                                      */
                            },
                            child: const CircleAvatar(
                              backgroundColor: Color(0xff95C2A1),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              radius: 22.0,
                            ),
                          ),
                        ),
                      ),
                      _imageLoaded
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                    radius: 45.0,
                                    backgroundColor: Color(0xffC9E4D0),
                                    child: CachedNetworkImage(
                                      imageUrl: user?.photoURL.toString() ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 160.0,
                                        height: 160.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                                Positioned(
                                    bottom: 0,
                                    right: -15,
                                    child: InkWell(
                                      onTap: () {
                                        _dialogBuilder(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFF5F6F9),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                              ],
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 45.0,
                                  backgroundColor: Color(0xffC9E4D0),
                                  child: Text(
                                    profileImageText,
                                    style: const TextStyle(
                                        color: Color(0xff1B3823),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: -15,
                                    child: InkWell(
                                      onTap: () {
                                        _dialogBuilder(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFF5F6F9),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        fullName,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Recent Orders',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FutureBuilder(
                  future: ordersList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Orders>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        retrievedOrdersList?.isEmpty == null) {
                      const Center(
                        child: Text(
                          'No Recent Orders',
                          style: TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                      );
                    }

                    if (retrievedOrdersList?.isEmpty ?? true) {
                      return const Center(
                        child: Text(
                          'No Recent Orders',
                          style: TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                      );
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: retrievedOrdersList?.length ?? 0,
                          itemBuilder: (context, position) {
                            return orderWidget(position);
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
      ))),
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(520, 250, 10, 100),
      color: Color(0xffEEF7F0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      items: [
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                _firstNameController.text = firstName;
                _lastNameController.text = lastName;
                showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35.0),
                      ),
                    ),
                    builder: (BuildContext context) =>
                        StatefulBuilder(builder: (context, setModalState) {
                          return editNameWidget(context, setModalState);
                        }));
              },
              child: Row(
                children: const [
                  Text(
                    "Edit Name",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35.0),
                      ),
                    ),
                    builder: (BuildContext context) =>
                        StatefulBuilder(builder: (context, setModalState2) {
                          return editPasswordWidget(context, setModalState2);
                        }));
              },
              child: Row(
                children: const [
                  Text(
                    "Change Password",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                _signOut();
              },
              child: Row(
                children: const [
                  Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  Padding editNameWidget(BuildContext context, setModalState) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'First Name',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.6,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ThemeData()
                            .colorScheme
                            .copyWith(primary: Color(0xff2E5F3B)),
                      ),
                      child: TextFormField(
                        controller: _firstNameController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]")),
                          LengthLimitingTextInputFormatter(100),
                        ],
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff2E5F3B))),
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)))),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'First Name is required';
                          } else if (value.startsWith(RegExp(r'[0-9]'))) {
                            return 'First name is not valid';
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Last Name',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.6,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ThemeData()
                            .colorScheme
                            .copyWith(primary: Color(0xff2E5F3B)),
                      ),
                      child: TextFormField(
                        controller: _lastNameController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]")),
                          LengthLimitingTextInputFormatter(100),
                        ],
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xff2E5F3B))),
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Last Name is required';
                          } else if (value.startsWith(RegExp(r'[0-9]'))) {
                            return 'Last name is not valid';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff2E5F3B),
                            minimumSize: const Size.fromHeight(65),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: !_loading
                            ? () {
                                String name1, name2;
                                name1 = _firstNameController.text.toString();

                                name2 = _lastNameController.text.toString();
                                if (_formKey.currentState!.validate()) {
                                  editAccountInfo(setModalState, name1.trim(),
                                      name2.trim());
                                }
                              }
                            : null,
                        child: Text('Edit Name')),
                    SizedBox(
                      height: 50.0,
                    )
                  ]),
                ],
              ))),
    );
  }

  Padding editPasswordWidget(BuildContext context, StateSetter setModalState2) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'New Password',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.6,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ThemeData()
                            .colorScheme
                            .copyWith(primary: Color(0xff2E5F3B)),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setModalState2(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff2E5F3B))),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
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
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.6,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ThemeData()
                            .colorScheme
                            .copyWith(primary: Color(0xff2E5F3B)),
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setModalState2(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff2E5F3B))),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            hintText: '*******'),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != _passwordController.text.toString() ||
                              value!.isEmpty) {
                            return 'Passwords don\'t match';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff2E5F3B),
                            minimumSize: const Size.fromHeight(65),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: !_loading
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  String pass =
                                      _passwordController.text.toString();
                                  _changePassword(setModalState2, pass.trim());
                                }
                              }
                            : null,
                        child: const Text('Edit Password')),
                    SizedBox(
                      height: 50.0,
                    )
                  ]),
                ],
              ))),
    );
  }

  void _changePassword(StateSetter setModalState2, String password) async {
    setState(() {
      _loading = true;
    });
    setModalState2(() {
      _loading = true;
    });

    final User? user = auth.currentUser;

    await user!.updatePassword(password).then((_) async {
      Navigator.pop(context);
      displaySuccess('Password Change Successful');
    }).catchError((error) {
      Navigator.pop(context);
      displayError(error.toString());
    });

    setState(() {
      _loading = false;
    });

    setModalState2(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _imageLoaded = false;
      _loading = true;
    });

    await FirebaseAuth.instance.signOut();
    final User? user = auth.currentUser;
    if (user?.uid.isEmpty == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/', (Route<dynamic> route) => false);
    } else {
      print("user Id ${user!.uid}");
    }
  }

  Container orderWidget(int position) {
    String amount = retrievedOrdersList![position].totalAmt;
    String status = retrievedOrdersList![position].status;
    int currentYear = new DateTime.now().year;
    int currentMonth = new DateTime.now().month;
    final DateFormat formatter;
    Future<List<ArtItems>> orderedItems =
        retrievedOrdersList![position].artItems;

    if (currentYear == retrievedOrdersList![position].orderDate.year &&
        currentMonth == retrievedOrdersList![position].orderDate.month) {
      formatter = DateFormat('dd, E H:m');
    } else if (currentYear == retrievedOrdersList![position].orderDate.year) {
      formatter = DateFormat('dd MMM,  H:m');
    } else {
      formatter = DateFormat('dd MMM, yyyy  H:m');
    }

    final String orderDate =
        formatter.format(retrievedOrdersList![position].orderDate);
    var statusColor = Colors.yellow[700];
    if (status == "Pending") {
      statusColor = Colors.yellow[700];
    } else if (status == "Delivered") {
      statusColor = Colors.green[700];
    }
    if (amount.split(".").last == '00') {
      amount = amount.substring(0, amount.indexOf('.'));
    }

    return Container(
      height: 85.0,
      decoration: BoxDecoration(
          color: Color(0xffEEF7F0), borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
              child: FutureBuilder(
                  future: orderedItems,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ArtItems>> snapshot) {
                    if (snapshot.hasData) {
                      return overlapped(snapshot);
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 27.0,
                      );
                    }
                  })),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orderDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(25.0)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      status,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget overlapped(AsyncSnapshot<List<ArtItems>> snapshot) {
    int itemLength = 1;
    if (snapshot.data!.length <= 3) {
      itemLength = snapshot.data!.length;
    } else {
      itemLength = 3;
    }
    final overlap = 25.0;

    final items = [];

    for (int i = 0; i < itemLength; i++) {
      items.add(CircleAvatar(
        backgroundImage: NetworkImage(snapshot.data![i].imageUrl),
        backgroundColor: Colors.white,
        radius: 27.0,
      ));
    }
    List<Widget> stackLayers = List<Widget>.generate(itemLength, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });

    return Stack(children: stackLayers);
  }

  Future<void> getDefaultValues() async {
    setState(() {
      _loading = true;
    });

    getAllValues();

    ordersList = databaseService.retrieveOrders();
    retrievedOrdersList = await databaseService.retrieveOrders();
    profileImageText =
        await databaseService.getImageText(context, _messangerKey);

    setState(() {
      _loading = false;
    });
  }

  Future<void> getAllValues() async {
    final User? user = auth.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .get()
        .then((value) => value.docs.forEach((doc) {
              lastName = doc.data()['lastname'].toString();
              firstName = doc.data()['firstname'].toString();
            }))
        .onError((error, stackTrace) => displayError(error));

    fullName = lastName + " " + firstName;

    if (user.photoURL?.isEmpty == null) {
      setState(() => _imageLoaded = false);
    } else {
      img = Image.network(user.photoURL.toString());

      img.image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
        if (mounted) {
          setState(() => _imageLoaded = true);
        }
      }));
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          barrierColor:
          Colors.black26;
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          primary: Color.fromARGB(255, 246, 241, 241),
                          minimumSize: const Size(150, 65),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () {
                          setState(() {
                            _getFromCamera();
                          });
                        },
                        child: Row(children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Camera',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))
                        ])),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 5.0,
                            primary: Color.fromARGB(255, 241, 239, 239),
                            minimumSize: const Size(150, 65),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onPressed: () {
                          setState(() {
                            _getFromGallery();
                          });
                        },
                        child: Row(children: const [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Gallery',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))
                        ])),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _getFromGallery() async {
    Navigator.pop(context);
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        requestFullMetadata: false);
    if (file != null) {
      setState(() {
        uploadImage(file);
      });
    }
    getDefaultValues();
  }

  /// Get from Camera
  _getFromCamera() async {
    Navigator.pop(context);
    var path;
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        requestFullMetadata: false);
    if (file != null) {
      setState(() {
        path = file.name;
        uploadImage(file);
      });
    }
    getDefaultValues();
  }

  Future<void> uploadImage(XFile file) async {
    setState(() {
      _loading = true;
    });

    final User? user = auth.currentUser;
    var imageFile, imagePath;
    String imgExtension;

    imageFile = File(file.path);
    imgExtension = p.extension(file.name);
    imagePath = 'users/${user!.uid.toString() + imgExtension}';

    final uploadImage =
        FirebaseStorage.instance.ref().child(imagePath).putFile(imageFile);

    final snapshot = await uploadImage.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();

    user
        .updatePhotoURL(urlDownload)
        .then(
          (value) => getAllValues(),
        )
        .onError((error, stackTrace) => displayError(error));

    setState(() {
      _loading = false;
    });
  }

  Future<void> editAccountInfo(
      StateSetter setModalState, String firstName, String lastName) async {
    final User? user = auth.currentUser;

    setState(() {
      _loading = true;
    });

    setModalState(() {
      _loading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .get()
        .then((value) => value.docs.forEach((doc) {
              doc.reference.update(
                {'firstname': firstName, 'lastname': lastName},
              ).then((value) {
                setModalState(() {
                  _loading = false;
                });
              });
            }));

    setState(() {
      _loading = false;
    });

    Navigator.pop(context);
    getAllValues();
  }

  void displayError(errorMessage) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));
  }

  void displaySuccess(successMessage) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green[600],
        elevation: 0,
        content: Text(
          successMessage,
          textAlign: TextAlign.center,
        )));
  }
}
