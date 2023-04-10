import 'package:art_market/cart.dart';
import 'package:art_market/homepage.dart';
import 'package:art_market/order_success_page.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'ArtItems.dart';
import 'database_service.dart';

class AddressPage extends StatefulWidget {
  const AddressPage(
      {Key? key, required this.amount, required this.retrievedItemsList})
      : super(key: key);
  final String amount;
  final List<ArtItems>? retrievedItemsList;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

const List<String> list = <String>[
  'Nigeria',
  'Zimbabwe',
  'Ghana',
  'South Africa'
];
var stateList = {
  'Nigeria': ['Lagos', 'Ogun', 'Oyo', 'Akwa Ibom'],
  'Zimbabwe': ['Bulawayo', 'Harare', 'Manicaland', 'Mashonaland Central'],
  'Ghana': ['Ahafo', 'Ashanti', 'Bono East', 'Brong Ahafo'],
  'South Africa': ['Eastern Cape', 'Gauteng', 'Limpopo', 'Mpumalanga']
};

var citiesList = {
  'Lagos': ['Lagos', 'Ikeja', 'Lekki', 'Okorodu'],
  'Ogun': ['Abokuta', 'Ijebu', 'Odeda', 'Sagamu'],
  'Oyo': ['Ibadan', 'Egbeda', 'Iseyin', 'Iyanaofa'],
  'Akwa Ibom': ['Uyo', 'Abak', 'Ikot Abasi', 'Nsit-Ibom'],
  'Bulawayo': ['Barbourfields', 'Barham Green', 'Beacon Hill', 'Bellevue'],
  'Harare': ['Harare', 'Chitungwiza', 'Epworth', 'Ruwa'],
  'Manicaland': [
    'Buhera District',
    'Chimanimani District',
    'Makoni District',
    'Mutasa District'
  ],
  'Mashonaland Central': ['Bindura', 'Mbire', 'Guruve', 'Rushinga'],
  'Ahafo': ['Goaso', 'Bechem', 'Duayaw Nkwanta', 'Techimantia'],
  'Ashanti': [
    'Adansi North',
    'Adansi Asokwa',
    'Adansi South',
    'Afigya Kwabre North'
  ],
  'Bono East': [
    'Atebubu-Amanten',
    'Kintampo North',
    'Kintampo South',
    'Nkoranza North'
  ],
  'Greater Accra': [
    'Accra Metropolitan',
    'Ada East',
    'Ada West',
    'Adenta Municipal'
  ],
  'Eastern Cape': ['Mthatha ', 'Komani', 'Makhanda', 'Dikeni'],
  'Gauteng': ['Johannesburg', 'Boksburg', 'Alberton', 'Carletonville'],
  'Limpopo': [
    'Capricorn District',
    'Mopani Districs',
    'Sekhukhune District',
    'Vhembe District'
  ],
  'Mpumalanga': [
    'Ehlanzeni District',
    'Gert Sibande District',
    'Nkangala District'
  ]
};

class _AddressPageState extends State<AddressPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>(),
      _formKey2 = GlobalKey<FormState>(),
      _streetAddressController = TextEditingController();
  int _index = 0;
  String? countryDropdownValue, stateDropdownValue, cityDropdownValue;
  String cardNum = '', expDate = '', cardName = '', cvv = '';
  String countryVal = '',
      stateVal = '',
      cityVal = '',
      streetAddVal = '',
      cardNumVal = 'XXXX XXXX XXXX XXXX',
      cardNamVal = '',
      expVal = '',
      cvvVal = '';
  String addressBtnText = "PAYMENT", paymentBtnTex = "CONFIRM ORDER";
  bool isCvvFocused = false,
      useGlassMorphism = false,
      useBackgroundImage = false;
  DatabaseService databaseService = DatabaseService();
  var addressBtnColor = Color(0xff2E5F3B), paymentBtnColor = Color(0xff2E5F3B);
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    checkIfDataExist();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(
                  0xff2E5F3B,
                ),
              ),
        ),
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0),
              child: Stepper(
                currentStep: _index,
                type: StepperType.horizontal,
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index <= 1) {
                    setState(() {
                      _index += 1;
                    });
                  }
                },
                onStepTapped: (int index) async {
                  String check = await checkIfDataExist();
                  setState(() {
                    if (index == 1 && check == "Address Completed") {
                      _index = 1;
                    } else if (index == 1 && check == "") {
                      databaseService.displayError(
                          "Complete the Address Page", _messangerKey);
                    } else if (index == 2 && check == "Forms Completed") {
                      _index = 2;
                    } else if (index == 2 && check == "") {
                      databaseService.displayError(
                          "Complete the Payment Page", _messangerKey);
                    } else {
                      _index = index;
                    }
                  });
                },
                controlsBuilder: (context, controller) {
                  return const SizedBox.shrink();
                },
                steps: <Step>[
                  Step(
                    state: _index > 0 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 0,
                    title: const Icon(Icons.location_on_outlined),
                    content: addressStage(),
                  ),
                  Step(
                    state: _index > 1 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 1,
                    title: const Icon(Icons.payment_outlined),
                    content: cardDetailsStage(),
                  ),
                  Step(
                    state: _index > 2 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 2,
                    title: const Icon(Icons.shopping_cart_outlined),
                    content: confirmOrderStage(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container addressStage() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Text(
              'ADDRESS',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 35.0,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Country',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1B3823)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                              .copyWith(bottomRight: Radius.circular(0)),
                        ),
                      ),
                      value: countryDropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          countryDropdownValue = value!;
                          stateDropdownValue = null;
                          cityDropdownValue = null;
                        });
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Country is required';
                        }
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'State',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1B3823)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                              .copyWith(bottomRight: Radius.circular(0)),
                        ),
                      ),
                      value: stateDropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          stateDropdownValue = value!;
                          cityDropdownValue = null;
                        });
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'State is required';
                        }
                      },
                      items: stateList[countryDropdownValue]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'City',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1B3823)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                              .copyWith(bottomRight: Radius.circular(0)),
                        ),
                      ),
                      value: cityDropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          cityDropdownValue = value!;
                        });
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'City is required';
                        }
                      },
                      items: citiesList[stateDropdownValue]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Street Address',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1B3823)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      controller: _streetAddressController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'No 12 Block 5 Samson Los Street, Ajadi',
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(200),
                      ],
                      keyboardType: TextInputType.streetAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Street Address is required';
                        }
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 60.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: addressBtnColor,
                    minimumSize: const Size.fromHeight(65),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      uploadDataToSharedPreference("Address");
                      _index += 1;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(addressBtnText),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ))
          ],
        ));
  }

  Container cardDetailsStage() {
    return Container(
        child: Column(
      children: [
        Text(
          'PAYMENT',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20.0,
        ),
        CreditCardWidget(
          cardNumber: cardNum,
          expiryDate: expDate,
          cardHolderName: cardName,
          cvvCode: cvv,
          bankName: '    ',
          showBackView: isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          isChipVisible: false,
          cardBgColor: Colors.black,
          backgroundImage: 'images/card_image.jpg',
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          customCardTypeIcons: <CustomCardTypeIcon>[
            CustomCardTypeIcon(
              cardType: CardType.mastercard,
              cardImage: Image.asset(
                'assets/mastercard.png',
                height: 48,
                width: 48,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        SingleChildScrollView(
            child: Column(children: <Widget>[
          CreditCardForm(
            formKey: _formKey2,
            cardNumberValidator: (String? cardNumber) {
              if (cardNumber!.isEmpty) {
                return 'Card Number is required';
              }

              if (cardNumber.replaceAll(' ', '').length < 16) {
                return 'Invalid Card Number';
              }
            },
            expiryDateValidator: (String? expiryDate) {
              int expInt = int.parse(expiryDate?.substring(3, 5) ?? '00');
              final now = new DateTime.now();

              int currentYear = int.parse(
                  DateFormat('y').format(now).substring(2, 4)); // 28/03/2020

              if (expiryDate!.isEmpty) {
                return 'Expiry Date is required';
              }
              if (expInt < currentYear) {
                return 'Invalid Expiry Date';
              }
            },
            cvvValidator: (String? cvv) {
              if (cvv!.isEmpty) {
                return 'CVV is required';
              }
            },
            cardHolderValidator: (String? cardHolderName) {
              if (cardHolderName!.isEmpty) {
                return 'Card Holder Name is required';
              }
            },
            obscureCvv: true,
            obscureNumber: true,
            cardNumber: cardNum,
            cvvCode: cvv,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardHolderName: cardName,
            expiryDate: expDate,
            themeColor: Color(0xffC9E4D0),
            textColor: Colors.black,
            cardNumberDecoration: InputDecoration(
              labelText: 'Card Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Color(0xff2E5F3B)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: Color(0xff2E5F3B)),
              ),
            ),
            expiryDateDecoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Color(0xff2E5F3B)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: Color(0xff2E5F3B)),
              ),
              labelText: 'Expiry Date',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Color(0xff2E5F3B)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: Color(0xff2E5F3B)),
              ),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Color(0xff2E5F3B)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: Color(0xff2E5F3B)),
              ),
              labelText: 'Card Holder',
            ),
            onCreditCardModelChange: onCreditCardModelChange,
          ),
          SizedBox(
            height: 60.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: paymentBtnColor,
                  minimumSize: const Size.fromHeight(65),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              onPressed: () {
                if (_formKey2.currentState!.validate()) {
                  setState(() {
                    uploadDataToSharedPreference("Card");
                    _index += 1;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(paymentBtnTex),
                  Icon(Icons.arrow_forward_ios),
                ],
              ))
        ]))
      ],
    ));
  }

  Container confirmOrderStage() {
    return Container(
        child: Stack(
      children: [
        Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    'CONFIRM ORDER',
                    style:
                        TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Payment Information',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 85.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: const DecorationImage(
                        image: AssetImage('images/card_image.jpg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
                        child: Container(
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff255C3F),
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: const Icon(
                            Icons.credit_card_outlined,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cardNamVal,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              cardNumVal.substring(0, 4) +
                                  ' **** **** ' +
                                  cardNumVal.substring(15, 19),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _index = 1;
                            });
                          },
                          child: const SizedBox(
                            height: 55.0,
                            width: 50.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.edit_outlined,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Delivery Address',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 85.0,
                  decoration: BoxDecoration(
                      color: Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
                        child: Container(
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: const Icon(
                            Icons.delivery_dining,
                            size: 30.0,
                            color: Color(0xff255C3F),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stateVal + ', ' + countryVal,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              streetAddVal,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _index = 0;
                            });
                          },
                          child: const SizedBox(
                            height: 55.0,
                            width: 50.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.edit_outlined,
                                size: 25.0,
                                color: Color(0xff255C3F),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 0.5,
                  dashLength: 7.0,
                  dashColor: Colors.grey,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 21.0)),
                    Text(widget.amount,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 19.0))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 0.5,
                  dashLength: 7.0,
                  dashColor: Colors.grey,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                SizedBox(
                  height: 90.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff2E5F3B),
                        minimumSize: const Size.fromHeight(65),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _loading = true;
                            });
                            bool addOrder = await databaseService.addToOrders(
                                widget.retrievedItemsList,
                                widget.amount,
                                _messangerKey);
                            if (addOrder == true) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => OrderSuccess(
                                            title: 'SUCCESS',
                                            amount: widget.amount,
                                            retrievedItemsList:
                                                widget.retrievedItemsList,
                                          ))),
                                  (Route<dynamic> route) => route.isFirst);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => OrderSuccess(
                                            title: 'FAILURE',
                                            amount: widget.amount,
                                            retrievedItemsList:
                                                widget.retrievedItemsList,
                                          ))),
                                  (Route<dynamic> route) => route.isFirst);
                            }
                            setState(() {
                              _loading = false;
                            });
                          },
                    child: Text('Place Order'))
              ],
            )
          ],
        ),
        if (_loading)
          const Center(
            child: SpinKitSquareCircle(
              color: Color(0xff2E5F3B),
              size: 100.0,
            ),
          )
      ],
    ));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNum = creditCardModel!.cardNumber;
      expDate = creditCardModel.expiryDate;
      cardName = creditCardModel.cardHolderName;
      cvv = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<void> uploadDataToSharedPreference(String type) async {
    final SharedPreferences prefs = await _prefs;
    if (type == "Address") {
      setState(() {
        countryVal = countryDropdownValue!;
        stateVal = stateDropdownValue!;
        cityVal = cityDropdownValue!;
        streetAddVal = _streetAddressController.text;
        prefs.setString('AddressCountry', countryDropdownValue!);
        prefs.setString('AddressState', stateDropdownValue!);
        prefs.setString('AddressCity', cityDropdownValue!);
        prefs.setString('AddressStreet', _streetAddressController.text);
      });
    } else if (type == "Card") {
      setState(() {
        cardNamVal = cardName;
        cardNumVal = cardNum;
        expVal = expDate;
        cvvVal = cvv;
        prefs.setString('CardHolderName', cardName);
        prefs.setString('CardNumber', cardNum);
        prefs.setString('CardExpiry', expDate);
        prefs.setString('CardCvv', cvv);
      });
    }
  }

  Future<String> checkIfDataExist() async {
    String cardNumberText = '',
        cardexpiryDateText = '',
        cardHolderNameText = '',
        cardcvvCodeText = '';
    String addressCountry = '',
        addressState = '',
        addressCity = '',
        addressStreet = '';

    final SharedPreferences prefs = await _prefs;
    addressCountry = prefs.getString('AddressCountry') ?? "";
    addressState = prefs.getString('AddressState') ?? "";
    addressCity = prefs.getString('AddressCity') ?? "";
    addressStreet = prefs.getString('AddressStreet') ?? "";
    cardHolderNameText = prefs.getString('CardHolderName') ?? "";
    cardNumberText = prefs.getString('CardNumber') ?? "";
    cardexpiryDateText = prefs.getString('CardExpiry') ?? "";
    cardcvvCodeText = prefs.getString('CardCvv') ?? "";

    if (addressCountry != "" &&
        addressState != "" &&
        addressCity != "" &&
        addressStreet != "" &&
        cardHolderNameText != "" &&
        cardNumberText != "" &&
        cardexpiryDateText != "" &&
        cardcvvCodeText != "") {
      setState(() {
        countryVal = addressCountry;
        stateVal = addressState;
        cityVal = addressCity;
        streetAddVal = addressStreet;
        cardNamVal = cardHolderNameText;
        cardNumVal = cardNumberText;
        expVal = cardexpiryDateText;
        cvvVal = cardcvvCodeText;

        countryDropdownValue = addressCountry;
        stateDropdownValue = addressState;
        cityDropdownValue = addressCity;
        _streetAddressController.text = addressStreet;
        cardName = cardHolderNameText;
        cardNum = cardNumberText;
        expDate = cardexpiryDateText;
        cvv = cardcvvCodeText;

        addressBtnText = 'EDIT ADDRESS';
        paymentBtnTex = 'EDIT PAYMENT';
        addressBtnColor = Color(0xff7BBE8C);
        paymentBtnColor = Color(0xff7BBE8C);

        _index = 2;
      });
      return "Forms Completed";
    } else if (addressCountry != "" &&
        addressState != "" &&
        addressCity != "" &&
        addressStreet != "" &&
        cardHolderNameText == "" &&
        cardNumberText == "" &&
        cardexpiryDateText == "" &&
        cardcvvCodeText == "") {
      setState(() {
        countryVal = addressCountry;
        stateVal = addressState;
        cityVal = addressCity;
        streetAddVal = addressStreet;

        countryDropdownValue = addressCountry;
        stateDropdownValue = addressState;
        cityDropdownValue = addressCity;
        _streetAddressController.text = addressStreet;
        addressBtnText = 'EDIT ADDRESS';
        addressBtnColor = Color(0xff7BBE8C);
        _index = 1;
      });
      return "Address Completed";
    }
    return '';
  }
}
