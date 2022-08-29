import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:get/get.dart';

class FindTheDealView extends StatelessWidget {
  FindTheDealView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Column(
            children: [
              Text(
                "Find_The_Ideal".tr,
                style: Theme.of(context).textTheme.headline3.copyWith(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              const SizedBox(height: 10),
              Text("Delivery_Services_For_You".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: kSecondaryColor)),
              const SizedBox(height: 30),
              Image.asset(
                "assets/images/deal.png",
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              Text(
                "description".tr,
                textScaleFactor: 1,
              ),
              Spacer(),
              DefaultButton(
                text: "get_started".tr,
                press: () => Navigator.pushNamed(context, '/signin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
