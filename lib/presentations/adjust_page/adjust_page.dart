import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_core/presentations/navigationbar_page.dart';
import 'package:ui_bang_gia/presentations/market_page/market_page.dart';


class AdjustPage extends StatefulWidget {
  const AdjustPage({super.key});

  @override
  State<AdjustPage> createState() => _AdjustPageState();
}



class _AdjustPageState extends State<AdjustPage> {

  @override
  void initState() {
    _screen();
    super.initState();
  }



  void _screen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1A1D1F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBarPage()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF1AAF74),
              ),
              child: Text("Chỉnh thanh điều hướng",
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEFEFEF),
                  height: 1.3,
                ),
              )
          ),
          SizedBox(height: 15.h,),
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPage()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF1AAF74),
              ),
              child: Text("Bảng giá",
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEFEFEF),
                  height: 1.3,
                ),
              )
          ),
        ],
      ),
    );
  }
}

