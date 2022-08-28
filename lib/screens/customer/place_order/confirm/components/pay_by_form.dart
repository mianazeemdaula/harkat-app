import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

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
      initialValue: "pay_by_sender".tr,
      items: [
        DropdownMenuItem(
          child: Text("pay_by_sender".tr),
          value: 'pay_by_sender'.tr,
        ),
        DropdownMenuItem(
          child: Text("pay_by_receiver".tr),
          value: 'pay_by_receiver'.tr,
        )
      ],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }
}
