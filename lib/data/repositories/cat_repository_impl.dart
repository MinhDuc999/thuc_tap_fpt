import 'dart:isolate';
import '../../config/injection.dart';
import '../../doman/repositories/cat_repository.dart';
import '../../models/cat_model/cat_model.dart';
import '../service/cat_service.dart';

class CatRepositoryImpl implements CatRepository{
  final _service = getIt<CatService>();

  @override
  Future<List<CatModel>> getCatImages() async{
    final data = await _service.getCats(10);

    final receivePort = ReceivePort();
    await Isolate.spawn(_processCats, [receivePort.sendPort, data]);
    return await receivePort.first;
  }

  static void _processCats(List<dynamic> args) {
    final sendPort = args[0] as SendPort;
    final cats = args[1] as List<CatModel>;
    final processed = cats.where((e) => e.url.isNotEmpty).toList();
    sendPort.send(processed);
  }
}