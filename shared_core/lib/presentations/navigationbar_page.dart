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
import 'package:shared_core/constants/feature_data.dart';
import 'package:shared_core/presentations/widgets/appbar.dart';
import 'package:shared_core/presentations/widgets/navItemWidget.dart';
import 'package:shared_core/presentations/widgets/navPlaceholderWidget.dart';
import 'package:shared_core/presentations/widgets/buildFeatureSearch.dart';
import 'package:shared_core/presentations/widgets/tabWidget.dart';
import 'package:shared_core/models/feature_model.dart';

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
    super.initState();
    _screen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
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
    final allFeatures = NavigationData.allFeatures;
    final tabs = NavigationData.tabs;

    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: SafeArea(
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
                    BlocBuilder<NavigationBloc, NavigationState>(
                      buildWhen: (previous, current) =>
                      previous.selectedSlots != current.selectedSlots ||
                          previous.selectedIndex != current.selectedIndex ||
                          previous.selected != current.selected ||
                          previous.isSearchViewOpen != current.isSearchViewOpen,
                      builder: (context, state) {
                        final selectedSlots = state.selectedSlots;
                        final hasEnoughSelected = state.hasEnoughSelected;
                        final selected = state.selected;
                        final selectedIndex = state.selectedIndex;
                        return SizedBox(
                          width: double.infinity,
                          height: 214.h,
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (state.isSearchViewOpen) {
                                      context.read<NavigationBloc>().add(CloseSearchView());
                                      context.read<NavigationBloc>().searchController.clear();
                                      context.read<NavigationBloc>().add(SearchFeature(''));
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
                                                final featureKey = selectedSlots[index];
                                                final feature = featureKey != null ? NavigationData.getFeatureByKey(featureKey) : null;
                                                return Expanded(
                                                  child: AnimatedBuilder(
                                                    animation: _animationController,
                                                    builder: (context, child) {
                                                      if (feature?.isFixed == true) {
                                                        return child!;
                                                      }
                                                      final angle = cos(_animationController.value * 2 * pi) * 0.09;
                                                      return Transform.rotate(
                                                        angle: angle,
                                                        child: child,
                                                      );
                                                    },
                                                    child: DragTarget<String>(
                                                      onAcceptWithDetails: (details) {
                                                        context.read<NavigationBloc>().add(ReplaceFeature(details.data, index));
                                                      },
                                                      onWillAcceptWithDetails: (details) => true,
                                                      builder: (context, candidateData, rejectedData) {
                                                        final isDraggingOver = candidateData.isNotEmpty;
                                                        if (feature == null) {
                                                          return navPlaceholder(isDraggingOver: isDraggingOver);
                                                        }
                                                        return GestureDetector(
                                                          onTap: () {
                                                            if (feature.isFixed) {
                                                              if (state.isSearchViewOpen) {
                                                                context.read<NavigationBloc>().add(CloseSearchView());
                                                                context.read<NavigationBloc>().searchController.clear();
                                                                context.read<NavigationBloc>().add(SearchFeature(''));
                                                              }
                                                              return;
                                                            }
                                                            context.read<NavigationBloc>().add(RemoveFeature(feature.key));
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: navItem(feature.key, isDraggingOver: isDraggingOver),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        // Button indicators row
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
                                                          decoration: BoxDecoration(border: isActive ? Border.all(
                                                              width: 3.5.w,
                                                              color: Color(0xFF1AAF74),
                                                            ) : Border.all(
                                                              width: 0.5.w,
                                                              color: Color(0xFF6F767E).withValues(alpha: 0.3),
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
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Error/Info message
                              GestureDetector(
                                onTap: () {
                                  if (state.isSearchViewOpen) {
                                    context.read<NavigationBloc>().add(CloseSearchView());
                                    context.read<NavigationBloc>().searchController.clear();
                                    context.read<NavigationBloc>().add(SearchFeature(''));
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              BlocBuilder<NavigationBloc, NavigationState>(
                                buildWhen: (previous, current) =>
                                previous.selectedTab != current.selectedTab || previous.isSearchViewOpen != current.isSearchViewOpen,
                                builder: (context, state) {
                                  final selectedTab = state.selectedTab;
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (!state.isSearchViewOpen) {
                                            context.read<NavigationBloc>().add(OpenSearchView());
                                            Future.delayed(const Duration(milliseconds: 300), () {
                                              context.read<NavigationBloc>().searchFocusNode.requestFocus();
                                            });
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 28,
                                          width: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(0XFF33383F),
                                            borderRadius: BorderRadius.circular(28.r),
                                          ),
                                          child: SizedBox(
                                            child: SvgPicture.asset("assets/icons/search.svg"),
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
                                                  child: tab(tabs[i].displayName, selectedTab == i),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: BlocBuilder<NavigationBloc, NavigationState>(
                        buildWhen: (previous, current) =>
                        previous.selectedSlots != current.selectedSlots ||
                            previous.selectedTab != current.selectedTab,
                        builder: (context, state) {
                          final selectedSlots = state.selectedSlots;
                          final selectedTab = state.selectedTab;
                          final currentTab = tabs[selectedTab];
                          final currentFeatures = NavigationData.getFeaturesByTab(currentTab.key);
                          final visibleFeatures = currentFeatures.where((feature) => !selectedSlots.contains(feature.key)).toList();
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: GridView.builder(
                              itemCount: visibleFeatures.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 24.5.w,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final feature = visibleFeatures[index];
                                return Draggable<String>(
                                  data: feature.key,
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
                                                ),
                                              ],
                                            ),
                                            child: SvgPicture.asset(feature.iconPath),
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
                                            child: SvgPicture.asset(feature.iconPath),
                                          ),
                                          SizedBox(height: 4.h),
                                          Expanded(
                                            child: Text(
                                              feature.displayName,
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
                                        context.read<NavigationBloc>().add(AllFeature(feature.key));
                                      } else {
                                        context.read<NavigationBloc>().add(ReplaceFeature(feature.key, 3));
                                      }
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 23.h,
                                            child: SvgPicture.asset(feature.iconPath),
                                          ),
                                          SizedBox(height: 4.h),
                                          Expanded(
                                            child: Text(
                                              feature.displayName,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<NavigationBloc, NavigationState>(
                buildWhen: (previous, current) =>
                previous.isSearchViewOpen != current.isSearchViewOpen ||
                    previous.searchResults != current.searchResults ||
                    previous.searchQuery != current.searchQuery ||
                    previous.recentlyRemovedFeature != current.recentlyRemovedFeature ||
                    previous.selectedSlots != current.selectedSlots,
                builder: (context, state) {
                  final searchController = context.read<NavigationBloc>().searchController;
                  final searchFocus = context.read<NavigationBloc>().searchFocusNode;
                  final searchResults = state.searchResults;
                  final hasQuery = (state.searchQuery ?? '').isNotEmpty;
                  final visibleAllFeatures = allFeatures.where((feature) => !state.selectedSlots.contains(feature.key)).toList();
                  List<FeatureModel> suggestedFeatures;
                  if (!hasQuery) {
                    suggestedFeatures = List<FeatureModel>.from(visibleAllFeatures);
                    if (state.recentlyRemovedFeature != null && state.recentlyRemovedFeature!.isNotEmpty) {
                      for (var removedFeatureKey in state.recentlyRemovedFeature!.reversed) {
                        final removedFeature = NavigationData.getFeatureByKey(removedFeatureKey);
                        if (removedFeature != null) {
                          suggestedFeatures.removeWhere((f) => f.key == removedFeatureKey);
                          suggestedFeatures.insert(0, removedFeature);
                        }
                      }
                    }
                    suggestedFeatures = suggestedFeatures.take(4).toList();
                  } else {
                    suggestedFeatures = searchResults ?? [];
                  }

                  return AnimatedPositioned(
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
                              hasQuery ? "Kết quả tìm kiếm (${suggestedFeatures.length})" : "Gợi ý cho bạn (${suggestedFeatures.length})",
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
                            child: suggestedFeatures.isEmpty ? SizedBox(height: 10) : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: suggestedFeatures.length,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final feature = suggestedFeatures[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: buildFeatureItem(
                                    context,
                                    feature.key,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            color: Color(0xFF1A1D1F),
                            padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 12.h),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<NavigationBloc>().add(CloseSearchView());
                                    searchController.clear();
                                    context.read<NavigationBloc>().add(SearchFeature(''));
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
                                        suffixIcon: searchController.text.isNotEmpty ? GestureDetector(
                                          onTap: () {
                                            searchController.clear();
                                            context.read<NavigationBloc>().add(SearchFeature(''));
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Color(0xFF6F767E),
                                            size: 20.sp,
                                          ),
                                        ) : null,
                                      ),
                                      onChanged: (value) {
                                        context.read<NavigationBloc>().add(SearchFeature(value));
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}