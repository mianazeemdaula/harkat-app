// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:get/get.dart';

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
        title: Text("card_paymet".tr),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                'assets/images/card.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "name".tr,
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return "name".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                            hintText: "card_number".tr,
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return "card_number".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: "valid_date".tr,
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return "valid_date".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: cvcController,
                          decoration: InputDecoration(
                            hintText: "CSV",
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return "CVC";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(
                            hintText: "total_payment".tr,
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return "total_payment".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(50)),
                        DefaultButton(
                          text: "pay_now".tr,
                          color: kPrimaryColor,
                          press: () {
                            if (_formkey.currentState.validate()) {
                              kSuccessSnakbar("paymet_done".tr);
                            }
                          },
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
