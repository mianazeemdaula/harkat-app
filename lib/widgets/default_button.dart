import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.btnwidth = 200,
  }) : super(key: key);
  final String text;
  final Function press;
  final Color color;
  final double btnwidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: btnwidth,
      height: getUiHeight(45),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getUiWidth(30)),
        ),
        color: color,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getUiWidth(15),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
