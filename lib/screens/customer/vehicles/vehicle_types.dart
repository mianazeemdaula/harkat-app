import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleTypeScreen extends StatelessWidget {
  const VehicleTypeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select_vehicle".tr),
      ),
      body: Column(
        children: [
          VehicleTypeContainer(
            title: "bike".tr,
            image: "assets/images/bike.png",
            onTab: () {},
          ),
          VehicleTypeContainer(
            title: "van".tr,
            image: "assets/images/van.png",
            onTab: () {},
          ),
        ],
      ),
    );
  }
}

class VehicleTypeContainer extends StatelessWidget {
  const VehicleTypeContainer({
    Key key,
    this.title,
    this.image,
    this.onTab,
    this.rating,
    this.model,
  }) : super(key: key);

  final String title;
  final String image;
  final String rating;
  final String model;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: 90,

        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 5),
                  Text("model".tr),
                  // SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border_outlined),
                      SizedBox(width: 5),
                      Text(
                        ("4.5"),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                image,
                scale: 1.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
