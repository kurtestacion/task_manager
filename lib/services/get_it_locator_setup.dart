import 'package:get_it/get_it.dart';
import '../modules/task/task_bloc.dart';

final locator = GetIt.I;

void getItLocatorSetup() {
  locator.registerLazySingleton<TaskBloc>(() => TaskBloc());
}
