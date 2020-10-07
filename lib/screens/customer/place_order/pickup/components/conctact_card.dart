import 'package:flutter/material.dart';
import 'package:harkat_app/providers/map_location_provider.dart';
import 'package:harkat_app/providers/pick_drop_order_prodiver.dart';
import 'package:harkat_app/screens/customer/place_order/drop/drop_address.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class ContactCard extends StatelessWidget {
  ContactCard({Key key, this.mapLocationProvider}) : super(key: key);

  final MapLocationProvider mapLocationProvider;
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _contactTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: getUiHeight(10),
      left: getUiWidth(10),
      right: getUiWidth(10),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          padding: EdgeInsets.all(getUiWidth(10)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(getUiWidth(8)),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _nameTextController,
                decoration: InputDecoration(
                  labelText: "Sender's Name",
                ),
                validator: (String value) {
                  if (value.isEmpty) return "Please enter sender's name";
                  return null;
                },
              ),
              SizedBox(
                height: getUiHeight(10),
              ),
              TextFormField(
                controller: _contactTextController,
                decoration: InputDecoration(
                  labelText: "Sender's Contact",
                ),
                validator: (String value) {
                  if (value.isEmpty) return "Please enter sender's contact";
                  return null;
                },
              ),
              SizedBox(
                height: getUiHeight(10),
              ),
              DefaultButton(
                text: "Next",
                press: () {
                  if (_formKey.currentState.validate()) {
                    Provider.of<PickDropOrderProvider>(context, listen: false)
                        .setPickup(
                      mapLocationProvider.addressFromGeoCode,
                      _nameTextController.text,
                      _contactTextController.text,
                    );
                    Route route =
                        MaterialPageRoute(builder: (_) => DropAddressScreen());
                    Navigator.push(context, route);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
