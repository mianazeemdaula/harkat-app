import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    Key key,
    this.onTap,
    this.index,
  }) : super(key: key);

  final Function onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getUiHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: index == 0 ? kPrimaryColor : Colors.black,
              ),
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: Icon(Icons.graphic_eq),
              color: index == 1 ? kPrimaryColor : Colors.black,
              onPressed: () => onTap(1),
            ),
            IconButton(
              icon: Icon(Icons.assessment),
              color: index == 2 ? kPrimaryColor : Colors.black,
              onPressed: () => onTap(2),
            )
          ],
        ),
      ),
    );
  }
}
