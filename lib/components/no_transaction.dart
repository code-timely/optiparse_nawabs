import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Notransaction extends StatelessWidget {

  const Notransaction({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Choose a suitable background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation for processing
              Lottie.asset(
                'assets/Home.json',
                width: 150,
                height: 150,
              ),
              // Space between animation and text
              // Descriptive text
              Text(
                'No Transactions!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              // Space between text and progress message
              // Progress message or tagline
              Text(
                'Update your first transaction by clicking the button below',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
