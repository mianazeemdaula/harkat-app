import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class WalletStatementView extends StatelessWidget {
  WalletStatementView({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wallet History"),
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
              ],
            ),
            SizedBox(height: getUiHeight(50)),
            Text(
              "Statement",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  .copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2, color: kPrimaryColor),
            Row(
              children: [
                Text(
                  "Today",
                  style: Theme.of(context).textTheme.bodyLarge.copyWith(
                      color: kSecondaryColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: getUiWidth(90)),
                Text(
                  DateTime.now().toString().substring(0, 10),
                  style: Theme.of(context).textTheme.bodyLarge.copyWith(
                      color: kSecondaryColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: getUiHeight(10),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  .copyWith(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Bnak Card",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              "+2500.0 AED",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  .copyWith(
                                      color: kGreenColor,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
