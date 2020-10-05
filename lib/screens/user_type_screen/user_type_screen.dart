import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class UserTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: getUiWidth(250),
              width: getUiHeight(250),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            Spacer(),
            Text(
              "Select option to continue",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: getUiHeight(10)),
            DefaultButton(
              text: "CONTINUE AS DRIVER",
              press: () => Navigator.pushNamed(context, '/signin'),
            ),
            SizedBox(height: getUiHeight(10)),
            DefaultButton(
              color: kSecondaryColor,
              text: "MAKE DELIVERY ORDER",
              press: () => Navigator.pushNamed(context, '/signup'),
            ),
          ],
        ),
      ),
    );
  }
}
