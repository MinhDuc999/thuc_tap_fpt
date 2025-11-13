import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/helper/utils.dart';
import 'package:ui_bang_gia/widgets/market/animatedTopIndices.dart';


Widget buildTopIndices(List<Map<String, String>> indices,Map<String, IndexFlashState> flashStates) {
  return SizedBox(
    height: 57,
    child: ListView.separated(
      //padding: EdgeInsets.symmetric(horizontal: 7.w),
      scrollDirection: Axis.horizontal,
      itemCount: indices.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, i) {
        final it = indices[i];
        final color = getChangeColor(it['percent']);
        final label = it['label']!;
        Color? getFlashColor(String field) {
          final key = '$label-$field';
          final flashState = flashStates[key];
          if (flashState != null) {
            final elapsed = DateTime.now().difference(flashState.timestamp).inMilliseconds;
            final opacity = (1.0 - (elapsed / 300)).clamp(0.0, 1.0) * 0.3;
            if (opacity > 0) {
              return flashState.color.withValues(alpha: opacity);
            }
          }
          return null;
        }
        final valueFlashColor = getFlashColor('value');
        final changeFlashColor = getFlashColor('change');
        final percentFlashColor = getFlashColor('percent');

        return GestureDetector(
          onTap: (){
            print(i);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7),
            width: 200.w,
            decoration: BoxDecoration(
              color: Color(0xFF1A1D1F),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0,0,0,0.10),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: -1
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${it['label']}',
                          style: GoogleFonts.manrope(
                            color: Color(0xFFEFEFEF),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          //padding: EdgeInsets.symmetric( vertical: 1),
                          decoration: BoxDecoration(
                            color: valueFlashColor
                          ),
                          child: Text(
                            '${it['value']}',
                            style: GoogleFonts.manrope(
                              color: color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          //padding: EdgeInsets.symmetric( vertical: 1),
                          decoration: BoxDecoration(
                              color: changeFlashColor
                          ),
                          child: Text(
                            '${it['change']}',
                            style: GoogleFonts.manrope(
                              color: color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          //padding: EdgeInsets.symmetric( vertical: 1),
                          decoration: BoxDecoration(
                              color: percentFlashColor
                          ),
                          child: Text(
                            '${it['percent']}%',
                            style: GoogleFonts.manrope(
                              color: color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KL: ${it['KL']} tỉ',
                      style: GoogleFonts.manrope(
                        color: Color(0xFFEFEFEF),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      'GT: ${it['GT']} tỉ',
                      style: GoogleFonts.manrope(
                        color: Color(0xFFEFEFEF),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}