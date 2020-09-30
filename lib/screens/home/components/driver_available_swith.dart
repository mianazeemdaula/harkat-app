import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

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
          colorOn: kPrimaryColor,
          colorOff: Colors.red,
          iconOn: Icons.directions_car,
          iconOff: Icons.do_not_disturb_off,
          onChanged: (bool) {},
        ),
      ),
    );
  }
}
