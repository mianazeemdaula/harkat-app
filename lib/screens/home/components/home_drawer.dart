import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Alhabib"),
            accountEmail: Text("alhabib@gmail.com"),
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
            title: Text(context.locale.languageCode.toString()),
            trailing: Switch(
              value: context.locale.languageCode.toString() == 'en',
              onChanged: (bool) {
                context.locale = context.locale.languageCode == 'en'
                    ? Locale('ar', 'AE')
                    : Locale('en', 'US');
              },
            ),
          ),
        ],
      ),
    );
  }
}
