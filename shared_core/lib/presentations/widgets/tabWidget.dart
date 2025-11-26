import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget tab(String label, bool selected) {
  return Container(
    height: 28.h,
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
      color: selected ? Color(0xFF1AAF74) : Color(0x33383F4D),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Center(
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: selected ? Color(0xFFFFFFFF) : Color(0xFF6F767E),
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          height: 1.5.h,
          letterSpacing: 0,
        ),
      ),
    ),
  );
}