import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Nosearch extends StatelessWidget {

  const Nosearch({super.key});
  
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
                'assets/search.json',
                width: 100,
                height: 100,
              ),
             
              Text(
                'No Transactions Found!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              // Space between text and progress message
              // Progress message or tagline
             
            ],
          ),
        ),
      ),
    );
  }
}
