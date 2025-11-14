import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_event.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filter_bloc.dart';
import 'package:ui_bang_gia/widgets/market/buildFilterButton.dart';

void showFilterBottomSheet(BuildContext context){
  final filterBloc = context.read<FilterCellBloc>();

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext){
        return BlocProvider.value(
          value: filterBloc,
          child: BlocBuilder<FilterCellBloc,FilterCellState>(
              builder: (context,state) {
                return IntrinsicHeight(
                  child: Column(
                    children: [
                      Center(
                          child: Container(
                            height: 3.h,
                            width: 25.h,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(25)
                            ),
                          )),
                      SizedBox(height: 5.h,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF33383F),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h, left: 40.w, right: 20.w, bottom: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(''),
                                    Text("Tùy chỉnh hiển thị",
                                      style: GoogleFonts.manrope(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                        letterSpacing: 0,
                                        color: Color(0xFFEFEFEF),
                                      ),),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Icon(
                                        Icons.close,
                                        color: Color(0xFF747A81),
                                        size: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h,),
                                Text("Chọn cột thông tin để thêm vào bảng giá",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: 0,
                                    color: Color(0xFF747A81),),
                                ),
                                SizedBox(height: 2.h,),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: buildFilterButton("NN mua/bán",null, state.showNNMuaBan, () => context.read<FilterCellBloc>().add(ToggleNNMuaBanEvent()))),
                                      SizedBox(width: 10.w,),
                                      Expanded(
                                          child: buildFilterButton(
                                              "Mở cửa",null, state.showMoCua, () => context.read<FilterCellBloc>().add(ToggleMoCuaEvent()))),
                                      SizedBox(width: 10.w,),
                                      Expanded(
                                          child: buildFilterButton(
                                              "Giá mua/bán 3",null, state.showGiaMuaBan3, () => context.read<FilterCellBloc>().add(ToggleGiaMuaBan3Event()) )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                Text("Chọn kiểu hiển thị khối lượng (chỉ áp dụng với mã cơ sở)",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: 0,
                                    color: Color(0xFF747A81),),
                                ),
                                SizedBox(height: 2.h,),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: buildFilterButton(
                                              "Đầy đủ",
                                              "(Vd: 1,723,400)",
                                              state.khoiLuong == 'dayDu',
                                                  () {
                                                if (state.khoiLuong != 'dayDu') {
                                                  context.read<FilterCellBloc>().add(SetKhoiLuongEvent('dayDu'));
                                                }
                                              }
                                          )
                                      ),
                                      SizedBox(width: 10.w,),
                                      Expanded(
                                          child: buildFilterButton(
                                              "Rút gọn",
                                              "(Vd: 1,723,4)",
                                              state.khoiLuong == 'rutGon',
                                                  () {
                                                if (state.khoiLuong != 'rutGon') {
                                                  context.read<FilterCellBloc>().add(SetKhoiLuongEvent('rutGon'));
                                                }
                                              }
                                          )
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        );
      }
  );
}