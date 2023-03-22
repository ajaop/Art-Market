import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  int _index = 0;
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
                        child: const Text('Content for Step 1')),
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
