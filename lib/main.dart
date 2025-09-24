import 'package:btcat_di_getit/presentations/cat/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'config/injection.dart' as di;

void main() async{
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
