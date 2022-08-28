import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/helpers/data.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:harkat_app/widgets/default_button.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('terms_and_conditions'.tr),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: Get.locale.languageCode == 'en' ? englishTerms : arabicTerms,
          style: {
            // "colors": Colors.black,
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        child: DefaultButton(
          press: () {
            Navigator.pop(context, true);
          },
          text: 'acceptbtn'.tr,
        ),
      ),
    );
  }
}
