import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget navPlaceholder({bool isDraggingOver = false}) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isDraggingOver? 0.5 : 1,
              child: SvgPicture.asset(
                "assets/icons/default.svg",
                colorFilter: ColorFilter.mode(
                  isDraggingOver ? Color(0xFF1AAF74) : Color(0xFF6F767E),
                  BlendMode.srcIn,
                ),
                // width: 24.w,
                // height: 24.h,
              ),
            ),
            Opacity(
              opacity: isDraggingOver? 0.5 : 1,
              child: Container(
                width: 16.2.w,
                height: 17.2.h,
                decoration: BoxDecoration(
                  color: isDraggingOver ? Color(0xFF1AAF74) : Color(0xFF33383F),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
            height: 38.h,
            child: Text('', style: TextStyle(fontSize: 12.sp))),
      ],
    ),
  );
}