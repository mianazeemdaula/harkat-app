import 'package:flutter/material.dart';
import 'package:harkat_app/model/address_from_geocode.dart';
import 'package:harkat_app/size_config.dart';

class DropAddressCard extends StatelessWidget {
  const DropAddressCard({Key key, this.address}) : super(key: key);

  final AddressFromGeoCode address;

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
            address == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: Text(
                      "${address.formattedAddress ?? "........"}",
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
