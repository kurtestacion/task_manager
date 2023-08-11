import 'package:hive/hive.dart';

class TaskDb {
  var serverName = '';
  final _hive = Hive.box('task_db');
  static TaskDb? _instance;

  TaskDb._(this.serverName);

  Future<Map<String, Object?>> save(
      String rowId, Map<String, dynamic> val) async {
    await _hive.put(rowId, val);
    return get(rowId);
  }

  List<Map<String, Object?>> getAll() {
    List<Map<String, Object?>> result = [];
    _hive.toMap().values.toList().forEach((element) {
      Map<String, Object?> convertedMap = {};
      element.forEach((key, value) {
        convertedMap[key.toString()] = value as Object;
      });

      result.add(convertedMap);
    });
    return result;
  }

  Future<Map<String, Object?>> get(String row) async {
    Map<String, Object?> convertedMap = {};
    var element = await _hive.get(row);
    element.forEach((key, value) {
      convertedMap[key.toString()] = value as Object;
    });
    return convertedMap;
  }

  Future<void> remove(String rowId) async {
    return await _hive.delete(rowId);
  }

  Future<void> resetDb() async {
    return await _hive.deleteFromDisk();
  }

  factory TaskDb(String? serverName) {
    _instance ??= TaskDb._(serverName ?? '');

    return _instance!;
  }
}
