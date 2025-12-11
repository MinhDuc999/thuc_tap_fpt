import 'package:ui_bang_gia/models/stock/market_category_model.dart';
import 'package:ui_bang_gia/models/stock/market_filter_model.dart';

class AllMarket {
  static const List<MarketCategory> DEFAULT_MARKET = [
    MarketCategory(id: 1, name: "ETF", sub: []),
    MarketCategory(id: 2, name: "Phái sinh", sub: ["Phái sinh", "VN30", "VN100", "GB05", "GB10"]),
    MarketCategory(id: 3, name: "CW", sub: []),
    MarketCategory(id: 4, name: "UPCOM", sub: []),
    MarketCategory(id: 5, name: "HNX", sub: ["HNX", "HNX30", "BOND"]),
    MarketCategory(id: 6, name: "HOSE", sub: ["HOSE", "VN30", "VN100", "VNXALL", "VNALL", "VNMID", "VMSML"]),
    MarketCategory(id: 7, name: "Ngành", sub: ["Bảo hiểm", "Cơ sở hạ tầng giao thông vận tải", "Công nghệ thông tin tích hợp", "Công ty chứng khoán"]),
  ];
}

class MarketFilter {
  static const List<MarketFilterItem> DEFAULT_FILTER_LIST = [
    MarketFilterItem(id: 1, category: "ETF", stocks: ["SHB", "AAH"]),
    MarketFilterItem(id: 2, category: "Phái sinh", stocks: ["CVHM24011", "FUEVFVNDD", "E1VFVN300"]),
    MarketFilterItem(id: 3, category: "VN30", stocks: ["FUEVFVNDD"]),
    MarketFilterItem(id: 4, category: "VN100", stocks: ["E1VFVN300"]),
    MarketFilterItem(id: 5, category: "GB05", stocks: []),
    MarketFilterItem(id: 6, category: "GB10", stocks: []),
    MarketFilterItem(id: 7, category: "CW", stocks: ["VIC", "HPG", "SHB", "AAH", "AVI", "A32"]),
    MarketFilterItem(id: 8, category: "UPCOM", stocks: ["MCH"]),
    MarketFilterItem(id: 9, category: "HNX", stocks: ["HVN", "VND", "VNM", "VCB"]),
    MarketFilterItem(id: 10, category: "HNX30", stocks: ["PVS", "SHB"]),
    MarketFilterItem(id: 11, category: "BOND", stocks: []),
    MarketFilterItem(id: 12, category: "HOSE", stocks: ["HPG", "MCH", "HVN", "SHB", "BVH", "AAH", "VIC", "AVI", "A32", "VNM", "VCB", "MSN", "ACB", "VND", "PVS", "VJC"]),
    MarketFilterItem(id: 13, category: "VNXALL", stocks: ["VNM", "SHB", "ABC", "HPG", "VJC", "FPT", "CMG", "VND"]),
    MarketFilterItem(id: 14, category: "VNALL", stocks: ["VNM", "VCB", "VIC", "HPG", "MSN", "FPT", "SSI", "VND", "BVH"]),
    MarketFilterItem(id: 15, category: "VNMID", stocks: ["ABB", "ADG", "ABC", "ABT"]),
    MarketFilterItem(id: 16, category: "VMSML", stocks: ["AAS", "AAH", "AVI", "A32"]),
    MarketFilterItem(id: 17, category: "Bảo hiểm", stocks: ["BVH", "BMI"]),
    MarketFilterItem(id: 18, category: "Cơ sở hạ tầng giao thông vận tải", stocks: ["VJC", "HVN"]),
    MarketFilterItem(id: 19, category: "Công nghệ thông tin tích hợp", stocks: ["FPT", "CMG"]),
    MarketFilterItem(id: 20, category: "Công ty chứng khoán", stocks: ["SSI", "VND"]),
  ];

  static Map<String, List<String>> get DEFAULT_FILTER_MAP {
    return Map.fromEntries(
      DEFAULT_FILTER_LIST.map(
            (filter) => MapEntry(filter.category, filter.stocks),
      ),
    );
  }
}