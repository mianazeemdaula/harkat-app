import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';

class Earning {
  final String day;
  final int amount;
  final charts.Color color;

  Earning(this.day, this.amount, this.color);
}

class EarningScreen extends StatelessWidget {
  List<Earning> data = [
    Earning("M", 250, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("T", 230, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("W", 320, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("T", 280, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("F", 150, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("S", 175, charts.ColorUtil.fromDartColor(kPrimaryColor)),
    Earning("S", 287, charts.ColorUtil.fromDartColor(kPrimaryColor)),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Earning, String>> series = [
      charts.Series(
        id: "Earnings",
        data: data,
        domainFn: (Earning earning, _) => earning.day,
        measureFn: (Earning earning, _) => earning.amount,
        colorFn: (Earning earning, _) => earning.color,
      ),
    ];
    return Container(
      color: kPrimaryColor,
      padding: EdgeInsets.all(getUiWidth(15)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(getUiWidth(10)),
            ),
            padding: EdgeInsets.all(getUiHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "earning_current_balance".tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "152.25\$",
                      style: Theme.of(context).textTheme.headline4,
                    )
                  ],
                ),
                RaisedButton(
                  onPressed: () {},
                  color: kPrimaryColor,
                  elevation: 10.0,
                  child: Text(
                    "earning_withdraw".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: getUiHeight(20)),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(getUiWidth(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(getUiWidth(10)),
              ),
              child: charts.BarChart(
                series,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
