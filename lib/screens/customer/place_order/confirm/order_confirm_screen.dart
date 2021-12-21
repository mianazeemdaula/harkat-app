import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/pick_drop_order_prodiver.dart';
import 'package:harkat_app/screens/customer/place_order/confirm/components/credit_card_form.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'components/pay_by_form.dart';

class OrderConfirmScreen extends StatefulWidget {
  @override
  _OrderConfirmScreenState createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  bool isCashPaymentType = true;
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: context
            .select<PickDropOrderProvider, bool>((value) => value.isUiBusy),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            child: Container(
              padding: EdgeInsets.all(getUiWidth(20)),
              child: Consumer<PickDropOrderProvider>(
                builder: (context, value, child) {
                  return FutureBuilder<bool>(
                    future: value.buildRouteAndPrice(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(height: getUiHeight(15)),
                          AddressCard(
                            addres: value.pickUpAddress.formattedAddress,
                            name: value.senderName,
                            contact: value.senderContact,
                          ),
                          SizedBox(height: getUiHeight(5)),
                          Icon(Icons.arrow_downward),
                          SizedBox(height: getUiHeight(5)),
                          AddressCard(
                            addres: value.dropAddress.formattedAddress,
                            name: value.receiverName,
                            contact: value.receiverContact,
                          ),
                          SizedBox(height: getUiHeight(15)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.drive_eta,
                                  size: getUiHeight(30),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${value.mapData['routes'][0]['legs'][0]['distance']['text'] ?? ""}",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.access_time,
                                  size: getUiHeight(30),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${value.mapData['routes'][0]['legs'][0]['duration']['text']}",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.attach_money_outlined,
                                  size: getUiHeight(30),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${deliveryPrice(value.mapData['routes'][0]['legs'][0]['distance']['value'] / 1000)}",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: getUiHeight(20)),
                          FormBuilderDropdown(
                            name: 'payment_type',
                            initialValue: 'cash',
                            items: [
                              DropdownMenuItem(
                                child: Text('Cash'),
                                value: 'cash',
                              ),
                              DropdownMenuItem(
                                child: Text('Credit Card'),
                                value: 'credit_card',
                              ),
                            ],
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            onChanged: (value) {
                              setState(() {
                                isCashPaymentType =
                                    value == 'cash' ? true : false;
                              });
                            },
                          ),
                          SizedBox(height: getUiHeight(10)),
                          isCashPaymentType ? PayByForm() : CreditCardForm(),
                          SizedBox(height: getUiHeight(10)),
                          DefaultButton(
                            press: () async {
                              try {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  await context
                                      .read<PickDropOrderProvider>()
                                      .placeOrder(
                                        _fbKey.currentState.value,
                                        amount,
                                      );
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Get.snackbar(
                                      "Success", "Order place successfully",
                                      backgroundColor:
                                          kPrimaryColor.withOpacity(0.5),
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              } catch (e) {
                                Get.snackbar("Error", "$e",
                                    backgroundColor:
                                        Colors.red.withOpacity(0.5),
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            text: "Confirm Order",
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String deliveryPrice(double value) {
    if (value < 20) {
      amount = 17;
      return "17 AED";
    } else if (value >= 20 && value <= 30) {
      amount = 18;
      return "18 AED";
    } else if (value > 30 && value <= 40) {
      amount = 19;
      return "19 AED";
    } else if (value > 40 && value <= 50) {
      amount = 20;
      return "20 AED";
    }
    amount = 30;
    return "30 AED";
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod(
      {Key key, this.onTap, this.title, this.icon, this.selected})
      : super(key: key);

  final Function onTap;
  final String title;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: getUiWidth(120),
        padding: EdgeInsets.all(getUiHeight(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getUiWidth(10)),
          color: selected
              ? kPrimaryColor.withOpacity(0.4)
              : kPrimaryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: getUiHeight(5)),
            Text("$title"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({Key key, this.addres, this.contact, this.name})
      : super(key: key);

  final String addres;
  final String name;
  final String contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getUiHeight(10)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(getUiWidth(10)),
      ),
      child: Column(
        children: [
          Text(
            "$addres",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          Text(
            "$name",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "$contact",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
