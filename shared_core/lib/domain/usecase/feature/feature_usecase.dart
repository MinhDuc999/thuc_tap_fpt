import 'package:flutter/material.dart';
import 'package:shared_core/constants/feature_data.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

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
  final List<String>? currentSearchResults;
  final List<String>? recentlyRemoved;

  AllFeatureParams({
    required this.feature,
    required this.currentSlots,
    this.currentSearchResults,
    this.recentlyRemoved,
  });
}

class AllFeatureUseCase {
  final _repository = getIt<NavigationRepository>();

  Future<Map<String, dynamic>?> execute(AllFeatureParams params) async {
    final feature = NavigationData.getFeatureByKey(params.feature);
    if (feature == null) return null;
    if (feature.isFixed) return null;
    final updatedSlots = List<String?>.from(params.currentSlots);

    final emptyIndex = updatedSlots.indexWhere((slot) => slot == null);

    if (emptyIndex == -1) return null;

    updatedSlots[emptyIndex] = params.feature;

    List<String>? updatedSearchResults = params.currentSearchResults;
    if (updatedSearchResults != null) {
      updatedSearchResults = List<String>.from(updatedSearchResults);
      updatedSearchResults.remove(params.feature);
    }

    List<String>? updatedRecentlyRemoved = params.recentlyRemoved;
    if (updatedRecentlyRemoved != null) {
      updatedRecentlyRemoved = List<String>.from(updatedRecentlyRemoved);
      updatedRecentlyRemoved.remove(params.feature);
    }

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

//Xóa feature
class RemoveFeatureParams {
  final String feature;
  final List<String?> currentSlots;
  final List<String>? currentSearchResults;
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
    if (feature == null) return null;

    if (feature.isFixed) return null;

    final updatedSlots = List<String?>.from(params.currentSlots);

    final index = updatedSlots.indexOf(params.feature);
    if (index == -1) return null;

    updatedSlots[index] = null;

    List<String>? updatedSearchResults = params.currentSearchResults;
    if (updatedSearchResults != null) {
      updatedSearchResults = List<String>.from(updatedSearchResults);
      updatedSearchResults.remove(params.feature);
      updatedSearchResults.insert(0, params.feature);
    }

    List<String> updatedRecentlyRemoved = params.recentlyRemoved != null
        ? List<String>.from(params.recentlyRemoved!) : [];

    updatedRecentlyRemoved.remove(params.feature);
    updatedRecentlyRemoved.insert(0, params.feature);

    if (updatedRecentlyRemoved.length > 10) {
      updatedRecentlyRemoved = updatedRecentlyRemoved.sublist(0, 10);
    }

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
  final List<String>? currentSearchResults;
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
    if (newFeature == null) return null;

    if (newFeature.isFixed) return null;

    final updatedSlots = List<String?>.from(params.currentSlots);

    final currentFeatureKey = updatedSlots[params.targetIndex];
    if (currentFeatureKey != null) {
      final currentFeature = NavigationData.getFeatureByKey(currentFeatureKey);
      if (currentFeature?.isFixed == true) return null;
    }

    final existingIndex = updatedSlots.indexOf(params.feature);

    if (existingIndex != -1 && existingIndex != params.targetIndex) {
      final temp = updatedSlots[params.targetIndex];
      updatedSlots[params.targetIndex] = params.feature;
      updatedSlots[existingIndex] = temp;
    } else {
      final replacedFeatureKey = updatedSlots[params.targetIndex];
      updatedSlots[params.targetIndex] = params.feature;

      List<String>? updatedSearchResults = params.currentSearchResults;
      if (updatedSearchResults != null) {
        updatedSearchResults = List<String>.from(updatedSearchResults);
        updatedSearchResults.remove(params.feature);

        if (replacedFeatureKey != null &&
            !updatedSearchResults.contains(replacedFeatureKey)) {
          updatedSearchResults.insert(0, replacedFeatureKey);
        }
      }

      List<String>? updatedRecentlyRemoved = params.recentlyRemoved;
      if (replacedFeatureKey != null) {
        updatedRecentlyRemoved = List<String>.from(params.recentlyRemoved ?? []);
        updatedRecentlyRemoved.remove(replacedFeatureKey);
        updatedRecentlyRemoved.insert(0, replacedFeatureKey);

        if (updatedRecentlyRemoved.length > 10) {
          updatedRecentlyRemoved = updatedRecentlyRemoved.sublist(0, 10);
        }
      }

      if (updatedSlots.where((e) => e != null).length >= 5) {
        await _repository.saveNavigationState(selectedSlots: updatedSlots);
      }

      return {
        'updatedSlots': updatedSlots,
        'updatedSearchResults': updatedSearchResults,
        'updatedRecentlyRemoved': updatedRecentlyRemoved,
      };
    }

    if (updatedSlots.where((e) => e != null).length >= 5) {
      await _repository.saveNavigationState(selectedSlots: updatedSlots);
    }

    return {
      'updatedSlots': updatedSlots,
      'updatedSearchResults': params.currentSearchResults ?? [],
      'updatedRecentlyRemoved': params.recentlyRemoved,
    };
  }
}

//Tìm kiếm feature
class SearchFeatureParams {
  final String query;
  final List<String> allFeatures;
  final List<String?> currentSlots;

  SearchFeatureParams({
    required this.query,
    required this.allFeatures,
    required this.currentSlots,
  });
}

class SearchFeatureUseCase {
  Map<String, dynamic>? execute(SearchFeatureParams params) {
    final query = params.query.toLowerCase().trim();

    if (query.isEmpty) {
      return {
        'results': <String>[],
        'query': '',
      };
    }

    final results = NavigationData.allFeatures.where((feature) {
      if (params.currentSlots.contains(feature.key)) {
        return false;
      }

      return feature.displayName.toLowerCase().startsWith(query);
    })
        .map((feature) => feature.key)
        .toList();

    return {
      'results': results,
      'query': query,
    };
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