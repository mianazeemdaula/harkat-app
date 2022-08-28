import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/customer/deals/deal_view.dart';
import 'package:harkat_app/size_config.dart';

class UserTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.updateLocale(Locale('en', 'US'));
                    },
                    child: Text("English"),
                  ),
                  TextButton(
                    child: Text("عربی"),
                    onPressed: () {
                      Get.updateLocale(Locale('ar', 'AE'));
                    },
                  )
                ],
              ),
              SizedBox(height: 10),
              Spacer(),
              // Text(
              //   "Select option to continue",
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              SizedBox(height: getUiHeight(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DriverAndUserBtn(
                    icon: Icons.person,
                    text: "continue_as_driver_btn".tr,
                    onTab: () => Navigator.pushNamed(context, '/signin'),
                  ),
                  // SizedBox(
                  //   width: getUiWidth(50),
                  // ),
                  DriverAndUserBtn(
                    icon: Icons.directions_car,
                    text: "make_delivery_btn".tr,
                    onTab: () => Get.to(() => DealView()),
                  ),
                ],
              ),
              SizedBox(height: getUiHeight(30)),
              // DefaultButton(
              //   text: "continue_as_driver_btn".tr,
              //   press: () => Navigator.pushNamed(context, '/signin'),
              // ),
              // SizedBox(height: getUiHeight(10)),
              // DefaultButton(
              //   color: kSecondaryColor,
              //   text: "make_delivery_btn".tr,
              //   press: () => Navigator.pushNamed(context, '/signup'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverAndUserBtn extends StatelessWidget {
  const DriverAndUserBtn({
    Key key,
    this.icon,
    this.text,
    this.onTab,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
          alignment: Alignment.center,
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kSecondaryColor.withOpacity(0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    text,
                    style: TextStyle(
                      // decoration: TextDecoration.lineThrough,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
