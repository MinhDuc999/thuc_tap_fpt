import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_core/bloc/navi_bloc/navi_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/presentations/widgets/appbar.dart';
import 'package:shared_core/presentations/widgets/navItemWidget.dart';
import 'package:shared_core/presentations/widgets/navPlaceholderWidget.dart';
import 'package:shared_core/presentations/widgets/buildFeatureSearch.dart';
import 'package:shared_core/presentations/widgets/tabWidget.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _screen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Future.delayed(const Duration(seconds: 5), () {
    //   _animationController.stop();
    // });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _screen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allFeatures = [
      "Trang chủ",
      "Sổ lệnh",
      "Đặt lệnh",
      "Tài sản",
      "Ứng dụng",
      "Biểu đồ",
      "Bảng giá",
      "Chuyển tiền",
      "Tài khoản",
      "Smart OTP",
      "Tiền cho vay",
      "Cài đặt Thông báo",
      "Phân tích Kỹ thuật",
      "Tổng quan Thị trường",
      "Nhận định",
      "Tin tức",
      "Cài đặt",
    ];

    final Map<String, String> featureIcons = {
      "Trang chủ": "assets/icons/trang_chu.svg",
      "Sổ lệnh": "assets/icons/tin_tuc.svg",
      "Đặt lệnh": "assets/icons/dat_lenh.svg",
      "Tài sản": "assets/icons/thi_truong.svg",
      "Ứng dụng": "assets/icons/ung_dung.svg",
      "Biểu đồ": "assets/icons/bieu_do.svg",
      "Bảng giá": "assets/icons/bang_gia.svg",
      "Chuyển tiền": "assets/icons/chuyen_tien.svg",
      "Tài khoản": "assets/icons/tai_khoan.svg",
      "Smart OTP": "assets/icons/OTP.svg",
      "Tiền cho vay": "assets/icons/thi_truong.svg",
      "Cài đặt Thông báo": "assets/icons/thong_bao.svg",
      "Phân tích Kỹ thuật": "assets/icons/pt_ky_thuat.svg",
      "Tổng quan Thị trường": "assets/icons/thi_truong.svg",
      "Nhận định": "assets/icons/nhan_dinh.svg",
      "Tin tức": "assets/icons/tin_tuc.svg",
      "Cài đặt": "assets/icons/cai_dat.svg",
    };

    final List<String> tabs = [
      "Tất cả",
      "Hay dùng",
      "Giao dịch",
      "Quản lý tài sản",
    ];

    final Map<String, List<String>> tabFeatures = {
      "Tất cả": allFeatures,
      "Hay dùng": [
        "Bảng giá",
        "Tin tức",
        "Cài đặt Thông báo",
        "Tổng quan Thị trường",
        "Cài đặt",
      ],
      "Giao dịch": [
        "Sổ lệnh",
        "Đặt lệnh",
        "Chuyển tiền",
        "Tiền cho vay",
        "Smart OTP",
      ],
      "Quản lý tài sản": [
        "Tài khoản",
        "Tài sản",
        "Biểu đồ",
        "Nhận định",
        "Phân tích Kỹ thuật",
      ],
    };
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final searchController = context.read<NavigationBloc>().searchController;
          final searchFocus = context.read<NavigationBloc>().searchFocusNode;
          final selectedSlots = state.selectedSlots;
          final hasEnoughSelected = state.hasEnoughSelected;
          final selected = state.selected;
          final selectedIndex = state.selectedIndex;
          final selectedTab = state.selectedTab;
          final currentTabLabel = tabs[selectedTab];
          final currentFeatures = tabFeatures[currentTabLabel]!;
          final visibleFeatures = currentFeatures.where((feature) => !selectedSlots.contains(feature)).toList();
          final searchResults = state.searchResults ?? [];
          final hasQuery = (state.searchQuery ?? '').isNotEmpty;
          final visible = allFeatures.where((feature) => !state.selectedSlots.contains(feature)).toList();
          List<String> suggestedFeatures;
          if (!hasQuery) {
            suggestedFeatures = List<String>.from(visible);
            if (state.recentlyRemovedFeature != null &&
                state.recentlyRemovedFeature!.isNotEmpty) {
              for (var removedFeature
                  in state.recentlyRemovedFeature!.reversed) {
                if (suggestedFeatures.contains(removedFeature)) {
                  suggestedFeatures.remove(removedFeature);
                  suggestedFeatures.insert(0, removedFeature);
                }
              }
            }
            suggestedFeatures = suggestedFeatures.take(4).toList();
          } else {
            suggestedFeatures = [];
          }
          final displayFeatures = hasQuery ? searchResults : suggestedFeatures;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xFF111315),
              appBar: const CustomAppBar(title: 'Chỉnh thanh điều hướng'),
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 214.h,
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    if(state.isSearchViewOpen == true){
                                      context.read<NavigationBloc>().add(CloseSearchView());
                                    }
                                  },
                                  child: Container(
                                    height: 138.h,
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1A1D1F),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: hasEnoughSelected ? null : Border.all(
                                              color: const Color(0xFFF34859),
                                              width: 0.5.w,
                                            ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w, bottom: 3.h),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(selectedSlots.length, (index) {
                                              final feature = selectedSlots[index];
                                              final shouldShake = feature != "Trang chủ" && feature != "Ứng dụng";
                                              return Expanded(
                                                child: AnimatedBuilder(
                                                  animation: _animationController,
                                                  builder: (context, child) {
                                                    if (!shouldShake) {
                                                      return child!;
                                                    }
                                                    //final angle = sin(_animationController.value * 2 * pi) * 0.07;
                                                    final angle = cos(_animationController.value *2 * pi,) * 0.09;
                                                    return Transform.rotate(
                                                      angle: angle,
                                                      child: child,
                                                    );
                                                  },
                                                  child: DragTarget<String>(
                                                    onAcceptWithDetails: (details) {
                                                      context.read<NavigationBloc>().add(ReplaceFeature(details.data, index));
                                                    },
                                                    onWillAcceptWithDetails: (details) {
                                                      return true;
                                                    },
                                                    builder: (context, candidateData, rejectedData,) {
                                                      final isDraggingOver = candidateData.isNotEmpty;

                                                      if (feature == null) {
                                                        return navPlaceholder(isDraggingOver: isDraggingOver);
                                                      }

                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (feature == "Trang chủ" || feature == "Ứng dụng") {
                                                            if(state.isSearchViewOpen == true){
                                                              context.read<NavigationBloc>().add(CloseSearchView());
                                                            }
                                                            return;
                                                          }
                                                          context.read<NavigationBloc>().add(RemoveFeature(feature));
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: navItem(feature,
                                                            featureIcons[feature] ??
                                                                'assets/icons/trang_chu.svg',
                                                            isDraggingOver: isDraggingOver,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        //Expanded(child: SizedBox(height: 2.h)),
                                        Padding(
                                          padding: EdgeInsets.only(right: 12.w, left: 12.w),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(selected.length, (index) {
                                              final isActive = selectedIndex == index;
                                              final label = selected[index] ?? 'Mặc định';
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.read<NavigationBloc>().add(ChangeButton(index));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 16.w,
                                                        height: 16.w,
                                                        decoration: BoxDecoration(
                                                          border: isActive ? Border.all(
                                                             width: 3.5.w,
                                                               color: Color(0xFF1AAF74),
                                                                ) : Border.all(
                                                                      width: 0.5.w,
                                                                      color: Color(0xFF6F767E,).withValues(alpha: 0.3),
                                                                    ),
                                                          shape: BoxShape.circle,
                                                          color: isActive ? const Color(0xFFFCFCFC) : const Color(0xFF33383F),
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        isActive ? label : '',
                                                        style: GoogleFonts.manrope(
                                                              color: isActive ? const Color(0xFF1AAF74) : const Color(0xFF6F767E),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12.sp,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              GestureDetector(
                                onTap: (){
                                  if(state.isSearchViewOpen == true){
                                    context.read<NavigationBloc>().add(CloseSearchView());
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      if (!hasEnoughSelected) ...[
                                        SvgPicture.asset("assets/icons/loi.svg"),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Vui lòng chọn đủ 3 tính năng',
                                          style: GoogleFonts.manrope(
                                            color: const Color(0xFFF34859),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5.h,
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          'Nhấn chọn hoặc kéo thả để tùy chỉnh thanh điều hướng',
                                          style: GoogleFonts.manrope(
                                            color: const Color(0xFF6F767E),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5.h,
                                          ),
                                        ),
                                      //SizedBox(width: double.infinity,)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (state.isSearchViewOpen == false) {
                                        context.read<NavigationBloc>().add(OpenSearchView(),);
                                        Future.delayed(const Duration(milliseconds: 300), () {
                                            searchFocus.requestFocus();
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        color: const Color(0XFF33383F),
                                        borderRadius: BorderRadius.circular(28.r,),
                                      ),
                                      child: SizedBox(
                                        // width: 14.33.w,
                                        // height: 14.33.h,
                                        child: SvgPicture.asset("assets/icons/search.svg",),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < tabs.length; i++)
                                            GestureDetector(
                                              onTap: () {
                                                context.read<NavigationBloc>().add(ChangeTab(i));
                                              },
                                              child: tab(tabs[i], selectedTab == i),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: GridView.builder(
                              itemCount: currentFeatures.where((feature) => !selectedSlots.contains(feature)).length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 16.h,
                                    crossAxisSpacing: 24.5.w,
                                    childAspectRatio: 0.9,
                                  ),
                              itemBuilder: (context, index) {
                                final name = visibleFeatures[index];
                                final icon = featureIcons[name];
                                return Draggable<String>(
                                  data: name,
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
                                                  color: Color(0xFF1AAF74,).withValues(alpha: 0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: SvgPicture.asset(icon!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Center(
                                    child: Opacity(
                                      opacity: 0.3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 23.h,
                                            child: SvgPicture.asset(icon),
                                          ),
                                          SizedBox(height: 4.h),
                                          Expanded(
                                            child: Text(
                                              name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5.h,
                                                letterSpacing: 0,
                                                color: Color(0xFF747A81),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      final emptyIndex = selectedSlots.indexWhere((e) => e == null);
                                      if (emptyIndex != -1) {
                                        context.read<NavigationBloc>().add(AllFeature(name));
                                      } else {
                                        context.read<NavigationBloc>().add(ReplaceFeature(name, 3),);
                                      }
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 23.h,
                                            child: SvgPicture.asset(icon),
                                          ),
                                          SizedBox(height: 4.h),
                                          Expanded(
                                            child: Text(
                                              name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5.h,
                                                letterSpacing: 0,
                                                color: Color(0xFF747A81),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    bottom: state.isSearchViewOpen ? 0 : -1000.w,
                    child: Container(
                      height: 202.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1D1F),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                            child: Text(
                              hasQuery
                                  ? "Kết quả tìm kiếm (${searchResults.length})"
                                  : "Gợi ý cho bạn (${suggestedFeatures.length})",
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEFEFEF),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 75.h,
                            child: displayFeatures.isEmpty ? SizedBox(height: 10) : ListView.builder(
                               scrollDirection: Axis.horizontal,
                               padding: EdgeInsets.symmetric(horizontal: 20.w,),
                               itemCount: displayFeatures.length,
                               physics: ClampingScrollPhysics(),
                               itemBuilder: (context, index) {
                               final name = displayFeatures[index];
                               final icon = featureIcons[name];
                               return Padding(
                                 padding: EdgeInsets.only(right: 12.w),
                                 child: buildFeatureItem(context, name, icon!,),
                                 );
                               },
                            ),
                          ),
                          Container(
                            color: Color(0xFF1A1D1F),
                            padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 12.h,),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<NavigationBloc>().add(CloseSearchView());
                                    searchController.clear();
                                    context.read<NavigationBloc>().add(SearchFeature('', allFeatures: allFeatures));
                                  },
                                  child: Container(
                                    width: 25.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF6F767E),
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0XFF33383F),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: TextField(
                                      controller: searchController,
                                      focusNode: searchFocus,
                                      autofocus: false,
                                      maxLines: 1,
                                      cursorColor: Color(0xFF6F767E),
                                      style: GoogleFonts.manrope(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFEFEFEF),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Tìm kiếm tính năng ưa thích",
                                        hintStyle: GoogleFonts.manrope(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF6F767E),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                          horizontal: 16.w,
                                        ),
                                        suffixIcon:
                                            searchController.text.isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  searchController.clear();
                                                  context.read<NavigationBloc>().add(SearchFeature('', allFeatures: allFeatures));
                                                },
                                                child: Icon(Icons.close,
                                                  color: Color(0xFF6F767E),
                                                  size: 20.sp,
                                                ),
                                              ) : null,
                                      ),
                                      onChanged: (value) {
                                        context.read<NavigationBloc>().add(SearchFeature(value, allFeatures: allFeatures),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
