import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/customer/paymet_methods/card_paymet.dart';
import 'package:harkat_app/screens/customer/place_order/confirm/components/pay_by_form.dart';
import 'package:harkat_app/screens/wallet/driver_wallet.dart';
import 'package:harkat_app/widgets/default_button.dart';

class PaymetTypesView extends StatelessWidget {
  const PaymetTypesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "cash".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kPrimaryColor),
                ),
                SizedBox(width: 80),
                Expanded(child: PayByForm()),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "card".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kPrimaryColor),
                ),
                DefaultButton(
                  btnwidth: 120,
                  text: "cradit_card".tr,
                  color: kPrimaryColor,
                  press: () {
                    Get.to(() => CardPaymetScreen());
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "wallet".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kPrimaryColor),
                ),
                SizedBox(width: 10),
                DefaultButton(
                  btnwidth: 120,
                  text: "wallet".tr,
                  color: kPrimaryColor,
                  press: () {
                    Get.to(() => DriverWalletView());
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
