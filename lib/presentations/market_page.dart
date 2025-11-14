import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/bloc/filterCell/filter_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/widgets/market/animatedStockRow.dart';
import 'package:ui_bang_gia/widgets/market/animatedTopIndices.dart';
import 'package:ui_bang_gia/widgets/market/appbar.dart';
import 'package:ui_bang_gia/widgets/market/buildHeaderTable.dart';
import 'package:ui_bang_gia/widgets/market/table.dart';

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

    final List<Map<String,dynamic>> allMarket =[
      {
        "name": "ETF",
        "sub": [],
      },
      {
        "name": "Phái sinh",
        "sub": ["Phái sinh","VN30","VN100","GB05","GB10"],
      },
      {
        "name": "CW",
        "sub": [],
      },
      {
        "name": "UPCOM",
        "sub": [],
      },
      {
        "name": "HNX",
        "sub": [ "HNX","HNX30", "BOND"],
      },
      {
        "name": "HOSE",
        "sub": [ "HOSE","VN30","VN100","VNXALL","VNALL","VNMID","VMSML"],
      },
      {
        "name": "Ngành",
        "sub": ["Bảo hiểm", "Cơ sở hạ tầng giao thông vận tải", "Công nghệ thông tin tích hợp","Công ty chứng khoán"],
      },
    ];
    final List<String> allCatalog = [
      "Thủy sản",
      "Thép",
      "Dầu khí",
      "Khoáng sản",
      "Nông sản",
      "Chăn nuôi",
      "Trồng trọt",
      "Đánh bắt"
    ];

    final Map<String, List<String>> filterMarket = {
      "ETF": ["SHB","AAH"],
      "Phái sinh":["CVHM24011","FUEVFVNDD", "E1VFVN300"],
      "VN30": ["FUEVFVNDD"],
      "VN100": ["E1VFVN300"],
      "GB05": [],
      "GB10": [],
      "CW": ["VIC", "HPG","SHB","AAH", "AVI", "A32"],
      "UPCOM": ["MCH"],
      "HNX": ["HVN","VND","VNM","VCB"],
      "HNX30": ["PVS", "SHB"],
      "BOND": [],
      "HOSE":["HPG","MCH","HVN","SHB", "BVH","AAH","VIC", "AVI", "A32","VNM", "VCB", "MSN", "ACB","VND","PVS", "VJC"],
      "VNXALL": ["VNM", "SHB", "ABC", "HPG", "VJC", "FPT", "CMG","VND"],
      "VNALL": ["VNM", "VCB", "VIC", "HPG", "MSN", "FPT", "SSI", "VND", "BVH"],
      "VNMID": ["ABB", "ADG", "ABC", "ABT"],
      "VMSML": ["AAS", "AAH", "AVI", "A32"],
      "Bảo hiểm": ["BVH", "BMI"],
      "Cơ sở hạ tầng giao thông vận tải": ["VJC", "HVN"],
      "Công nghệ thông tin tích hợp": ["FPT", "CMG"],
      "Công ty chứng khoán": ["SSI", "VND"],
    };

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MarketBloc()..add(MarketEventLoadFirst(filterMap: filterMarket,)),),
        BlocProvider(create: (_) => MarketMenuBloc()),
        BlocProvider(create: (_) => FilterCellBloc()),
        BlocProvider(create: (_) => CatalogBloc()..add(LoadCatalogEvent(allCatalog)))
      ],
      child: Scaffold(
        backgroundColor: Color(0xFF111315),
        body: SafeArea(
          child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                                final orientation = size.width > size.height
                                    ? Orientation.landscape
                                    : Orientation.portrait;

                                if (orientation == Orientation.portrait) {
                                  return const SizedBox.shrink();
                                }
                              return CustomAppBar(allMarket: allMarket,filterMarket: filterMarket,allCatalog: state.allCatalog,);
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