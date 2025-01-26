import 'package:hive/hive.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/source/source.dart';

class HiveDataSource implements DataSource<Task> {
  final Box<Task> box;

  HiveDataSource(this.box);
  @override
  Future<Task> createOrUpdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(Task data) async {
    return data.delete();
  }

  @override
  Future<Future<int>> deleteAll() async {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((value) => value.id == id);
  }

  @override
  Future<List<Task>> getAll({String searchKeybord = ''}) async {
    return box.values.toList();
  }
}
