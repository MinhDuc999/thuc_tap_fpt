import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_core/constants/feature_data.dart';

Widget buildFeatureItem(BuildContext context, String featureKey) {
  final feature = NavigationData.getFeatureByKey(featureKey);
  if (feature == null) return SizedBox.shrink();

  return SizedBox(
    width: 70.w,
    child: Draggable<String>(
      data: featureKey,
      feedback: Transform.translate(
        offset: Offset(-20, 0),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1AAF74).withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  feature.iconPath,
                  height: 23.h,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1D1F),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  feature.iconPath,
                  height: 23.h,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              feature.displayName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9FA4A9),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1A1D1F),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                feature.iconPath,
                height: 23.h,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            feature.displayName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9FA4A9),
              height: 1.3,
            ),
          ),
        ],
      ),
    ),
  );
}