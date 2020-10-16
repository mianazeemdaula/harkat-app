import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

class DriverAvailabeSwith extends StatelessWidget {
  final String textOn;
  final String textOff;

  const DriverAvailabeSwith({Key key, this.textOn, this.textOff})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getUiHeight(45),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LiteRollingSwitch(
          textOn: textOn,
          textOff: textOff,
          colorOn: Colors.blue,
          colorOff: kPrimaryColor,
          iconOn: Icons.directions_car,
          iconOff: Icons.do_not_disturb_off,
          onChanged: (bool value) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(context.read<UserRepository>().user.uid)
                .update(
              {'online': value},
            );
          },
        ),
      ),
    );
  }
}
