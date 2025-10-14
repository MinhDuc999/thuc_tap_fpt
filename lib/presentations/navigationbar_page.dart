import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_bloc.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_event.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_state.dart';
import 'package:ui_dieu_huong/widgets/appbar.dart';

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
          final selectedSlots = state.selectedSlots;
          final hasEnoughSelected = state.hasEnoughSelected;
          final selected = state.selected;
          final selectedIndex = state.selectedIndex;
          final selectedTab = state.selectedTab;
          final currentTabLabel = tabs[selectedTab];
          final currentFeatures = tabFeatures[currentTabLabel]!;
          final visibleFeatures = currentFeatures.where((feature) => !selectedSlots.contains(feature)).toList();
          return Scaffold(
            backgroundColor: Color(0xFF111315),
            appBar: const CustomAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 214.h,
                    child: Column(
                      children: [
                        Expanded(
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
                                  padding: const EdgeInsets.all(8.0),
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
                                            //final angle = sin((_animationController.value * 2 * pi) + (index * 0.5)) * 0.15;
                                            //final angle = sin(_animationController.value * 2 * pi) * 0.07;
                                            final angle = cos(_animationController.value * 2 * pi) * 0.18;
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
                                                    return _navPlaceholder(isDraggingOver: isDraggingOver);
                                                  }

                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (feature == "Trang chủ" || feature == "Ứng dụng") {
                                                        return;
                                                      }
                                                      context.read<NavigationBloc>().add(RemoveFeature(feature));
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: _navItem(feature,
                                                        featureIcons[feature] ?? 'assets/icons/trang_chu.svg',
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
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(selected.length, (index) {
                                    final isActive = selectedIndex == index;
                                    final label = selected[index] ?? '';
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
                                                  color: Color(0xFF1AAF74)) :
                                                Border.all(
                                                  width: 0.5.w,
                                                  color: Color(0xFF6F767E).withValues(alpha: 0.3)),
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            if (!hasEnoughSelected) ...[
                              SvgPicture.asset(
                                "assets/icons/loi.svg",
                              ),
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
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Container(
                                alignment: Alignment.center,
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0XFF33383F),
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                                child: SizedBox(
                                  width: 14.33.w,
                                  height: 14.33.h,
                                  child: SvgPicture.asset(
                                      "assets/icons/search.svg",
                                    ),
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
                                        child: _tab(tabs[i], selectedTab == i),
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
                    child: GridView.builder(
                      itemCount: currentFeatures.where((feature) => !selectedSlots.contains(feature)).length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16.h,
                            crossAxisSpacing: 36.w,
                          ),
                      itemBuilder: (context, index) {
                        final name = visibleFeatures[index];
                        final icon = featureIcons[name];
                        return Draggable<String>(
                          data: name,
                          feedback: Transform.translate(
                            offset: Offset(-25, 0),
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
                                          offset: Offset(0, 3)
                                        )
                                      ]
                                    ),
                                    child: SvgPicture.asset(
                                      icon!,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
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
                                  SvgPicture.asset(
                                    icon,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(height: 4.h),
                                  Expanded(
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
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
                              }
                            },
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    icon,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(height: 4.h),
                                  Expanded(
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _navItem(String label, String iconPath, {bool isDraggingOver = false}) {
  final isLabel = label != "Trang chủ" && label != "Ứng dụng";
  if (isDraggingOver && isLabel) {
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
                  width: 24.w,
                  height: 24.h,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: 18.2.w,
                  height: 19.2.h,
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
              child: Text('', style: TextStyle(fontSize: 12.sp))),
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
            decoration: BoxDecoration(
              boxShadow: isLabel ? [
                BoxShadow(
                  color: Color(0xFF1AAF74).withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ]: null
            ),
            child: SvgPicture.asset(
              iconPath,
              colorFilter: isLabel
                  ? const ColorFilter.mode(Color(0xFF1AAF74), BlendMode.srcIn) : null,
              width:isLabel? 24.w : 18.w,
              height:isLabel ? 24.h : 18.h,
            ),
          ),
          if (isLabel)
            Positioned(
              right: -8,
              top: -10,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 4.w, color: Color(0xFF1A1D1F)),
                  color: Color(0xFF1A1D1F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove_circle,
                  size: 14.sp,
                  color: Color(0xFF6F767E),
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: 4.h),
      SizedBox(
        height: 38.h,
        child: Text(
            label,
            textAlign: TextAlign.center,
            //maxLines: 1,
            //overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              color: isLabel ? Color(0xFF1AAF74) : Color(0xFF747A81),
              fontWeight: FontWeight.w700,
              fontSize: isLabel ? 12.sp : 8.sp,
              height: 1.5.h,
              letterSpacing: 0,
            ),
          ),
      ),
    ],
  );
}

Widget _navPlaceholder({bool isDraggingOver = false}) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isDraggingOver? 0.5 : 1,
              child: SvgPicture.asset(
                "assets/icons/default.svg",
                colorFilter: ColorFilter.mode(
                  isDraggingOver ? Color(0xFF1AAF74) : Color(0xFF6F767E),
                  BlendMode.srcIn,
                ),
                width: 24.w,
                height: 24.h,
              ),
            ),
            Opacity(
              opacity: isDraggingOver? 0.5 : 1,
              child: Container(
                width: 18.2.w,
                height: 19.2.h,
                decoration: BoxDecoration(
                  color: isDraggingOver ? Color(0xFF1AAF74) : Color(0xFF33383F),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 38.h,
            child: Text('', style: TextStyle(fontSize: 12.sp))),
      ],
    ),
  );
}

Widget _tab(String label, bool selected) {
  return Container(
    height: 28.h,
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
      color: selected ? Color(0xFF1AAF74) : Color(0xFF33383F4D),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Center(
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: selected ? Color(0xFFFFFFFF) : Color(0xFF6F767E),
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          height: 1.5.h,
          letterSpacing: 0,
        ),
      ),
    ),
  );
}
