import 'package:flutter/material.dart';
import 'package:optiparse_nawabs/components/column_info.dart';

class Dashboard extends StatelessWidget {
  final double income;
  final double expenses;
  final double balance;

  const Dashboard({
    super.key,
    required this.income,
    required this.expenses,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Get the current orientation
    Orientation orientation = MediaQuery.of(context).orientation;
    // Check if the orientation is portrait
    bool isPortrait = orientation == Orientation.portrait;
    return Stack(
      children: [
        Positioned(
          bottom: isPortrait ? 0 : null,
          top: isPortrait ? null : size.height * 0.25,
          left: isPortrait ? 25 : 50,
          width: isPortrait ? size.width - 50 : size.width / 2 - 50,
          child: Container(
            height: isPortrait ? size.height * 0.25 : size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/imag/bg.png"),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Total Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '₹  ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 50,
                        ),
                      ),
                      TextSpan(
                        text: balance.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 51.75,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: isPortrait ? size.height * 0.1 : size.height * 0.2,
                  width: isPortrait ? size.width - 100 : size.width / 2 - 100,
                  decoration: BoxDecoration(
                    color: Color(0xff5400BE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ColumnInfo(
                        iconColor: Colors.greenAccent[400]!,
                        iconData: Icons.arrow_downward,
                        text: "Income",
                        value: income.toStringAsFixed(2),
                      ),
                      Container(
                        height: size.height * 0.09,
                        width: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      ColumnInfo(
                        iconColor: Colors.redAccent[400]!,
                        iconData: Icons.arrow_upward,
                        text: "Expenses",
                        value: expenses.toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
