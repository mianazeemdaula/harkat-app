import 'package:flutter/material.dart';
import 'package:harkat_app/providers/map_location_provider.dart';
import 'package:harkat_app/size_config.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({Key key, this.mapLocationProvider}) : super(key: key);

  final MapLocationProvider mapLocationProvider;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: getUiHeight(10),
      left: getUiWidth(10),
      right: getUiWidth(10),
      child: Container(
        padding: EdgeInsets.all(getUiWidth(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(getUiWidth(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mapLocationProvider.addressFromGeoCode == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: Text(
                      "${mapLocationProvider.addressFromGeoCode.formattedAddress ?? "........"}",
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
            SizedBox(width: getUiWidth(10)),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
