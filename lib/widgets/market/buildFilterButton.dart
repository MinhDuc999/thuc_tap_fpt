import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildFilterButton(String text,String? text2, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF1A1D1F) ,
        border: Border.all(
          color: isSelected ? Color(0xFF1AAF74) : Color(0xFF1A1D1F),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEFEFEF),
                    height: 1.3,
                  ),
                ),
                if (text2 != null)
                  SizedBox(height: 2.h,),
                if (text2 != null)
                  Text(
                    text2,
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEFEFEF),
                      height: 1.3,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: 15.w,
            height: 15.h,
            decoration: BoxDecoration(
              border: isSelected ? Border.all(
                  width: 3.5.w,
                  color: Color(0xFF1AAF74)) :
              Border.all(
                  width: 0.5.w,
                  color: Color(0xFF6F767E).withValues(alpha: 0.3)),
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFCFCFC) : const Color(0xFF33383F),
            ),
          ),
        ],
      ),
    ),
  );
}