import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:task_manager/db/task_db.dart';
import 'package:task_manager/enums/snackbar_status_enum.dart';
import 'package:task_manager/enums/task_group.dart';
import 'package:task_manager/services/navigation_service.dart';
import 'package:task_manager/shared_widgets/snackbar_widget.dart';
import '../../../enums/states_enum.dart';
import '../../../models/task/task.dart';

class TaskBloc {
  var heroTag = 'create';
  var dbTask = TaskDb('task_db');
  var tasks = <Task>[];
  var tasks$ = BehaviorSubject<DataState>.seeded(DataState.initial);
  var ctx = NavigationService.currentContext!;
  var selectedTask = Task();

  void refresh() {
    tasks$.add(DataState.success);
  }

  void getTasks() {
    tasks = [];
    tasks$.add(DataState.loading);
    var data = dbTask.getAll();
    for (var element in data) {
      tasks.add(Task.fromJson(element));
    }

    if (tasks.isEmpty) {
      tasks$.add(DataState.empty);
      return;
    }
    tasks$.add(DataState.success);
  }

  bool isTaskGroupEmpty(TaskGroup taskGroup) {
    var res = tasks
        .where((element) => element.status == (taskGroup == TaskGroup.done));
    print('resresresr ${res.isEmpty}');
    return res.isEmpty;
  }

  void createTask(Task task) async {
    tasks$.add(DataState.loading);
    var newTask = await dbTask.save(task.taskID!, task.toJson());
    tasks.add(Task.fromJson(newTask));
    tasks$.add(DataState.success);
    if (ctx.mounted) {
      Navigator.pop(ctx);
      SnackBarShared().circular('New Task Added', SnackBarStatus.success);
    }
  }

  void removeTask(
    Task task,
  ) async {
    // tasks$.add(DataState.loading);
    await dbTask.remove(task.taskID!);
    tasks.remove(task);
    // tasks$.add(DataState.success);
    if (ctx.mounted) {
      SnackBarShared().circular('Task Removed', SnackBarStatus.success);
    }
  }

  void updateTask(Task task) async {
    tasks$.add(DataState.loading);
    await dbTask.save(task.taskID!, task.toJson());
    var idx = tasks.indexWhere((element) => element.taskID == task.taskID);
    if (task != tasks[idx]) {
      tasks[idx] = task;

      if (ctx.mounted) {
        SnackBarShared().circular('Task Updated', SnackBarStatus.success);
      }
    }
    tasks$.add(DataState.success);
    if (ctx.mounted) {
      Navigator.pop(ctx);
    }
  }

  void updateTaskStatus(Task task) async {
    // tasks$.add(DataState.loading);
    await dbTask.save(task.taskID!, task.toJson());
    var idx = tasks.indexWhere((element) => element.taskID == task.taskID);
    if (task != tasks[idx]) {
      tasks[idx] = task;
      if (ctx.mounted) {
        SnackBarShared()
            .circular('Task Status Changed', SnackBarStatus.success);
      }
    }
    tasks$.add(DataState.success);
  }
}

    // dbTask.resetDb();