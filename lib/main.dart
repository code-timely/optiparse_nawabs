import 'package:flutter/material.dart';
import 'package:optiparse_nawabs/screens/homepage.dart';
import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';

void main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  await initializeObjectBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OptiParse',
      // theme: ThemeData(
      //   primarySwatch: Colors.red,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: HomePage(),
    );
  }
}
