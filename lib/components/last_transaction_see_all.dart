import 'package:flutter/material.dart';
import 'package:optiparse_nawabs/screens/searchpage.dart';
// import 'package:responsive_flutter/responsive_flutter.dart';

class LastTseeAll extends StatelessWidget {
  const LastTseeAll({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          const Text(
            "Last Transactions",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              // fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
              fontSize: 23,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Text(
              "See All",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                // fontSize: ResponsiveFlutter.of(context).fontSize(1.725),
                fontSize: 17.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
