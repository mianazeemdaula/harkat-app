import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/wallet/wallet_statement.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class DriverExpenseView extends StatelessWidget {
  DriverExpenseView({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController expenseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Expenses"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Available Balance",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  .copyWith(color: kSecondaryColor),
            ),
            SizedBox(height: getUiHeight(20)),
            Row(
              children: [
                Text(
                  "25.500.00",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(width: getUiWidth(5)),
                Text(
                  "AED",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      .copyWith(color: kPrimaryColor),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Get.to(() => WalletStatementView());
                  },
                  child: Text(
                    "History",
                    style: Theme.of(context).textTheme.bodyLarge.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(height: getUiHeight(30)),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Enter Amount";
                        else if (value.length < 1)
                          return 'Entered Amount Is Too Short ';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: getUiHeight(10),
                    ),
                    TextFormField(
                      controller: expenseController,
                      decoration: InputDecoration(
                        hintText: 'Expenses Type',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return "Enter Expenses Type";

                        return null;
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: getUiHeight(50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultButton(
                  text: "Deposit Amount",
                  color: kPrimaryColor,
                  press: () {
                    if (_formKey.currentState.validate()) {
                      kSuccessSnakbar("Amount Deposit Successfully");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
