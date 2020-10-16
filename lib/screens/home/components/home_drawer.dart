import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("${user.user.displayName ?? ""}"),
            accountEmail: Text("${user.user.email}"),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getUiWidth(250)),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(
                    "https://ui-avatars.com/api/?name=Elon+Musk",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("change_password_lbl".tr()),
            trailing: Icon(Icons.lock_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/changepassword');
            },
          ),
          ListTile(
            title: Text("suggestion_drawer".tr()),
            trailing: Icon(Icons.help_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/suggestion');
            },
          ),
          ListTile(
            title: Text("logout_lbl".tr()),
            trailing: Icon(Icons.exit_to_app),
            onTap: () =>
                Provider.of<UserRepository>(context, listen: false).signOut(),
          ),
          Divider(),
          ListTile(
            title: Text('language'.tr()),
            trailing: Switch(
              value: context.locale.languageCode.toString() == 'en',
              onChanged: (bool) {
                context.locale = context.locale.languageCode == 'en'
                    ? Locale('ar', 'AE')
                    : Locale('en', 'US');
              },
            ),
          )
        ],
      ),
    );
  }
}
