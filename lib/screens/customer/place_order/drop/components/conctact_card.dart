import 'package:flutter/material.dart';
import 'package:harkat_app/providers/map_location_provider.dart';
import 'package:harkat_app/providers/pick_drop_order_prodiver.dart';
import 'package:harkat_app/screens/customer/place_order/confirm/order_confirm_screen.dart';
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
                  labelText: "Receiver's Name",
                ),
                validator: (String value) {
                  if (value.isEmpty) return "Please enter receiver's name";
                  return null;
                },
              ),
              SizedBox(
                height: getUiHeight(10),
              ),
              TextFormField(
                controller: _contactTextController,
                decoration: InputDecoration(
                  labelText: "Receiver's Contact",
                ),
                validator: (String value) {
                  if (value.isEmpty) return "Please enter receiver's contact";
                  return null;
                },
              ),
              SizedBox(
                height: getUiHeight(10),
              ),
              DefaultButton(
                text: "Confirm",
                press: () {
                  try {
                    if (_formKey.currentState.validate()) {
                      Provider.of<PickDropOrderProvider>(context, listen: false)
                          .setDrop(
                        mapLocationProvider.addressFromGeoCode,
                        _nameTextController.text,
                        _contactTextController.text,
                      );
                    }
                  } catch (e) {}
                  Route route =
                      MaterialPageRoute(builder: (_) => OrderConfirmScreen());
                  Navigator.push(context, route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
