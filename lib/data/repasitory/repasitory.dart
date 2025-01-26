import 'package:todolist/data/source/source.dart';

class Repasitory<T> implements DataSource<T> {
  final DataSource<T> dataSource;

  Repasitory(this.dataSource);
  @override
  Future<T> createOrUpdate(T data) {
    return dataSource.createOrUpdate(data);
  }

  @override
  Future<void> delete(T data) {
    return dataSource.delete(data);
  }

  @override
  Future<void> deleteAll() {
    return deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return deleteById(id);
  }

  @override
  Future<T> findById(id) {
    return findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeybord = ''}) {
    return getAll(searchKeybord: searchKeybord);
  }
}
