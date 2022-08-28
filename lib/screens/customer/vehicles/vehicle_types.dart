import 'package:flutter/material.dart';

class VehicleTypeScreen extends StatelessWidget {
  const VehicleTypeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Vehicle"),
      ),
      body: Column(
        children: [
          VehicleTypeContainer(
            title: "Vehicle Type",
            image: "assets/images/bike.png",
            onTab: () {},
          ),
          VehicleTypeContainer(
            title: "Vehicle Type",
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
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        height: 80,

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
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("Model 2022"),
                  SizedBox(height: 5),
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
                scale: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
