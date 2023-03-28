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
var countryState = {
  'Nigeria': ['Lagos', 'Ogun', 'Oyo', 'Akwa Ibom'],
  'Zimbabwe': ['Bulawayo', 'Harare', 'Manicaland', 'Mashonaland Central'],
  'Ghana': ['Ahafo', 'Ashanti', 'Bono East', 'Brong Ahafo'],
  'South Africa': ['Eastern Cape', 'Gauteng', 'Limpopo', 'Mpumalanga']
};

var nigeriaCity = {
  'Lagos': ['Lagos', 'Ikeja', 'Lekki', 'Okorodu'],
  'Ogun': ['Abokuta', 'Ijebu', 'Odeda', 'Sagamu'],
  'Oyo': ['Ibadan', 'Egbeda', 'Iseyin', 'Iyanaofa'],
  'Akwa Ibom': ['Uyo', 'Abak', 'Ikot Abasi', 'Nsit-Ibom']
};

var zimbabweCity = {
  'Bulawayo': ['Barbourfields', 'Barham Green', 'Beacon Hill', 'Bellevue'],
  'Harare': ['Harare', 'Chitungwiza', 'Epworth', 'Ruwa'],
  'Manicaland': [
    'Buhera District',
    'Chimanimani District',
    'Makoni District',
    'Mutasa District'
  ],
  'Mashonaland Central': ['Bindura', 'Mbire', 'Guruve', 'Rushinga']
};

var ghanaState = {
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
  ]
};

var southAfricaCity = {
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
  int _index = 0;
  String? countryDropdownValue = list.first,
      stateDropdownValue,
      cityDropdownValue = list.first;
  String countryName = "'" + "Nigeria" + "'";
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
                steps: <Step>[
                  Step(
                    state: _index > 0 ? StepState.complete : StepState.indexed,
                    isActive: _index >= 0,
                    title: const Icon(Icons.location_on_outlined),
                    content: Container(
                        alignment: Alignment.centerLeft,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Niger',
                              ),
                              value: countryDropdownValue,
                              onChanged: (String? value) {
                                setState(() {
                                  countryDropdownValue = value!;
                                  countryName =
                                      "'" + countryDropdownValue! + "'";
                                  print(countryName);
                                });
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Lagos',
                              ),
                              value: stateDropdownValue,
                              onChanged: (String? value) {
                                setState(() {
                                  stateDropdownValue = value!;
                                });
                              },
                              items: countryState[countryName]
                                  ?.map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 0, 0),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Lagos',
                              ),
                              value: cityDropdownValue,
                              onChanged: (String? value) {
                                setState(() {
                                  cityDropdownValue = value!;
                                });
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
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
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
