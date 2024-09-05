import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optiparse_nawabs/components/bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication); 
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('We are the Hall 5'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(1),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/nawabs.jpg'), // Ensure this path is correct
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nawabs',
                        style: GoogleFonts.protestGuerrilla(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child:Center(
                  child: Text(
                     'Hall 5 ka tempo high hai!!',
                          style: GoogleFonts.luckiestGuy(
                            color:Colors.red,
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                          ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
