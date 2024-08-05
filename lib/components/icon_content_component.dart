import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_care/shared/constants.dart';

class IconContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconContent({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizedBoxSizeWidth = MediaQuery.of(context).size.width;
    double sizedBoxSizeHeigth = MediaQuery.of(context).size.width * 0.25;

    if (MediaQuery.of(context).size.width > 1000) {
      sizedBoxSizeWidth = MediaQuery.of(context).size.width * 0.5;
      sizedBoxSizeHeigth = MediaQuery.of(context).size.width * 0.2;
    }

    return SizedBox(
      width: sizedBoxSizeWidth,
      height: sizedBoxSizeHeigth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              Icon(
                icon,
                size: 50.0,
                color: const Color.fromARGB(255, 175, 164, 160),
              ),
              SizedBox(width: 20,),
              Text(label, style: kLabelTextStyle)
            ],
          ),
        ],
      ),
    );
  }
}
