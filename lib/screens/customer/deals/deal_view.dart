import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/widgets/default_button.dart';

class DealView extends StatelessWidget {
  DealView({Key key}) : super(key: key);

  String description =
      'Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundatio Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundatio Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundatio';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Column(
            children: [
              Text(
                "Find The Ideal",
                style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              const SizedBox(height: 10),
              Text(" Delivery Services For You",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kSecondaryColor)),
              const SizedBox(height: 30),
              Image.asset(
                "assets/images/deal.png",
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textScaleFactor: 1,
              ),
              const SizedBox(height: 100),
              DefaultButton(
                text: " Get Started",
                press: () => Navigator.pushNamed(context, '/signin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
