import 'package:flutter/material.dart';
import 'package:shared_core/constants/feature_data.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_core/models/feature_model.dart';

//Mở
class OpenSearchViewUseCase {
  bool execute(bool currentState) {
    return !currentState;
  }
}

//Đóng
class CloseSearchViewUseCase {
  void execute(FocusNode focusNode) {
    focusNode.unfocus();
  }
}

//Thêm feature
class AllFeatureParams {
  final String feature;
  final List<String?> currentSlots;

  AllFeatureParams({
    required this.feature,
    required this.currentSlots,
  });
}
class AllFeatureUseCase {
  final _repository = getIt<NavigationRepository>();

  Future<List<String?>?> execute(AllFeatureParams params) async {
    final feature = NavigationData.getFeatureByKey(params.feature);
    if (feature == null || feature.isFixed) return null;

    final updatedSlots = List<String?>.from(params.currentSlots);

    final emptyIndex = updatedSlots.indexWhere((slot) => slot == null);

    if (emptyIndex == -1) return null;

    updatedSlots[emptyIndex] = feature.key;

    if (updatedSlots.where((e) => e != null).length >= 5) {
      await _repository.saveNavigationState(selectedSlots: updatedSlots);
    }

    return updatedSlots;
  }
}

//Xóa feature
class RemoveFeatureParams {
  final String feature;
  final List<String?> currentSlots;
  final List<FeatureModel>? currentSearchResults;
  final List<String>? recentlyRemoved;

  RemoveFeatureParams({
    required this.feature,
    required this.currentSlots,
    this.currentSearchResults,
    this.recentlyRemoved,
  });
}

class RemoveFeatureUseCase {
  final _repository = getIt<NavigationRepository>();

  Future<Map<String, dynamic>?> execute(RemoveFeatureParams params) async {
    final feature = NavigationData.getFeatureByKey(params.feature);
    if (feature == null || feature.isFixed) return null;

    final updatedSlots = List<String?>.from(params.currentSlots);

    final index = updatedSlots.indexOf(feature.key);
    if (index == -1) return null;

    updatedSlots[index] = null;

    List<FeatureModel>? updatedSearchResults = params.currentSearchResults != null
        ? List<FeatureModel>.from(params.currentSearchResults!)
        : [];

    updatedSearchResults.removeWhere((f) => f.key == feature.key);
    updatedSearchResults.insert(0, feature);

    List<String> updatedRecentlyRemoved = params.recentlyRemoved != null
        ? List<String>.from(params.recentlyRemoved!)
        : [];

    updatedRecentlyRemoved.remove(feature.key);
    updatedRecentlyRemoved.insert(0, feature.key);

    if (updatedSlots.where((e) => e != null).length >= 5) {
      await _repository.saveNavigationState(selectedSlots: updatedSlots);
    }

    return {
      'updatedSlots': updatedSlots,
      'updatedSearchResults': updatedSearchResults,
      'updatedRecentlyRemoved': updatedRecentlyRemoved,
    };
  }
}

//Thay thế feature
class ReplaceFeatureParams {
  final String feature;
  final int targetIndex;
  final List<String?> currentSlots;
  final List<FeatureModel>? currentSearchResults;
  final List<String>? recentlyRemoved;

  ReplaceFeatureParams({
    required this.feature,
    required this.targetIndex,
    required this.currentSlots,
    this.currentSearchResults,
    this.recentlyRemoved,
  });
}

class ReplaceFeatureUseCase {
  final _repository = getIt<NavigationRepository>();

  Future<Map<String, dynamic>?> execute(ReplaceFeatureParams params) async {
    final newFeature = NavigationData.getFeatureByKey(params.feature);
    if (newFeature == null || newFeature.isFixed) return null;

    final slots = List<String?>.from(params.currentSlots);
    final targetKey = slots[params.targetIndex];

    if (targetKey != null && NavigationData.getFeatureByKey(targetKey)?.isFixed == true) {
      return null;
    }

    final existingIndex = slots.indexOf(params.feature);

    // Swap nếu feature đã tồn tại
    if (existingIndex != -1 && existingIndex != params.targetIndex) {
      slots[existingIndex] = targetKey;
      slots[params.targetIndex] = params.feature;

      if (slots.where((e) => e != null).length >= 5) {
        await _repository.saveNavigationState(selectedSlots: slots);
      }

      return {
        'updatedSlots': slots,
        'updatedSearchResults': params.currentSearchResults ?? [],
        'updatedRecentlyRemoved': params.recentlyRemoved,
      };
    }

    // Replace và update search/recently
    slots[params.targetIndex] = params.feature;

    final searchResults = List<FeatureModel>.from(params.currentSearchResults ?? [])
      ..removeWhere((f) => f.key == params.feature);

    if (targetKey != null) {
      final replaced = NavigationData.getFeatureByKey(targetKey);
      if (replaced != null) searchResults.insert(0, replaced);
    }

    final recentlyRemoved = List<String>.from(params.recentlyRemoved ?? []);
    if (targetKey != null) {
      recentlyRemoved.remove(targetKey);
      recentlyRemoved.insert(0, targetKey);
    }

    if (slots.where((e) => e != null).length >= 5) {
      await _repository.saveNavigationState(selectedSlots: slots);
    }

    return {
      'updatedSlots': slots,
      'updatedSearchResults': searchResults,
      'updatedRecentlyRemoved': recentlyRemoved,
    };
  }
}

//Tìm kiếm feature
class SearchFeatureParams {
  final String query;
  final List<String?> currentSlots;

  SearchFeatureParams({
    required this.query,
    required this.currentSlots,
  });
}
class SearchFeatureUseCase {
  List<FeatureModel> execute(SearchFeatureParams params) {
    final query = params.query.toLowerCase().trim();

    if (query.isEmpty) {
      return <FeatureModel>[];
    }

    final results = NavigationData.allFeatures.where((feature) {
      if (params.currentSlots.contains(feature.key)) {
        return false;
      }

      return feature.displayName.toLowerCase().startsWith(query);
    }).toList();

    return results;
  }
}

//Chọn vị trí index
class ChangeButtonUseCase {
  final _repository = getIt<NavigationRepository>();

  Future<void> execute(int index) async {
    await _repository.saveNavigationState(selectedIndex: index);
  }
}

//Chọn tab
class ChangeTabUseCase {
  Future<void> execute(int index) async {
    return;
  }
}