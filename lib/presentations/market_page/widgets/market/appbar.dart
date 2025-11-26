import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_event.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/catalog/catalogBottomSheet.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/catalog/filterBottomSheet.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/market_dropdown.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Map<String, dynamic>> allMarket;
  final Map<String, List<String>> filterMarket;
  final List<String> allCatalog;

  const CustomAppBar({super.key, required this.allMarket, required this.filterMarket, required this.allCatalog});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc,MarketState>(
      builder: (context,stockState) {
        return BlocBuilder<MarketMenuBloc, MarketMenuState>(
          builder: (context, state) {
            return BlocBuilder<CatalogBloc,CatalogState>(
                builder: (context,catalogState) {
                  return Container(
                    color: Color(0xFF111315),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          right: state.isMenuOpen ? 0 : -1000.w,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 700.w,
                            color: Color(0xFF111315),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: allMarket.map((market) {
                                        final hasSubmenu = (market['sub'] as List).isNotEmpty;
                                        final isSelected = state.selectedCategory == market['name'];
                                        final subItems = List<String>.from(market['sub'] as List);
                                        final selectedSub = state.selectedSubItems[market['name']];
                                        return buildMenuButton(
                                            context,
                                            market['name'],
                                            hasSubmenu,
                                            isSelected,
                                                () {
                                              context.read<MarketMenuBloc>().add(SelectMarketCategoryEvent(market['name'], hasSubmenu),);
                                            },
                                            subItems,
                                            selectedSub,
                                            filterMarket
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.read<MarketMenuBloc>().add(CloseMarketMenuEvent());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 12.w,right: 17.w,top: 5.h,bottom: 5.h),
                                    child: SvgPicture.asset(
                                        'assets/icons/remove-circle.svg'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<MarketMenuBloc>().add(CloseMarketMenuEvent());
                                    context.read<CatalogBloc>().add(ToggleCatalogEvent());
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/arrow-left-circle.svg'),
                                      SizedBox(width: 5.w),
                                      Text(
                                        'Danh mục',
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
                                SizedBox(width: 17.w),
                                GestureDetector(
                                  onTap: () => showFilterBottomSheet(context),
                                  child: SvgPicture.asset(
                                      'assets/icons/ic_filter_mw.svg'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          right: catalogState.isCatalogOpen ? 0 : -1500.w,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 700.w,
                            color: Color(0xFF111315),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    child: Row(
                                      children: allCatalog.reversed.map((catalog) {
                                        final isSelected = catalogState.selectedCatalog == catalog;
                                        return GestureDetector(
                                          onTap: () {
                                            context.read<MarketMenuBloc>().add(ClearMarketSelectionEvent());
                                            context.read<CatalogBloc>().add(SelectCatalogEvent(catalog),);
                                            context.read<MarketBloc>().add(
                                              MarketEventFilterByCategory(catalog,  catalogState.filterCatalog),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Color(0xFF1AAF74) : Color(0xFF1A1D1F),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  catalog.length > 15 ? '${catalog.substring(0, 15)}…' : catalog,
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
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                Center(
                                    child: MenuAnchor(
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
                                      menuChildren: allCatalog.map((catalog) {
                                        return MenuItemButton(
                                          onPressed: () {
                                            context.read<CatalogBloc>().add(SelectCatalogEvent(catalog));
                                            context.read<MarketBloc>().add(
                                              MarketEventFilterByCategory(catalog, catalogState.filterCatalog),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h)),
                                            minimumSize: WidgetStateProperty.all(Size(0, 0)),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                catalog.length > 15 ? '${catalog.substring(0, 15)}…' : catalog,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFEFEFEF),
                                                ),
                                              ),
                                              SizedBox(width: 10.w,),
                                              if (catalog != catalogState.selectedCatalog)
                                                GestureDetector(
                                                  onTap: () {
                                                    context.read<CatalogBloc>().add(DeleteCatalogEvent(catalog));
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/icons/ic_delete.svg',
                                                    width: 8.w,
                                                    height: 8.h,
                                                    colorFilter: const ColorFilter.mode(
                                                      Color(0xFFEFEFEF),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
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
                                            padding: EdgeInsets.only(left: 10.w,right: 7.5.w,top: 5.h,bottom: 5.h),
                                            child: SvgPicture.asset(
                                              'assets/icons/down.svg',
                                              height: 3.h,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                InkWell(
                                  onTap: ()=> showCatalogBottomSheet(context),
                                  child: Container(
                                    padding: EdgeInsets.only(left:  7.5.w,right: 7.5.w,top: 5.h,bottom: 5.h),
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_add.svg',
                                      height: 6.h,
                                      width: 6.w,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.read<CatalogBloc>().add(CloseCatalogEvent());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 7.5.w,right: 17.w,top: 5.h,bottom: 5.h),
                                    child: SvgPicture.asset(
                                        'assets/icons/remove-circle.svg'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(!state.isMenuOpen){
                                      context.read<CatalogBloc>().add(CloseCatalogEvent());
                                      context.read<MarketMenuBloc>().add(ToggleMarketMenuEvent());
                                    }

                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/arrow-left-circle.svg'),
                                      SizedBox(width: 5.w),
                                      Text(
                                        'Thị trường',
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
                                SizedBox(width: 17.w),
                                GestureDetector(
                                  onTap: () => showFilterBottomSheet(context),
                                  child: SvgPicture.asset(
                                      'assets/icons/ic_filter_mw.svg'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: Color(0xFF111315),
                              padding: EdgeInsets.only(right: 15.w),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      },
                                    icon: SvgPicture.asset("assets/icons/back.svg"),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Bảng giá',
                                      style: GoogleFonts.manrope(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                        letterSpacing: 0,
                                        color: Color(0xFF747A81),
                                      ),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: (state.isMenuOpen || catalogState.isCatalogOpen) ? 0.0 : 1.0,
                                    child: IgnorePointer(
                                      ignoring: (state.isMenuOpen || catalogState.isCatalogOpen),
                                      child: (catalogState.selectedCatalog != null) ?
                                      Row(
                                          children: [
                                            (state.isMenuOpen == true || catalogState.isCatalogOpen == true) ?SizedBox(width: 1.w,) :
                                            Row(
                                              children: [
                                                Text(' - ', style: TextStyle(
                                                  color: Color(0xFFEFEFEF)
                                                ),),
                                                GestureDetector(
                                                  onTap: () => showCatalogBottomSheet(context, isUpdate: true, nameUpdate:  catalogState.selectedCatalog),
                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                        catalogState.selectedCatalog!.length > 15 ? '${catalogState.selectedCatalog!.substring(0, 15)}…' : catalogState.selectedCatalog!,
                                                        style: GoogleFonts.manrope(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w500,
                                                          height: 1.5.h,
                                                          letterSpacing: 0,
                                                          color: Color(0xFFEFEFEF),
                                                        ),
                                                      ),

                                                      Positioned(
                                                        left: -1.w,
                                                        right: -1.w,
                                                        bottom: -4.h,
                                                        child: DottedBorder(
                                                            dashPattern: [4, 4],
                                                            color: Color(0xFFEFEFEF),
                                                            strokeWidth: 1,
                                                            padding: EdgeInsets.only(bottom: 9.h),
                                                            child: SizedBox(
                                                              width: 100.w,
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            (state.isMenuOpen == true || catalogState.isCatalogOpen == true) ?SizedBox(width: 1.w,) :
                                            MenuAnchor(
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
                                                menuChildren: stockState.allStocks.map((stock) {
                                                  return
                                                    MenuItemButton(
                                                      onPressed: () {
                                                        final currentCatalog = catalogState.selectedCatalog;
                                                        if (currentCatalog != null) {
                                                          final previousFilterCatalog = catalogState.filterCatalog;
                                                          context.read<CatalogBloc>().add(
                                                              AddStockToCatalogEvent(currentCatalog, stock.symbol)
                                                          );

                                                          Future.delayed(Duration(milliseconds: 50), () {
                                                            final newState = context.read<CatalogBloc>().state;
                                                            final wasAdded = newState.filterCatalog != previousFilterCatalog;
                                                            if (wasAdded) {
                                                              Fluttertoast.showToast(
                                                                msg: "Đã thêm ${stock.symbol} vào danh mục",
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.TOP,
                                                                backgroundColor: const Color(0xFF1AAF74),
                                                                textColor: const Color(0xFFEFEFEF),
                                                                fontSize: 14.sp,
                                                              );
                                                              context.read<MarketBloc>().add(
                                                                MarketEventFilterByCategory(currentCatalog, newState.filterCatalog),
                                                              );
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: "${stock.symbol} đã tồn tại trong danh mục",
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.TOP,
                                                                  backgroundColor: const Color(0xFFF34859),
                                                                  textColor: Colors.white,
                                                                  fontSize: 14.sp
                                                              );
                                                            }
                                                          });
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),),
                                                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      ),
                                                      child: Text(
                                                        stock.symbol,
                                                        style: GoogleFonts.manrope(
                                                          fontSize: 13.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xFFEFEFEF),
                                                        ),
                                                      ),
                                                    );
                                                }).toList(),
                                                builder: (context, controller, child) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (controller.isOpen) {
                                                        controller.close();
                                                      } else {
                                                        controller.open();
                                                      }
                                                    },
                                                    child: Transform.translate(
                                                      offset: Offset(0, 1.5.h),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/ic_add_symbol.svg',
                                                          height: 8.h,
                                                          width: 8.w,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ):
                                      Text(
                                        ((state.selectedCategory == null) ? "" : ((state.isMenuOpen == true || catalogState.isCatalogOpen == true)) ? "" :' - ${state.selectedCategory}'),
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          letterSpacing: 0,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: (state.isMenuOpen || catalogState.isCatalogOpen) ? 0.0 : 1.0,
                              child: IgnorePointer(
                                ignoring: (state.isMenuOpen || catalogState.isCatalogOpen),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.read<CatalogBloc>().add(ToggleCatalogEvent());
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/arrow-left-circle.svg'),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  'Danh mục',
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
                                        ],
                                      ),
                                      SizedBox(width: 20.w),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<MarketMenuBloc>().add(ToggleMarketMenuEvent());
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/icons/arrow-left-circle.svg'),
                                            SizedBox(width: 5.w),
                                            Text(
                                              'Thị trường',
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
                                      SizedBox(width: 17.w),
                                      GestureDetector(
                                        onTap: () => showFilterBottomSheet(context),
                                        child: SvgPicture.asset(
                                            'assets/icons/ic_filter_mw.svg'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            );
          },
        );
      }
    );
  }
}
