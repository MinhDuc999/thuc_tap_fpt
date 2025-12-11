import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_core/constants/feature_data.dart';

Widget navItem(String featureKey, {bool isDraggingOver = false}) {
  final feature = NavigationData.getFeatureByKey(featureKey);
  if (feature == null) return SizedBox.shrink();

  final isRemovable = !feature.isFixed;

  if (isDraggingOver && isRemovable) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.5,
                child: SvgPicture.asset(
                  "assets/icons/default.svg",
                  colorFilter: ColorFilter.mode(
                    Color(0xFF1AAF74),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: 16.2.w,
                  height: 17.2.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1AAF74),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 38.h,
            child: Text('', style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }

  return Column(
    children: [
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 23.h,
            decoration: BoxDecoration(
                boxShadow: isRemovable ? [
                  BoxShadow(
                    color: Color(0xFF1AAF74).withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ] : null
            ),
            child: SvgPicture.asset(
              feature.iconPath,
              colorFilter: isRemovable
                  ? const ColorFilter.mode(Color(0xFF1AAF74), BlendMode.srcIn)
                  : null,
              width: isRemovable ? null : 15.w,
              height: isRemovable ? 20.h : 15.h,
            ),
          ),
          if (isRemovable)
            Positioned(
              right: -10,
              top: -8,
              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.all(width: 4.w, color: Color(0xFF1A1D1F)),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset('assets/icons/huy.svg'),
              ),
            ),
        ],
      ),
      SizedBox(height: 4.h),
      SizedBox(
        height: 38.h,
        child: Text(
          feature.displayName,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            color: isRemovable ? Color(0xFF1AAF74) : Color(0xFF747A81),
            fontWeight: FontWeight.w700,
            fontSize: isRemovable ? 12.sp : 8.sp,
            height: 1.3.h,
            letterSpacing: 0,
          ),
        ),
      ),
    ],
  );
}