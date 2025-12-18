import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/core/injection.dart';

//Load dữ liệu
class LoadCatalogStateUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, dynamic>?> execute() async {
    return await _repository.loadCatalogState();
  }
}

// Mở menu
class ToggleCatalogUseCase {
  bool execute(bool currentIsOpen) {
    return !currentIsOpen;
  }
}

// Đóng menu
class CloseCatalogUseCase {
  bool execute() {
    return false;
  }
}

// Clear catalog được chọn
class ClearCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<void> execute() async {
    await _repository.clearSelectedCatalog();
  }
}

// Chọn 1 danh mục
class SelectCatalogUseCase {
  final _catalogRepository = getIt<CatalogRepository>();

  Future<String> execute(String category) async {
    await _catalogRepository.saveSelectedCatalog(category);
    return category;
  }
}

// Thêm danh mục
class AddCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<List<String>?> execute(String? selectedCatalog, List<String> currentCatalogs, String name) async {
    final updatedList = List<String>.from(currentCatalogs)..add(name);

    await _repository.saveAllCatalog(updatedList);

    return updatedList;
  }
}

//Sửa tên danh mục
class RenameCatalogParams {
  final List<String> currentCatalogs;
  final Map<String, List<String>> currentFilterCatalog;
  final String oldName;
  final String newName;

  RenameCatalogParams({
    required this.currentCatalogs,
    required this.currentFilterCatalog,
    required this.oldName,
    required this.newName,
  });
}

class RenameCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, dynamic>?> execute(RenameCatalogParams params) async {
    final updatedList = params.currentCatalogs.map((catalog) {
      return catalog == params.oldName ? params.newName : catalog;
    }).toList();

    final updatedFilterCatalog = Map<String, List<String>>.from(params.currentFilterCatalog);
    if (updatedFilterCatalog.containsKey(params.oldName)) {
      updatedFilterCatalog[params.newName] = updatedFilterCatalog.remove(params.oldName)!;
    }

    await _repository.saveCatalogState(
      selectedCatalog: params.newName,
      allCatalog: updatedList,
      filterCatalog: updatedFilterCatalog,
    );

    return {
      'catalogs': updatedList,
      'selectedCatalog': params.newName,
      'filterCatalog': updatedFilterCatalog,
    };
  }
}

// Xóa danh mục
class DeleteCatalogParams {
  final String? selectedCatalog;
  final List<String> currentCatalogs;
  final Map<String, List<String>> currentFilterCatalog;
  final String name;

  DeleteCatalogParams({
    required this.selectedCatalog,
    required this.currentCatalogs,
    required this.currentFilterCatalog,
    required this.name
  });
}

class DeleteCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, dynamic>> execute(DeleteCatalogParams params) async {
    final updatedList = List<String>.from(params.currentCatalogs)..remove(params.name);
    final updatedFilter = Map<String, List<String>>.from(params.currentFilterCatalog);
    updatedFilter.remove(params.name);

    await _repository.saveCatalogState(
      selectedCatalog: params.selectedCatalog,
      allCatalog: updatedList,
      filterCatalog: updatedFilter,
    );

    return {
      'allCatalog': updatedList,
      'selectedCatalog': params.selectedCatalog,
      'filterCatalog': updatedFilter,
    };
  }
}

// Thêm mã vào danh mục
class AddStockToCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, List<String>>?> execute(Map<String, List<String>> currentFilterCatalog, String catalogName, String stockSymbol) async {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentFilterCatalog);
    final currentStocks = updatedFilterCatalog[catalogName] ?? [];
    final updatedStocks = List<String>.from(currentStocks)..add(stockSymbol);
    updatedFilterCatalog[catalogName] = updatedStocks;

    await _repository.saveFilterCatalog(updatedFilterCatalog);

    return updatedFilterCatalog;
  }
}

// Xóa mã khỏi danh mục
class DeleteStockFromCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, List<String>>> execute(Map<String, List<String>> currentFilterCatalog, String catalogName, String stockSymbol) async {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentFilterCatalog);

    if (updatedFilterCatalog.containsKey(catalogName)) {
      final currentList = List<String>.from(updatedFilterCatalog[catalogName]!);
      currentList.remove(stockSymbol);
      updatedFilterCatalog[catalogName] = currentList;
    }

    await _repository.saveFilterCatalog(updatedFilterCatalog);

    return updatedFilterCatalog;
  }
}