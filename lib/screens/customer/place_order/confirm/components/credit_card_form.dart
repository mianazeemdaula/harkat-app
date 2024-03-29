import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:harkat_app/size_config.dart';

class CreditCardForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'card',
          decoration: InputDecoration(labelText: "Enter Card Number"),
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.creditCard(),
          ]),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        SizedBox(height: getUiHeight(10)),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FormBuilderTextField(
                name: 'expiry',
                decoration: InputDecoration(labelText: "Expiry"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(5),
                  FormBuilderValidators.match(
                      r"^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})"),
                ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            SizedBox(width: getUiHeight(10)),
            Expanded(
              flex: 1,
              child: FormBuilderTextField(
                name: 'ccv',
                decoration: InputDecoration(labelText: "CCV"),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Required"),
                  FormBuilderValidators.minLength(3),
                  FormBuilderValidators.maxLength(3),
                  FormBuilderValidators.numeric(),
                ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            )
          ],
        )
      ],
    );
  }
}
