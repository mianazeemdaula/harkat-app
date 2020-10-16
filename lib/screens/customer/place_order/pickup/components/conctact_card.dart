import 'package:flutter/material.dart';
import 'package:harkat_app/screens/customer/place_order/drop/drop_address.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class ContactCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameTextController;
  final TextEditingController contactTextController;
  final Function onTap;
  const ContactCard({
    Key key,
    this.formKey,
    this.nameTextController,
    this.contactTextController,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: getUiHeight(10),
      left: getUiWidth(10),
      right: getUiWidth(10),
      child: Form(
        key: formKey,
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
                controller: nameTextController,
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
                controller: contactTextController,
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
                press: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
