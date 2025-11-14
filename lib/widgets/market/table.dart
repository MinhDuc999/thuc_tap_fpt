import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filter_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/helper/utils.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';
import 'package:ui_bang_gia/widgets/market/animatedStockRow.dart';

Widget buildRow(Stock s, int rowIndex, int totalRows, Map<int, CellFlashState> flashCells) {
  return BlocBuilder<FilterCellBloc, FilterCellState>(
    builder: (context, filterState) {
      final List<Map<String, dynamic>> allCells = [
        {'value': s.symbol, 'show': true, 'type': 'symbol'},
        {'value': fmtValue(s.tc), 'show': true, 'type': 'tc'},
        {'value': '${fmtValue(s.tran)} \n ${fmtValue(s.san)}', 'show': true, 'type': 'transan'},
        {'value': s.mua3, 'show': filterState.showGiaMuaBan3, 'type': 'mua3'},
        {'value': s.mua2, 'show': true, 'type': 'mua2'},
        {'value': s.mua1, 'show': true, 'type': 'mua1'},
        {'value': fmtValue(s.khop), 'show': true, 'type': 'khop'},
        {'value': ((s.change != null && s.change!.isNotEmpty)
            ? '${fmtValue(s.change![0])} \n ${s.change!.length > 1 ? '${s.change![0] > 0 ? '+' : ''}${fmtValue(s.change![1])}%' : ' '}' : ' '), 'show': true, 'type': 'change'},
        {'value': s.ban1, 'show': true, 'type': 'ban1'},
        {'value': s.ban2, 'show': true, 'type': 'ban2'},
        {'value': s.ban3, 'show': filterState.showGiaMuaBan3, 'type': 'ban3'},
        {'value': fmtValue(s.totalVolume), 'show': true, 'type': 'totalVolume'},
        {'value': fmtValue(s.open), 'show': filterState.showMoCua, 'type': 'open'},
        {'value': fmtValue(s.highLow), 'show': true, 'type': 'highLow'},
        {'value': '${fmtValue(s.mua)} \n ${fmtValue(s.ban)}', 'show': filterState.showNNMuaBan, 'type': 'nnmuaban'},
      ];

      List<Map<String, dynamic>> visibleCells = allCells.where((c) => c['show'] == true).toList();

      return Row(
        children: [
          for (int i = 0; i < visibleCells.length; i++)
            cell(
              visibleCells[i]['value'],
              s,
              rowIndex,
              totalRows,
              allCells.indexOf(visibleCells[i]),
              visibleCells[i]['type'],
              filterState.khoiLuong,
              flashCells,
            ),
        ],
      );
    },
  );
}

Widget cell(dynamic value, Stock stock, int rowIndex, int totalRows, int originalIndex, String type,String volumeType, Map<int, CellFlashState> flashCells) {
  final val = getFirstValue(fmtValue(stock.khop));
  final col = getColorKhop(val, stock);
  Color? bgColor;

  if (originalIndex == 0) {
    if (col == Color(0xFFF34859)) {
      bgColor = Color(0xFFF34859);
    } else if (col == Color(0xFF1AAF74)) {
      bgColor = Color(0xFF1AAF74);
    } else {
      bgColor = Color(0xFFFF9F41);
    }
  } else if (type == 'mua3' || type == 'mua2' || type == 'mua1' ||
      type == 'ban1' || type == 'ban2' || type == 'ban3') {
    bgColor = Color(0xFF111015);
  }

  String displayValue;
  if (type == 'mua3' || type == 'mua2' || type == 'mua1' ||
      type == 'ban1' || type == 'ban2' || type == 'ban3') {
    if (value is List && value.length >= 2) {
      String price = fmtValue(value[0]);
      String volume = formatVolume(value[1], volumeType);
      displayValue = '$price\n$volume';
    } else {
      displayValue = fmtValue(value);
    }
  } else {
    displayValue = value.toString();
  }

  return Container(
    width: 70.w,
    height: 45,
    padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1),
    alignment: originalIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
    decoration: BoxDecoration(
      color: bgColor,
      border: (originalIndex == 0 || originalIndex == 1)
          ? Border(
          top: (rowIndex == 0)
              ? BorderSide.none
              : BorderSide(color: Color(0xFF33383F), width: 1),
          bottom: (rowIndex == totalRows-1) ? BorderSide(color: Color(0xFF33383F), width: 1) : BorderSide.none
      )
          : Border(
          left: BorderSide(color: Color(0xFF33383F), width: 1),
          top: (rowIndex == 0)
              ? BorderSide.none
              : BorderSide(color: Color(0xFF33383F), width: 1),
          bottom: (rowIndex == totalRows-1) ? BorderSide(color: Color(0xFF33383F), width: 1) : BorderSide.none
      ),
    ),
    child: buildSellColor(displayValue, stock, bgColor, originalIndex, flashCells),
  );
}

Widget buildSellColor(String value, Stock stock, Color? bgColor, int originalIndex, Map<int, CellFlashState> flashCells) {
  Color textColor = getCellColor(originalIndex, value, stock);
  Color? textColorLine1;
  Color? textColorLine2;

  final flashState = flashCells[originalIndex];
  if(flashState != null){
    final elapsed = DateTime.now().difference(flashState.timestamp).inMilliseconds;
    final opacity = (1.0 - (elapsed / 300)).clamp(0.0, 1.0) * 0.3;

    if(opacity >0){
      final bgColor = flashState.flashColor.withValues(alpha: opacity);
      if(flashState.flashLine == 0){
        textColorLine1 = bgColor;
        textColorLine2 = bgColor;
      }else if(flashState.flashLine ==1){
        textColorLine1 = bgColor;
      }else if(flashState.flashLine ==2){
        textColorLine2 = bgColor;
      }
    }
  }

  if (originalIndex == 2) {
    final parts = value.split('\n');
    if (parts.length >= 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric( vertical: 1),
            child: Text(
              parts[0].trim(),
              style: GoogleFonts.manrope(
                fontFeatures: [FontFeature.tabularFigures()],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
                color: Color(0xFFA43EE7),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric( vertical: 1),
            child: Text(
              parts[1].trim(),
              style: GoogleFonts.manrope(
                fontFeatures: [FontFeature.tabularFigures()],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
                color: Color(0xFF3FC2EB),
              ),
            ),
          ),
        ],
      );
    }
  } else if (originalIndex == 0) {
    return Text(
      value,
      style: GoogleFonts.manrope(
        fontFeatures: [FontFeature.tabularFigures()],
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: (bgColor == Color(0xFFF34859) ? Color(0xFFEFEFEF) : null),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
    );
  }

  final parts = value.split('\n');
  if(parts.length>=2){
    return Column(
      crossAxisAlignment: originalIndex == 0? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (parts[0].trim().isNotEmpty) ?
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric( vertical: 1),
          decoration: textColorLine1 != null ? BoxDecoration(
            color: textColorLine1,
          ) : null,
          child: Text(
            parts[0].trim(),
            style: GoogleFonts.manrope(
              fontFeatures: [FontFeature.tabularFigures()],
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: 0,
              color: textColor,
            ),
            textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
          ),
        ) : Text(
          parts[0].trim(),
          style: GoogleFonts.manrope(
            fontFeatures: [FontFeature.tabularFigures()],
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1.2,
            letterSpacing: 0,
            color: textColor,
          ),
          textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
        ),
        (parts[1].trim().isNotEmpty) ?
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric( vertical: 1),
          decoration: textColorLine2 != null ? BoxDecoration(
            color: textColorLine2,
          ) : null,
          child: Text(
            parts[1].trim(),
            style: GoogleFonts.manrope(
              fontFeatures: [FontFeature.tabularFigures()],
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: 0,
              color: textColor,
            ),
            textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
          ),
        ) : Text(
          parts[1].trim(),
          style: GoogleFonts.manrope(
            fontFeatures: [FontFeature.tabularFigures()],
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1.2,
            letterSpacing: 0,
            color: textColor,
          ),
          textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
        ),
      ],
    );
  }
  return AnimatedContainer(
    duration: Duration(milliseconds: 100),
    curve: Curves.easeOut,
    padding: EdgeInsets.symmetric( vertical: 1),
    decoration: textColorLine1 != null ? BoxDecoration(
      color: textColorLine1,
    ) : null,
    child: Text(
      value,
      style: GoogleFonts.manrope(
        fontFeatures: [FontFeature.tabularFigures()],
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0,
        color: textColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
    ),
  );
}

Widget buildFixedBodyColumn(MarketState state, int totalRows, CatalogState catalogState) {
  return Container(
    width: 70.w,
    color: Color(0xFF1A1D1F),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: state.stocks.length,
      itemBuilder: (context, index) {
        final s = state.stocks[index];
        final val = getFirstValue(fmtValue(s.khop));
        final col = getColorKhop(val, s);
        Color bgColor;
        if (col == Color(0xFFF34859)) {
          bgColor = Color(0xFFF34859);
        } else if (col == Color(0xFF1AAF74)) {
          bgColor = Color(0xFF1AAF74);
        } else {
          bgColor = Color(0xFFFF9F41);
        }
        return MenuAnchor(
          alignmentOffset: Offset(70.w, -45),
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFF1A1D1F)),
            elevation: WidgetStateProperty.all(5),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xFF33383F), width: 1),
              ),
            ),
          ),
          menuChildren: [
            MenuItemButton(
              onPressed: () {
                print('Xem chi tiết: ${s.symbol}');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h)),
                minimumSize: WidgetStateProperty.all(Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Xem chi tiết',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEFEFEF),
                ),
              ),
            ),
             if(catalogState.selectedCatalog != null)
               MenuItemButton(
                 onPressed: () {
                   Fluttertoast.showToast(
                     msg: "Đã xóa ${s.symbol} khỏi danh mục",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.TOP,
                     backgroundColor: const Color(0xFF1AAF74),
                     textColor: const Color(0xFFEFEFEF),
                     fontSize: 14.sp,
                   );
                   context.read<CatalogBloc>().add(DeleteStockFromCatalogEvent(catalogState.selectedCatalog!, s.symbol));
                    Future.delayed(Duration(milliseconds: 50), () {
                     final newState = context.read<CatalogBloc>().state;
                     context.read<MarketBloc>().add(MarketEventFilterByCategory(catalogState.selectedCatalog!, newState.filterCatalog),);
                   });
                 },
                 style: ButtonStyle(
                   backgroundColor: WidgetStateProperty.all(Colors.transparent),
                   padding: WidgetStateProperty.all(
                       EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h)),
                   minimumSize: WidgetStateProperty.all(Size(0, 0)),
                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 ),
                 child: Text(
                   'Xoá khỏi danh mục',
                   style: GoogleFonts.manrope(
                     fontSize: 13.sp,
                     fontWeight: FontWeight.w500,
                     color: Color(0xFFEFEFEF),
                   ),
                 ),
               ),
            MenuItemButton(
              onPressed: () {
                print('Mua: ${s.symbol}');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h)),
                minimumSize: WidgetStateProperty.all(Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Mua',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEFEFEF),
                ),
              ),
            ),
            MenuItemButton(
              onPressed: () {
                print('Bán: ${s.symbol}');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h)),
                minimumSize: WidgetStateProperty.all(Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Bán',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEFEFEF),
                ),
              ),
            ),
          ],
          builder: (context, controller, child) {
            return InkWell(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                width: 70.w,
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border(
                    top: (index == 0) ? BorderSide.none : BorderSide(color: Color(0xFF33383F), width: 1),
                    bottom: (index == totalRows - 1) ? BorderSide(color: Color(0xFF33383F), width: 1) : BorderSide.none,
                    right: BorderSide(color: Color(0xFF33383F), width: 1),
                  ),
                ),
                child: Text(
                  s.symbol.length >= 4
                      ? '${s.symbol.substring(0, 4)}\n${s.symbol.substring(4)}'
                      : s.symbol,
                  style: GoogleFonts.manrope(
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: 0,
                    color: (bgColor == Color(0xFFF34859) ? Color(0xFFEFEFEF) : null),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
