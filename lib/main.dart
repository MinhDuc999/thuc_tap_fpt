import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_bang_gia/core/injection.dart' as di;
import 'package:ui_bang_gia/presentations/adjust_page/adjust_page.dart';
import 'package:shared_core/shared_core.dart' as lt;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await lt.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).orientation == Orientation.portrait ? const Size(375, 812) : const Size(812, 375),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AdjustPage(),
        );
      },
    );
  }
}
