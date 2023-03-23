import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

const List<String> list = <String>['Nigeria', 'Zimbabwe', 'Ghana', 'Togo'];

class _AddressPageState extends State<AddressPage> {
  int _index = 0;
  String dropdownValue = list.first;
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
                              height: 7.0,
                            ),
                            Container(
                              height: 65.0,
                              child: FormField(
                                  builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 1.5, color: Color(0xff1B3823)),
                                    ),
                                    hintText: 'Nigeria',
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 0, 0.0, 0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
