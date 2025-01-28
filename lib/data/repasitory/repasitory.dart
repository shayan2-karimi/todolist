import 'package:flutter/cupertino.dart';
import 'package:todolist/data/source/source.dart';

class Repasitory<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> dataSource;

  Repasitory(this.dataSource);
  @override
  Future<T> createOrUpdate(T data) async {
    final result = await dataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async {
    dataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await dataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    dataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return dataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeybord = ''}) {
    return dataSource.getAll(searchKeybord: searchKeybord);
  }
}
