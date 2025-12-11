import 'package:shared_core/models/feature_model.dart';
import 'package:shared_core/models/tab_model.dart';

abstract class NavigationData {
  static const List<FeatureModel> allFeatures = [
    FeatureModel(
      id: 1,
      key: 'home',
      displayName: 'Trang chủ',
      iconPath: 'assets/icons/trang_chu.svg',
      isFixed: true,
    ),
    FeatureModel(
      id: 2,
      key: 'order_book',
      displayName: 'Sổ lệnh',
      iconPath: 'assets/icons/tin_tuc.svg',
    ),
    FeatureModel(
      id: 3,
      key: 'place_order',
      displayName: 'Đặt lệnh',
      iconPath: 'assets/icons/dat_lenh.svg',
    ),
    FeatureModel(
      id: 4,
      key: 'assets',
      displayName: 'Tài sản',
      iconPath: 'assets/icons/thi_truong.svg',
    ),
    FeatureModel(
      id: 5,
      key: 'apps',
      displayName: 'Ứng dụng',
      iconPath: 'assets/icons/ung_dung.svg',
      isFixed: true,
    ),
    FeatureModel(
      id: 6,
      key: 'chart',
      displayName: 'Biểu đồ',
      iconPath: 'assets/icons/bieu_do.svg',
    ),
    FeatureModel(
      id: 7,
      key: 'price_board',
      displayName: 'Bảng giá',
      iconPath: 'assets/icons/bang_gia.svg',
    ),
    FeatureModel(
      id: 8,
      key: 'transfer',
      displayName: 'Chuyển tiền',
      iconPath: 'assets/icons/chuyen_tien.svg',
    ),
    FeatureModel(
      id: 9,
      key: 'account',
      displayName: 'Tài khoản',
      iconPath: 'assets/icons/tai_khoan.svg',
    ),
    FeatureModel(
      id: 10,
      key: 'smart_otp',
      displayName: 'Smart OTP',
      iconPath: 'assets/icons/OTP.svg',
    ),
    FeatureModel(
      id: 11,
      key: 'loan',
      displayName: 'Tiền cho vay',
      iconPath: 'assets/icons/thi_truong.svg',
    ),
    FeatureModel(
      id: 12,
      key: 'notification_settings',
      displayName: 'Cài đặt Thông báo',
      iconPath: 'assets/icons/thong_bao.svg',
    ),
    FeatureModel(
      id: 13,
      key: 'technical_analysis',
      displayName: 'Phân tích Kỹ thuật',
      iconPath: 'assets/icons/pt_ky_thuat.svg',
    ),
    FeatureModel(
      id: 14,
      key: 'market_overview',
      displayName: 'Tổng quan Thị trường',
      iconPath: 'assets/icons/thi_truong.svg',
    ),
    FeatureModel(
      id: 15,
      key: 'analysis',
      displayName: 'Nhận định',
      iconPath: 'assets/icons/nhan_dinh.svg',
    ),
    FeatureModel(
      id: 16,
      key: 'news',
      displayName: 'Tin tức',
      iconPath: 'assets/icons/tin_tuc.svg',
    ),
    FeatureModel(
      id: 17,
      key: 'settings',
      displayName: 'Cài đặt',
      iconPath: 'assets/icons/cai_dat.svg',
    ),
  ];

  static const List<TabModel> tabs = [
    TabModel(
      id: 1,
      key: 'all',
      displayName: 'Tất cả',
      featureKeys: [
        'home',
        'order_book',
        'place_order',
        'assets',
        'apps',
        'chart',
        'price_board',
        'transfer',
        'account',
        'smart_otp',
        'loan',
        'notification_settings',
        'technical_analysis',
        'market_overview',
        'analysis',
        'news',
        'settings',
      ],
    ),
    TabModel(
      id: 2,
      key: 'frequently_used',
      displayName: 'Hay dùng',
      featureKeys: [
        'price_board',
        'news',
        'notification_settings',
        'market_overview',
        'settings',
      ],
    ),
    TabModel(
      id: 3,
      key: 'trading',
      displayName: 'Giao dịch',
      featureKeys: [
        'order_book',
        'place_order',
        'transfer',
        'loan',
        'smart_otp',
      ],
    ),
    TabModel(
      id: 4,
      key: 'asset_management',
      displayName: 'Quản lý tài sản',
      featureKeys: [
        'account',
        'assets',
        'chart',
        'analysis',
        'technical_analysis',
      ],
    ),
  ];

  static FeatureModel? getFeatureByKey(String key) =>
      allFeatures.cast<FeatureModel?>().firstWhere(
            (f) => f?.key == key,
        orElse: () => null,
      );

  static List<FeatureModel> getFeaturesByTab(String tabKey) {
    final tab = tabs.cast<TabModel?>().firstWhere(
          (t) => t?.key == tabKey,
      orElse: () => null,
    );
    if (tab == null) return [];

    return tab.featureKeys.map(getFeatureByKey).whereType<FeatureModel>().toList();
  }
}