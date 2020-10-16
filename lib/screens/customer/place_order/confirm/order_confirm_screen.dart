import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/pick_drop_order_prodiver.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class OrderConfirmScreen extends StatefulWidget {
  @override
  _OrderConfirmScreenState createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  @override
  void initState() {
    super.initState();
  }

  int paymentType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(getUiWidth(20)),
        width: double.infinity,
        child: Consumer<PickDropOrderProvider>(
          builder: (context, value, child) {
            return FutureBuilder<bool>(
              future: value.buildRouteAndPrice(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: getUiHeight(15)),
                    AddressCard(
                      addres: value.pickUpAddress.formattedAddress,
                      name: value.senderName,
                      contact: value.senderContact,
                    ),
                    SizedBox(height: getUiHeight(5)),
                    Icon(Icons.arrow_downward),
                    SizedBox(height: getUiHeight(5)),
                    AddressCard(
                      addres: value.dropAddress.formattedAddress,
                      name: value.receiverName,
                      contact: value.receiverContact,
                    ),
                    SizedBox(height: getUiHeight(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.drive_eta,
                          size: getUiHeight(50),
                        ),
                        Text(
                          "${value.mapData['routes'][0]['legs'][0]['distance']['text'] ?? ""}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: getUiHeight(50),
                        ),
                        Text(
                          "${value.mapData['routes'][0]['legs'][0]['duration']['text']}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.attach_money_outlined,
                          size: getUiHeight(50),
                        ),
                        Text(
                          "${deliveryPrice(value.mapData['routes'][0]['legs'][0]['distance']['value'] / 1000)}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: getUiHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PaymentMethod(
                          onTap: () {
                            setState(() {
                              paymentType = 0;
                            });
                          },
                          title: "Cash",
                          icon: Icons.payment,
                          selected: paymentType == 0 ? true : false,
                        ),
                        PaymentMethod(
                          onTap: () {
                            setState(() {
                              paymentType = 1;
                            });
                          },
                          title: "Credit Card",
                          icon: Icons.credit_card,
                          selected: paymentType == 1 ? true : false,
                        )
                      ],
                    ),
                    Spacer(),
                    DefaultButton(
                      press: () {},
                      text: "Confirm Pickup",
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String deliveryPrice(double value) {
    if (value < 20) {
      return "17 AED";
    } else if (value >= 20 && value <= 30) {
      return "18 AED";
    } else if (value > 30 && value <= 40) {
      return "19 AED";
    } else if (value > 40 && value <= 50) {
      return "20 AED";
    }
    return "30 AED";
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod(
      {Key key, this.onTap, this.title, this.icon, this.selected})
      : super(key: key);

  final Function onTap;
  final String title;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: getUiWidth(120),
        padding: EdgeInsets.all(getUiHeight(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getUiWidth(10)),
          color: selected
              ? kPrimaryColor.withOpacity(0.4)
              : kPrimaryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: getUiHeight(5)),
            Text("$title"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({Key key, this.addres, this.contact, this.name})
      : super(key: key);

  final String addres;
  final String name;
  final String contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getUiHeight(10)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(getUiWidth(10)),
      ),
      child: Column(
        children: [
          Text(
            "$addres",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          Text(
            "$name",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "$contact",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
