import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/helpers/data.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: Get.locale.languageCode == 'en' ? englishTerms : arabicTerms,
        ),
      ),
    );
  }
}
