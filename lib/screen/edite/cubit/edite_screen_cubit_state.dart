part of 'edite_screen_cubit_cubit.dart';

@immutable
sealed class EditeScreenCubitState {
  final Task repasitory;

  const EditeScreenCubitState(this.repasitory);
}

final class EditeScreenCubitInitial extends EditeScreenCubitState {
  const EditeScreenCubitInitial(super.repasitory);
}

final class EditeScreenPriorityChange extends EditeScreenCubitState {
  const EditeScreenPriorityChange(super.repasitory);
}
