import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

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
  final _formKey = GlobalKey<FormState>(),
      _streetAddressController = TextEditingController();

  int _index = 0;
  String? countryDropdownValue, stateDropdownValue, cityDropdownValue;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              padding: const EdgeInsets.all(20.0),
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
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
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
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            const Text(
                              'ADDRESS',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
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
                                          borderRadius:
                                              BorderRadius.circular(20)
                                                  .copyWith(
                                                      bottomRight:
                                                          Radius.circular(0)),
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
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 0, 0, 0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                          borderRadius:
                                              BorderRadius.circular(20)
                                                  .copyWith(
                                                      bottomRight:
                                                          Radius.circular(0)),
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
                                          ?.map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 0, 0, 0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                          borderRadius:
                                              BorderRadius.circular(20)
                                                  .copyWith(
                                                      bottomRight:
                                                          Radius.circular(0)),
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
                                          ?.map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 0, 0, 0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                      maxLines: 2,
                                      controller: _streetAddressController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.location_city_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText:
                                            'No 12 Block 5 Samson Los Street, Ajadi',
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(200),
                                      ],
                                      keyboardType: TextInputType.streetAddress,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
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
                                    primary: Color(0xff2E5F3B),
                                    minimumSize: const Size.fromHeight(70),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {}
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text('PAYMENT'),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ))
                          ],
                        )),
                  ),
                  Step(
                    state: _index > 1 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 1,
                    title: const Icon(Icons.payment_outlined),
                    content: Text('Content for Step 2'),
                  ),
                  Step(
                    state: _index > 2 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 2,
                    title: const Icon(Icons.shopping_cart_outlined),
                    content: Text('Content for Step 3'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
