import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  hintText: "Receiver's Name",
                  suffixIcon: Icon(Icons.person),
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
                controller: contactTextController,
                decoration: InputDecoration(
                  hintText: "Receiver's Contact",
                  suffixIcon: Icon(Icons.call),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String value) {
                  if (value.isEmpty)
                    return "Please enter receiver's contact";
                  else if (value.length > 11)
                    return "Please enter valid contact";
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
