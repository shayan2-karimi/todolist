import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repasitory/repasitory.dart';

part 'edite_screen_cubit_state.dart';

class EditeScreenCubitCubit extends Cubit<EditeScreenCubitState> {
  final Task taskItem;
  final Repasitory<Task> repasitory;
  EditeScreenCubitCubit(this.taskItem, this.repasitory)
      : super(EditeScreenCubitInitial(taskItem));

  void onChangedPriority(Priority priority) {
    taskItem.priority = priority;
    emit(EditeScreenPriorityChange(taskItem));
  }

  void onChangedText(String text) {
    taskItem.name = text;
  }

  void onChangedClickButton() {
    repasitory.createOrUpdate(taskItem);
  }
}
