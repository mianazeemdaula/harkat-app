import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class NewOrderCard extends StatelessWidget {
  const NewOrderCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(getUiWidth(15)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: getUiWidth(60),
                  height: getUiWidth(60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(250),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl:
                          "https://randomuser.me/api/portraits/men/97.jpg",
                    ),
                  ),
                ),
                SizedBox(width: getUiWidth(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "new_order".tr(),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      "Mohamed Bin Zayed City - Abu Dhabi",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_downward,
                        size: getUiWidth(12),
                      ),
                    ),
                    Text(
                      "Disease Prevention & Screening Center",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {},
                color: Colors.blue,
                elevation: 0.0,
                child: Text(
                  "acceptbtn".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {},
                elevation: 0.0,
                color: Colors.transparent,
                child: Text("rejectbtn".tr()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
