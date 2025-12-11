import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/core/injection.dart';

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

  Future<void> execute() async{
    await _repository.saveCatalogState(selectedCatalog: null);
  }
}

// Chọn 1 danh mục
class SelectCatalogUseCase {
  final _repository  = getIt<CatalogRepository>();
  Future<String> execute(String category) async {
    await _repository.saveCatalogState(selectedCatalog: category);
    return category;
  }
}

// Thêm danh mục
class AddCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<List<String>?> execute(String? selectedCatalog,List<String> currentCatalogs, String name) async {
    if (currentCatalogs.contains(name)) {
      return null;
    }

    final updatedList = List<String>.from(currentCatalogs)..add(name);
    await _repository.saveCatalogState(selectedCatalog:selectedCatalog,allCatalog: updatedList);
    return updatedList;
  }
}

//Sửa tên danh mục
class RenameCatalogParams {
  final List<String> currentCatalogs;
  final String? currentSelected;
  final Map<String, List<String>> currentFilterCatalog;
  final String oldName;
  final String newName;

  RenameCatalogParams({
    required this.currentCatalogs,
    required this.currentSelected,
    required this.currentFilterCatalog,
    required this.oldName,
    required this.newName,
  });
}

class RenameCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, dynamic>?> execute(RenameCatalogParams params) async {
    if (params.currentCatalogs.contains(params.newName)) {
      return null;
    }

    final updatedList = params.currentCatalogs.map((catalog) {
      return catalog == params.oldName ? params.newName : catalog;
    }).toList();

    final updatedSelectedCatalog =
    params.currentSelected == params.oldName ? params.newName : params.currentSelected;

    final updatedFilterCatalog = Map<String, List<String>>.from(params.currentFilterCatalog);
    if (updatedFilterCatalog.containsKey(params.oldName)) {
      final stockList = updatedFilterCatalog[params.oldName]!;
      updatedFilterCatalog.remove(params.oldName);
      updatedFilterCatalog[params.newName] = stockList;
    }

    await _repository.saveCatalogState(
      selectedCatalog: updatedSelectedCatalog,
      allCatalog: updatedList,
      filterCatalog: updatedFilterCatalog,
    );

    return {
      'catalogs': updatedList,
      'selectedCatalog': updatedSelectedCatalog,
      'filterCatalog': updatedFilterCatalog,
    };
  }
}

// Xóa danh mục
class DeleteCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<List<String>> execute(String? selectedCatalog, List<String> currentCatalogs, String name) async {
    final updatedList = List<String>.from(currentCatalogs)..remove(name);
    await _repository.saveCatalogState(selectedCatalog:selectedCatalog,allCatalog: updatedList);
    return updatedList;
  }
}

// Thêm mã vào danh mục
class AddStockToCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, List<String>>?> execute(Map<String, List<String>> currentFilterCatalog, String catalogName, String stockSymbol) async {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentFilterCatalog);

    if (!updatedFilterCatalog.containsKey(catalogName)) {
      updatedFilterCatalog[catalogName] = [];
    }

    final currentStocks = updatedFilterCatalog[catalogName]!;

    if (currentStocks.contains(stockSymbol)) {
      return null;
    }

    final updatedStocks = List<String>.from(currentStocks)..add(stockSymbol);
    updatedFilterCatalog[catalogName] = updatedStocks;

    await _repository.saveCatalogState(selectedCatalog: catalogName,filterCatalog: updatedFilterCatalog);
    return updatedFilterCatalog;
  }
}

// Xóa mã khỏi danh mục
class DeleteStockFromCatalogUseCase {
  final _repository = getIt<CatalogRepository>();

  Future<Map<String, List<String>>> execute(Map<String, List<String>> currentFilterCatalog, String catalogName, String stockSymbol)async {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentFilterCatalog);

    if (updatedFilterCatalog.containsKey(catalogName)) {
      final currentList = List<String>.from(updatedFilterCatalog[catalogName]!);
      currentList.remove(stockSymbol);
      updatedFilterCatalog[catalogName] = currentList;
    }

    await _repository.saveCatalogState(selectedCatalog: catalogName,filterCatalog: updatedFilterCatalog);
    return updatedFilterCatalog;
  }
}