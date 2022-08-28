import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/customer/paymet_methods/paymet_view.dart';
import 'package:harkat_app/screens/wallet/driver_expense.dart';
import 'package:harkat_app/screens/wallet/driver_wallet.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar =
        "https://thumbs.dreamstime.com/b/vector-illustration-avatar-dummy-logo-set-image-stock-isolated-object-icon-collection-137161298.jpg";
    final user = Provider.of<UserRepository>(context);
    return Drawer(
      // shape: Shape,
      // width: double.infinity,
      // backgroundColor: kPrimaryColor,
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: ListTile(
              title: Text("${user.user.displayName ?? ""}"),
              subtitle: Text("${user.user.email}"),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(avatar),
              ),
              trailing: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 28,
                    color: Colors.black,
                  ),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "1",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // UserAccountsDrawerHeader(
          //   accountName: Text("${user.user.displayName ?? ""}"),
          //   accountEmail: Text("${user.user.email}"),
          //   currentAccountPicture: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(getUiWidth(250)),
          //       image: DecorationImage(
          //         fit: BoxFit.contain,
          //         image: CachedNetworkImageProvider(
          //           "https://ui-avatars.com/api/?name=Elon+Musk",
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ListTile(
            title: Text("change_password_lbl".tr),
            leading: Icon(Icons.lock_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/changepassword');
            },
          ),
          ListTile(
            title: Text("suggestion_drawer".tr),
            leading: Icon(Icons.help_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/suggestion');
            },
          ),
          user.userType == 'driver'
              ? ListTile(
                  title: Text("drawer_submit_money".tr),
                  leading: Icon(Icons.monetization_on),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/submitmoney');
                  },
                )
              : Container(),
          ListTile(
            title: Text('language'.tr),
            leading: Icon(Icons.language),
            trailing: Switch(
              value: Get.locale.languageCode == 'en',
              onChanged: (bool) {
                Get.updateLocale(Get.locale.languageCode == 'en'
                    ? Locale('ar', 'AE')
                    : Locale('en', 'US'));
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.wallet),
            title: Text("wallet".tr),
            onTap: () {
              Get.to(() => DriverWalletView());
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money_outlined),
            title: Text("payment".tr),
            onTap: () {
              Get.to(() => PaymetTypesView());
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text("expenses".tr),
            onTap: () {
              Get.to(() => DriverExpenseView());
            },
          ),
          ListTile(
            title: Text("contact_lbl".tr),
            leading: Icon(Icons.contact_phone),
            onTap: () async {
              String url, message = "Hi", phone = "+971503664195";
              if (Platform.isAndroid) {
                url = "https://wa.me/$phone/?text=$message";
              } else {
                url = "https://api.whatsapp.com/send?phone=$phone=$message";
              }
              print(url);
              if (await canLaunch(url)) {
                launch(url);
              } else {
                print('not launch');
              }
              Get.back();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("logout_lbl".tr),
            trailing: Icon(Icons.exit_to_app),
            onTap: () =>
                Provider.of<UserRepository>(context, listen: false).signOut(),
          ),
        ],
      ),
    );
  }
}
