import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filter_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/constants/market_filter.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/animatedStockRow.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/animatedTopIndices.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/appbar.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/buildHeaderTable.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/table.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollBodyController = ScrollController();
  final ScrollController _scrollBody1Controller = ScrollController();
  final ScrollController _horizontalHeaderController = ScrollController();
  final ScrollController _horizontalBodyController = ScrollController();


  @override
  void initState() {
    super.initState();
    _screen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _horizontalHeaderController.addListener(() {
      if (_horizontalBodyController.hasClients &&
          _horizontalBodyController.offset != _horizontalHeaderController.offset) {
        _horizontalBodyController.jumpTo(_horizontalHeaderController.offset);
      }
    });

    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.hasClients &&
          _horizontalHeaderController.offset != _horizontalBodyController.offset) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });

    _scrollBodyController.addListener(() {
      if ( _scrollBody1Controller.hasClients &&
          _scrollBody1Controller.offset != _scrollBodyController.offset) {
        _scrollBody1Controller.jumpTo(_scrollBodyController.offset);
      }
    });

    _scrollBody1Controller.addListener(() {
      if ( _scrollBodyController.hasClients &&
          _scrollBodyController.offset != _scrollBody1Controller.offset) {
        _scrollBodyController.jumpTo(_scrollBody1Controller.offset);
      }
    });

  }

  void _screen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _scrollController.dispose();
    _scrollBodyController.dispose();
    _scrollBody1Controller.dispose();
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterMarket = MarketFilter.DEFAULT_FILTER_MAP;
    final allMarket = AllMarket.DEFAULT_MARKET;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MarketBloc()),
        BlocProvider(create: (_) => MarketMenuBloc()),
        BlocProvider(create: (_) => FilterCellBloc()),
        BlocProvider(create: (_) => CatalogBloc())
      ],
      child: Scaffold(
        backgroundColor: Color(0xFF111315),
        body: SafeArea(
          child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                  scrollbars: false,
                ),
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      pinned: false,
                      floating: false,
                      expandedHeight: 45,
                      automaticallyImplyLeading: false,
                      backgroundColor: const Color(0xFF111315),
                      flexibleSpace: BlocBuilder<CatalogBloc,CatalogState>(
                        builder: (context,state) {
                          return LayoutBuilder(
                              builder: (context, constraints) {
                                final size = MediaQuery.of(context).size;
                                final orientation = size.width > size.height ? Orientation.landscape : Orientation.portrait;
                                if (orientation == Orientation.portrait) {
                                  return const SizedBox.shrink();
                                }
                              return CustomAppBar(allMarket: allMarket,filterMarket: filterMarket);
                            }
                          );
                        }
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          AnimatedTopIndices(),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<MarketBloc, MarketState>(
                        builder: (context, state) {
                          return Container(
                            color: const Color(0xFF111315),
                            child: Container(
                              height: 41,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1D1F),
                                border: const Border(
                                  left: BorderSide(
                                      color: Color(0xFF33383F), width: 1),
                                  right: BorderSide(
                                      color: Color(0xFF33383F), width: 1),
                                  top: BorderSide(
                                      color: Color(0xFF33383F), width: 1),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      controller: _horizontalHeaderController,
                                      scrollDirection: Axis.horizontal,
                                      child: BlocBuilder<FilterCellBloc,FilterCellState>(
                                        builder: (context,filterState) {
                                          final int visibleColumnCount = countVisibleColumns(filterState);
                                          final double totalWidth = 70.w * visibleColumnCount;
                                          return SizedBox(
                                            width: totalWidth,
                                              child: buildTableHeader(context, state));
                                        }
                                      ),
                                    ),
                                    buildFixedHeaderColumn(context, state),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<CatalogBloc,CatalogState>(
                          builder: (catalogContext, catalogState) {
                            return BlocBuilder<MarketBloc, MarketState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    final newOffset = _scrollBodyController.offset - details.delta.dy;
                                    _scrollBodyController.jumpTo(newOffset.clamp(
                                      0.0,
                                      _scrollBodyController.position.maxScrollExtent,
                                    ));
                                    if (_scrollBodyController.offset > 0 && _scrollBodyController.hasClients && _scrollBodyController.offset < 50 ) {
                                      _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }else if (_scrollBodyController.offset <= 0 && _scrollBodyController.hasClients && details.delta.dy > 0) {
                                      _scrollController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1D1F),
                                      border: const Border(
                                        left: BorderSide(
                                            color: Color(0xFF33383F), width: 1),
                                        right: BorderSide(
                                            color: Color(0xFF33383F), width: 1),
                                        bottom: BorderSide(
                                            color: Color(0xFF33383F), width: 1),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          SingleChildScrollView(
                                            controller: _horizontalBodyController,
                                            scrollDirection: Axis.horizontal,
                                            child: BlocBuilder<FilterCellBloc,FilterCellState>(
                                              builder: (context,filterState) {
                                                final int visibleColumnCount = countVisibleColumns(filterState);
                                                final double totalWidth = 70.w * visibleColumnCount;
                                                return SizedBox(
                                                  width: totalWidth,
                                                  child: ListView.builder(
                                                      controller: _scrollBody1Controller,
                                                      scrollDirection: Axis.vertical,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: state.stocks.length,
                                                      itemBuilder: (context, index) {
                                                        final s = state.stocks[index];
                                                        return AnimatedStockRow(
                                                          stock: s,
                                                          rowIndex: index,
                                                          totalRow: state.stocks.length,);
                                                      },
                                                    ),
                                                );
                                              }
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            controller: _scrollBodyController,
                                            scrollDirection: Axis.vertical,
                                            physics: NeverScrollableScrollPhysics(),
                                            child: buildFixedBodyColumn(state,state.stocks.length,catalogState),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}