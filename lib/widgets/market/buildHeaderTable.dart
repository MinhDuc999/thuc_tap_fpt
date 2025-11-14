import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filter_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';

Widget buildTableHeader(BuildContext context, MarketState state) {
  return BlocBuilder<FilterCellBloc, FilterCellState>(
    builder: (context, filterState) {
      final List<Map<String, dynamic>> allHeaders = [
        {'label': 'Mã', 'show': true},
        {'label': 'TC', 'show': true},
        {'label': 'Trần\nSàn', 'show': true},
        {'label': 'Mua 3', 'show': filterState.showGiaMuaBan3},
        {'label': 'Mua 2', 'show': true},
        {'label': 'Mua 1', 'show': true},
        {'label': 'Khớp', 'show': true},
        {'label': '+/-', 'show': true},
        {'label': 'Bán 1', 'show': true},
        {'label': 'Bán 2', 'show': true},
        {'label': 'Bán 3', 'show': filterState.showGiaMuaBan3},
        {'label': 'Tổng KL', 'show': true},
        {'label': 'Mở cửa', 'show': filterState.showMoCua},
        {'label': 'Cao\nThấp', 'show': true},
        {'label': 'NN Mua\nNN Bán', 'show': filterState.showNNMuaBan},
      ];

      List<Map<String, dynamic>> visibleHeaders = allHeaders.where((h) => h['show'] == true).toList();

      return Row(
        children: [
          for (int i = 0; i < visibleHeaders.length; i++)
            cellHeader(visibleHeaders[i]['label'], context, state, allHeaders.indexOf(visibleHeaders[i])),
        ],
      );
    },
  );
}

Widget cellHeader(String text, BuildContext context, MarketState state, int originalIndex) {
  return Container(
    width: 70.w,
    padding:  EdgeInsets.only(right: 5.w),
    alignment: originalIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
    decoration: BoxDecoration(
      border: (originalIndex == 0 || originalIndex == 1)
          ? Border(bottom: BorderSide(color: Color(0xFF33383F), width: 1))
          : Border(
        left: BorderSide(color: Color(0xFF33383F), width: 1),
        bottom: BorderSide(color: Color(0xFF33383F), width: 1),
      ),
    ),
    child: (originalIndex == 0) ? Row(
      children: [
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1.3,
            letterSpacing: 0,
            color: Color(0xFFEFEFEF),
          ),
        ),
        GestureDetector(
          onTap: () {
            final isCurrentlySortedBySymbol =
            (state.sortedColumn == MarketSortColumn.symbol);
            if (!isCurrentlySortedBySymbol) {
              context.read<MarketBloc>().add(
                  MarketEventSort(
                      column: MarketSortColumn.symbol, ascending: true));
            } else if (state.ascending) {
              context.read<MarketBloc>().add(
                  MarketEventSort(
                      column: MarketSortColumn.symbol, ascending: false));
            } else {
              context.read<MarketBloc>().add(MarketEventLoadMarket());
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/up.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.symbol &&
                        state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 1),
                SvgPicture.asset('assets/icons/down.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.symbol &&
                        !state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ) : (originalIndex == 6) ? GestureDetector(
      onTap: (){
        final isCurrentSortedByKhop =
        (state.sortedColumn == MarketSortColumn.khop);
        if (!isCurrentSortedByKhop) {
          context.read<MarketBloc>().add(MarketEventSort(column: MarketSortColumn.khop, ascending: true));
        }else if (state.ascending) {
          context.read<MarketBloc>().add(MarketEventSort(column: MarketSortColumn.khop, ascending: false));
        } else {
          context.read<MarketBloc>().add(MarketEventLoadMarket());
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
              letterSpacing: 0,
              color: Color(0xFFEFEFEF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/up.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.khop && state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 1),
                SvgPicture.asset('assets/icons/down.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.khop && !state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) : (originalIndex == 7) ? GestureDetector(
      onTap: (){
        final isCurrentSortedByChange = (state.sortedColumn ==
            MarketSortColumn.change);
        if (!isCurrentSortedByChange) {
          context.read<MarketBloc>().add(MarketEventSort(
              column: MarketSortColumn.change, ascending: true));
        } else if (state.ascending) {
          context.read<MarketBloc>().add(MarketEventSort(
              column: MarketSortColumn.change, ascending: false));
        } else {
          context.read<MarketBloc>().add(MarketEventLoadMarket());
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
              letterSpacing: 0,
              color: Color(0xFFEFEFEF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/up.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.change && state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 1),
                SvgPicture.asset(
                  'assets/icons/down.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.change &&
                        !state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) : Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0,
        color: Color(0xFFEFEFEF),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: originalIndex == 0 ? TextAlign.start : TextAlign.end,
    ),
  );
}

Widget buildFixedHeaderColumn(BuildContext context, MarketState state) {
  return Container(
    width: 70.w,
    decoration: BoxDecoration(
      color: Color(0xFF1A1D1F),
      border: Border(
        bottom: BorderSide(color: Color(0xFF33383F), width: 1),
        right: BorderSide(color: Color(0xFF33383F), width: 1),
      ),
    ),
    padding: const EdgeInsets.only(left: 3),
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: (){
        final isCurrentlySortedBySymbol = (state.sortedColumn == MarketSortColumn.symbol);
        if (!isCurrentlySortedBySymbol) {
          context.read<MarketBloc>().add(MarketEventSort(
              column: MarketSortColumn.symbol, ascending: true));
        } else if (state.ascending) {
          context.read<MarketBloc>().add(MarketEventSort(
              column: MarketSortColumn.symbol, ascending: false));
        } else {
          context.read<MarketBloc>().add(MarketEventLoadMarket());
        }
      },
      child: Row(
        children: [
          Text(
            'Mã',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
              letterSpacing: 0,
              color: Color(0xFFEFEFEF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/up.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.symbol && state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 1),
                SvgPicture.asset('assets/icons/down.svg',
                  colorFilter: ColorFilter.mode(
                    (state.sortedColumn == MarketSortColumn.symbol && !state.ascending)
                        ? Color(0xFF1AAF74)
                        : Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

int countVisibleColumns(FilterCellState filterState) {
  final List<bool> columnVisibility = [
    true,
    true,
    true,
    filterState.showGiaMuaBan3,
    true,
    true,
    true,
    true,
    true,
    true,
    filterState.showGiaMuaBan3,
    true,
    filterState.showMoCua,
    true,
    filterState.showNNMuaBan,
  ];
  return columnVisibility.where((show) => show).length;
}