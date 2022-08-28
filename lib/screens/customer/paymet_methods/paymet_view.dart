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
                  "Cash",
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
                  "Card",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kPrimaryColor),
                ),
                DefaultButton(
                  btnwidth: 120,
                  text: "Card",
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
                  "Wallet",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kPrimaryColor),
                ),
                SizedBox(width: 10),
                DefaultButton(
                  btnwidth: 120,
                  text: "Wallet",
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
