import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/wallet/driver_wallet.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Earning {
  final String day;
  final int amount;
  final charts.Color color;

  Earning(this.day, this.amount, this.color);
}

class EarningScreen extends StatelessWidget {
  List<_SalesData> chartdata = [
    _SalesData('sun'.tr, 35),
    _SalesData('mon'.tr, 28),
    _SalesData('tus'.tr, 34),
    _SalesData('wed'.tr, 30),
    _SalesData('thr'.tr, 34),
    _SalesData('fri'.tr, 30),
    _SalesData('sath'.tr, 35),
  ];
  List<Earning> data = [
    Earning("M", 250, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("T", 230, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("W", 320, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("T", 280, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("F", 150, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("S", 175, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("S", 287, charts.ColorUtil.fromDartColor(kPrimaryColor)),
  ];

  final String userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // color: kPrimaryColor,
        padding: EdgeInsets.all(getUiWidth(15)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(getUiWidth(10)),
              ),
              padding: EdgeInsets.all(getUiHeight(20)),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "earning_current_balance".tr,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "${snapshot.data.data()['balance'] ?? '0'}AED",
                              style: Theme.of(context).textTheme.headline4,
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => DriverWalletView());
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            elevation: 10.0,
                          ),
                          child: Text(
                            "earning_withdraw".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    );
                  }),
            ),
            SizedBox(height: getUiHeight(20)),
            Expanded(
              child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'current_yearly_sales_graph'.tr),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: chartdata,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'sales'.tr,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
