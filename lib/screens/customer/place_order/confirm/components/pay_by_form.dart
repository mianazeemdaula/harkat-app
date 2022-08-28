import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PayByForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
      ),
      isDense: true,
      name: 'pay_by',
      initialValue: "pay_by_sender",
      items: [
        DropdownMenuItem(
          child: Text("Pay by Sender"),
          value: 'pay_by_sender',
        ),
        DropdownMenuItem(
          child: Text("Pay by Receiver"),
          value: 'pay_by_receiver',
        )
      ],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }
}
