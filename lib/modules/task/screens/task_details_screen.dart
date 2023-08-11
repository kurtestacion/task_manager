import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/enums/snackbar_status_enum.dart';
import 'package:task_manager/modules/task/task_bloc.dart';
import 'package:task_manager/shared_widgets/snackbar_widget.dart';
import 'package:task_manager/shared_widgets/textfield_widget.dart';

import '../../../models/task/task.dart';
import '../../../services/get_it_locator_setup.dart';
import '../../../shared_widgets/button_widget.dart';
import '../../../shared_widgets/date_picker_widget.dart';
import '../../../utils/datetime.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final taskDetailsBloc = locator.get<TaskBloc>();
  final titleCtrler = TextEditingController();
  final descCtrler = TextEditingController();
  final dueDateCtrler = TextEditingController();
  var task = Task();
  var dueDate = DateTime.now().add(const Duration(hours: 24));
  var isEnabled = false;
  var dateCreated = DateTime.now();

  @override
  void initState() {
    task = taskDetailsBloc.selectedTask;
    if (task.taskID != null) {
      titleCtrler.text = task.title ?? '';
      descCtrler.text = task.description ?? '';
      var dueDate2 = milSecSinceEpochToDateTime(task.dueDate!);
      dueDateCtrler.text = DateFormat('MMM, d yyyy hh:mm aa').format(dueDate2);
      dueDate = dueDate2;
      dateCreated = milSecSinceEpochToDateTime(task.dateCreated!);
      isEnabled = task.status!;
      // dueDateCtrler.text =
    } else {
      dateCreated = DateTime.now();
      dueDateCtrler.text = DateFormat('MMM, d yyyy hh:mm aa').format(dueDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Task Info',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                textFieldShared(ctrler: titleCtrler, labelText: 'Title'),
                const SizedBox(height: 10),
                textFieldShared(
                  ctrler: descCtrler,
                  labelText: 'Description',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Status',
                  style: TextStyle(color: Colors.black54),
                ),
                Checkbox.adaptive(
                  value: isEnabled,
                  onChanged: (val) {
                    setState(() {
                      if (val == null) {
                        return;
                      }
                      isEnabled = val;
                    });
                  },
                ),
                const SizedBox(height: 10),
                textFieldShared(
                    ctrler: dueDateCtrler,
                    labelText: 'Due Date',
                    onTap: () async {
                      dueDate = await datePicker(dueDate);
                      if (dueDate == '') {
                        return;
                      }
                      dueDateCtrler.text =
                          DateFormat('MMM, d yyyy hh:mm aa').format(dueDate);
                    }),
                const SizedBox(
                  height: 30,
                ),
                if (task.taskID != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Date Created:  ${DateFormat('MMM, d yyyy hh:mm aa').format(dateCreated)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
              ]),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: StretchableButton(
                  onPressed: () {
                    if (descCtrler.text.isEmpty || titleCtrler.text.isEmpty) {
                      SnackBarShared().circular(
                          'Title and Description must be filled',
                          SnackBarStatus.error);
                      return;
                    }

                    var newTask = Task(
                        description: descCtrler.text,
                        title: titleCtrler.text,
                        taskID: dateCreated.millisecondsSinceEpoch.toString(),
                        dateCreated:
                            dateCreated.millisecondsSinceEpoch.toString(),
                        dueDate: dueDate.millisecondsSinceEpoch.toString(),
                        status: isEnabled);

                    if (task.taskID != null) {
                      var updatedTask = newTask.copyWith(
                          taskID: task.taskID, dateCreated: task.dateCreated);
                      taskDetailsBloc.updateTask(updatedTask);
                      return;
                    }
                    taskDetailsBloc.createTask(newTask);
                  },
                  text: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
