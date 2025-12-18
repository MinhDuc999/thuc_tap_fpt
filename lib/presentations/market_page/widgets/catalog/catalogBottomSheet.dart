import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

void showCatalogBottomSheet(BuildContext context, {bool isUpdate = false, String? nameUpdate}){
  final catalogBloc = context.read<CatalogBloc>();
  if (isUpdate && nameUpdate != null) {
    catalogBloc.updateCatalog.text = nameUpdate;
  }
  final controller = isUpdate ? catalogBloc.updateCatalog : catalogBloc.addCatalog;
  final focusNode = FocusNode();
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext){
        return BlocProvider.value(
          value: catalogBloc,
          child: BlocBuilder<CatalogBloc,CatalogState>(
              builder: (context,state) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.6,),
                  child: IntrinsicHeight(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
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
                              )
                          ),
                          SizedBox(height: 5.h,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF33383F),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h, left: 40.w, right: 20.w,bottom: 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(''),
                                        Text(isUpdate ? "Cập nhật danh mục" : "Thêm danh mục",
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
                                    TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      autofocus: true,
                                      maxLines: 1,
                                      cursorColor: Color(0xFF1AAF74),
                                      style: GoogleFonts.manrope(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                        letterSpacing: 0,
                                        color: Color(0xFFEFEFEF),
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFF1A1D1F),
                                        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.r),
                                          borderSide: BorderSide(color: Color(0xFF1AAF74), width: 1.w),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.r),
                                          borderSide: const BorderSide(color: Color(0xFF1AAF74)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("Hủy",
                                              style: GoogleFonts.manrope(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: 0,
                                                color: Color(0xFF747A81),
                                              ),
                                            )
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              final newName = controller.text.trim();
                                              if (newName.isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg: "Tên danh mục không được để trống",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  backgroundColor: const Color(0xFFF34859),
                                                  textColor: const Color(0xFFEFEFEF),
                                                  fontSize: 14.sp,
                                                );
                                                focusNode.requestFocus();
                                                return;
                                              }
                                              if (isUpdate) {
                                                if (nameUpdate == newName) {
                                                  Fluttertoast.showToast(
                                                    msg: "Tên danh mục đã tồn tại",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    backgroundColor: const Color(0xFFF34859),
                                                    textColor: const Color(0xFFEFEFEF),
                                                    fontSize: 14.sp,
                                                  );
                                                  focusNode.requestFocus();
                                                  return;
                                                }
                                                if (state.allCatalog.contains(newName)) {
                                                  Fluttertoast.showToast(
                                                    msg: "Tên danh mục đã tồn tại",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    backgroundColor: const Color(0xFFF34859),
                                                    textColor: const Color(0xFFEFEFEF),
                                                    fontSize: 14.sp,
                                                  );
                                                  focusNode.requestFocus();
                                                  return;
                                                }
                                                context.read<CatalogBloc>().add(RenameCatalogEvent(nameUpdate!, newName));
                                                Navigator.pop(context);
                                              } else {
                                                if (state.allCatalog.contains(newName)) {
                                                  Fluttertoast.showToast(
                                                    msg: "Danh mục đã tồn tại",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    backgroundColor: const Color(0xFFF34859),
                                                    textColor: const Color(0xFFEFEFEF),
                                                    fontSize: 14.sp,
                                                  );
                                                  focusNode.requestFocus();
                                                  return;
                                                }
                                                context.read<CatalogBloc>().add(AddCatalogEvent(newName));
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(isUpdate ? "Cập nhật" : "Thêm mới",
                                              style: GoogleFonts.manrope(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: 0,
                                                color: Color(0xFF1AAF74),
                                              ),)
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        );
      }
  ).whenComplete(() {
    catalogBloc.addCatalog.clear();
    //focusNode.dispose();
  });
}