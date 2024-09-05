import 'package:flutter/material.dart';
// import 'package:responsive_flutter/responsive_flutter.dart';

class ColumnInfo extends StatelessWidget {
  final IconData iconData;
  final String text, value;
  final Color iconColor;

  const ColumnInfo({
    required this.iconColor,
    required this.iconData,
    required this.text,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                iconData,
                // size: ResponsiveFlutter.of(context).fontSize(2.2),
                size: 2.2,
                color: iconColor,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                // fontSize: ResponsiveFlutter.of(context).fontSize(1.84),
                fontSize: 18.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              // fontSize: ResponsiveFlutter.of(context).fontSize(2.53)
              fontSize: 25.3,
            ),
          ),
        )
      ],
    );
  }
}
