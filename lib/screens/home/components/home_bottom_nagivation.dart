import 'package:flutter/material.dart';
import 'package:harkat_app/size_config.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    Key key,
  }) : super(key: key);

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
                color: Colors.blue,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.graphic_eq),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
