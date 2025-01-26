abstract class DataSource<T> {
  Future<List<T>> getAll({String searchKeybord});
  Future<T> findById(dynamic id);
  Future<void> delete(T data);
  Future<void> deleteAll();
  Future<void> deleteById(dynamic id);
  Future<T> createOrUpdate(T data);
}
