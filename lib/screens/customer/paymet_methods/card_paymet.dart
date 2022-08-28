import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class CardPaymetScreen extends StatelessWidget {
  CardPaymetScreen({Key key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final cvcController = TextEditingController();
  final priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Paymet"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                'assets/images/card.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                      ),
                      SizedBox(height: getUiHeight(10)),
                      TextFormField(
                        controller: cardNumberController,
                        decoration: InputDecoration(
                          hintText: "Card Number",
                        ),
                      ),
                      SizedBox(height: getUiHeight(10)),
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: "12/14",
                        ),
                      ),
                      SizedBox(height: getUiHeight(10)),
                      TextFormField(
                        controller: cvcController,
                        decoration: InputDecoration(
                          hintText: "CSV",
                        ),
                      ),
                      SizedBox(height: getUiHeight(10)),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: "Total Paymet",
                        ),
                      ),
                      SizedBox(height: getUiHeight(50)),
                      DefaultButton(
                        text: "PAY NOW",
                        color: kPrimaryColor,
                        press: () {
                          if (_formkey.currentState.validate()) {
                            kSuccessSnakbar("Paymet Done");
                          }
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
