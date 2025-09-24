import 'dart:async';
import 'package:btcat_di_getit/config/injection.dart';
import 'package:btcat_di_getit/doman/repositories/cat_repository.dart';
import 'package:flutter/foundation.dart';

import '../../models/cat_model/cat_model.dart';


class CatNotifier extends ChangeNotifier {
  final _repository = getIt<CatRepository>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final StreamController<List<CatModel>> _catStream = StreamController.broadcast();
  Stream<List<CatModel>> get catStream => _catStream.stream;

  List<CatModel>? _cachedCats;

  Future<void> loadCats() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final cats = await _repository.getCatImages();
      _cachedCats = cats;
      _catStream.add(cats);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<CatModel>? get cachedCats => _cachedCats;

  @override
  void dispose() {
    _catStream.close();
    isLoading.dispose();
    errorMessage.dispose();
    super.dispose();
  }
}
