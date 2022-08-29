import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/customer/deals/deal_view.dart';
import 'package:harkat_app/size_config.dart';

class UserTypeScreen extends StatefulWidget {
  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  bool language = false;
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         Get.updateLocale(
              //           Locale('en', 'US'),
              //         );
              //       },
              //       child: Text("English"),
              //     ),
              //     TextButton(
              //       child: Text("عربی"),
              //       onPressed: () {
              //         Get.updateLocale(Locale('ar', 'AE'));
              //       },
              //     )
              //   ],
              // ),
              SizedBox(height: 10),

              SizedBox(height: getUiHeight(10)), // Text(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (language == false) {
                        Get.updateLocale(Locale('ar', 'AE'));
                        language = true;
                      } else {
                        Get.updateLocale(Locale('en', 'US'));
                        language = false;
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  language ? Text("عربی") : Text("English"),
                  // Text("English"),
                  IconButton(
                      onPressed: () {
                        if (language == false) {
                          Get.updateLocale(Locale('ar', 'AE'));
                          language = true;
                        } else {
                          Get.updateLocale(Locale('en', 'US'));
                          language = false;
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      ))
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: DriverAndUserBtn(
                      icon: Icons.person,
                      text: "make_delivery_btn".tr,
                      onTab: () => Get.to(() => FindTheDealView()),
                    ),
                  ),
                  SizedBox(
                    width: getUiWidth(30),
                  ),
                  Expanded(
                    child: DriverAndUserBtn(
                      icon: Icons.directions_car,
                      text: "continue_as_driver_btn".tr,
                      onTab: () =>
                          Navigator.pushReplacementNamed(context, '/signin'),
                    ),
                  )
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
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
