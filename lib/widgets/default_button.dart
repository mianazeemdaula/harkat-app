import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
  }) : super(key: key);
  final String text;
  final Function press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getUiHeight(45),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getUiWidth(5)),
        ),
        color: color,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getUiWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
