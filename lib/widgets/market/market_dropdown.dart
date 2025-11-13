import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';

Widget buildMenuButton(
    BuildContext context,
    String text,
    bool hasDropdown,
    bool isSelected,
    VoidCallback onTap,
    List<String> subItems,
    String? selectedSub,
    Map<String, List<String>> filterMarket,
    ) {
  if (!hasDropdown || subItems.isEmpty) {
    return GestureDetector(
      onTap: (){
        context.read<CatalogBloc>().add(ClearCatalogSelectionEvent());
        onTap();
        context.read<MarketBloc>().add(
          MarketEventFilterByCategory(text, filterMarket),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF1AAF74) : Color(0xFF1A1D1F),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: 0,
                color: Color(0xFFEFEFEF),
              ),
            ),
          ],
        ),
      ),
    );
  }
  final hasSelectedSubItem = selectedSub != null && selectedSub.isNotEmpty && subItems.contains(selectedSub);
  final displayText = hasSelectedSubItem ? selectedSub : text;
  final backgroundColor = hasSelectedSubItem ? Color(0xFF1AAF74) : Color(0xFF1A1D1F);
  return MenuAnchor(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Color(0xFF33383F)),
      elevation: WidgetStateProperty.all(5),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Color(0xFF33383F), width: 1),
        ),
      ),
    ),
    menuChildren: subItems.map((item) {
      return MenuItemButton(
        onPressed: () {
          context.read<CatalogBloc>().add(ClearCatalogSelectionEvent());
          context.read<MarketMenuBloc>().add(SelectSubMenuItemEvent(item));
          context.read<MarketBloc>().add(
            MarketEventFilterByCategory(item, filterMarket),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),),
          minimumSize: WidgetStateProperty.all(Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          item,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFFEFEFEF),
          ),
        ),
      );
    }).toList(),
    builder: (context, controller, child) {
      return GestureDetector(
        onTap: () {
          onTap();
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                displayText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0,
                  color: Color(0xFFEFEFEF),
                ),
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset('assets/icons/down.svg'),
            ],
          ),
        ),
      );
    },
  );
}