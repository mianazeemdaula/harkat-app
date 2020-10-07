import 'package:flutter/material.dart';

class LocationError extends StatelessWidget {
  const LocationError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text("builder of locaiton service"),
        ),
      ),
    );
  }
}
