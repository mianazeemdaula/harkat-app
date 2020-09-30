import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';

class RejectOrderScreen extends StatefulWidget {
  @override
  _RejectOrderScreenState createState() => _RejectOrderScreenState();
}

class _RejectOrderScreenState extends State<RejectOrderScreen> {
  List<String> _rejectStatusList = [
    "Not Working",
    "Run of Gas",
    "Accident",
    "Mechanic",
    "Issue",
    "Out of Service",
    "Fully Booked"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reject Order", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Center(
              child: Text(
                "Are you confirm?",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${_rejectStatusList[index]}"),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _rejectStatusList.length,
            ),
          )
        ],
      ),
    );
  }
}
