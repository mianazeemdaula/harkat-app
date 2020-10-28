import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PayByForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      attribute: 'pay_by',
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
      validators: [
        FormBuilderValidators.required(),
      ],
    );
  }
}
