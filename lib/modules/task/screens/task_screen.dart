import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:task_manager/constants/const.dart';
import 'package:task_manager/enums/task_group.dart';
import 'package:task_manager/modules/task/screens/task_details_screen.dart';
import 'package:task_manager/shared_widgets/center_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../../enums/states_enum.dart';
import '../../../models/task/task.dart';
import '../../../services/get_it_locator_setup.dart';
import '../../../services/routes.dart';
import '../task_bloc.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  final taskBloc = locator.get<TaskBloc>();
  final taskStatus$ = BehaviorSubject<String>.seeded('');
  late TabController _tabController;
  var taskGroup = TaskGroup.undone;
  int taskCounter = 0;

  late AnimationController _animation1;

  @override
  void dispose() {
    _animation1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animation1 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    taskBloc.getTasks();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    _tabController.addListener(() {
      taskCounter = 0;
      var newValue =
          _tabController.index == 0 ? TaskGroup.undone : TaskGroup.done;
      if (taskGroup == newValue) return;
      taskGroup = newValue;
      taskBloc.refresh();
    });
  }

  animateGo() {
    _animation1.forward(from: 0);
  }

  Animation<Offset> animate1() {
    return TweenSequence(<TweenSequenceItem<Offset>>[
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
              begin: const Offset(2, 1), end: const Offset(.2, 0)),
          weight: 50),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
              begin: const Offset(.2, 0), end: const Offset(0, 0)),
          weight: 50)
    ]).animate(_animation1);
  }

  @override
  Widget build(BuildContext context) {
    animateGo();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          taskBloc.selectedTask = Task();
          Navigator.of(context)
              .push(Routes().animatedRoute(const TaskDetailsScreen()));
          // Navigator.pushNamed(context, 'task_details');
        },
        label: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text('New'),
          ],
        ),
      ),
      body: StreamBuilder<DataState>(
          stream: taskBloc.tasks$,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return SizedBox(
                child: Text('${snapshot.data}'),
              );
            }
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 150.0,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 10, bottom: 10),
                    title: Row(
                      children: [
                        SlideTransition(
                          position: animate1(),
                          child: const Text(
                            'My tasks',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                    floating: false,
                    pinned: true,
                    delegate: MySliverPersistentHeaderDelegate(_tabController)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (snapshot.data == DataState.loading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (taskBloc.tasks.isEmpty ||
                          taskBloc.isTaskGroupEmpty(taskGroup)) {
                        return centerWidget(
                          Column(
                            children: [
                              SvgPicture.asset('${libSvgDir}empty_data.svg',
                                  height: 120),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('No Data'),
                            ],
                          ),
                        );
                      }

                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Text(
                            taskGroup == TaskGroup.undone
                                ? 'To do'
                                : 'Completed',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      final task = taskBloc.tasks[index - 1];

                      // if (snapshot.data == DataState.empty) {
                      //   return const Center(child: Text('No data'));
                      // }

                      if (task.status! !=
                          (taskGroup == TaskGroup.done ? true : false)) {
                        return const SizedBox();
                      }
                      taskCounter += 1;
                      return GestureDetector(
                        onTap: () {
                          taskBloc.selectedTask = task;

                          Navigator.pushNamed(context, 'task_details');
                        },
                        child: Dismissible(
                          background: Container(
                            color: Colors.red.shade700,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            taskBloc.removeTask(task);
                          },
                          key: Key(task.taskID ?? ''),
                          child: ListTile(
                            leading: StreamBuilder<String>(
                                stream: taskStatus$,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return const SizedBox();
                                  }
                                  return Checkbox.adaptive(
                                    value: task.status,
                                    onChanged: (val) {
                                      if (val == null) {
                                        return;
                                      }

                                      taskBloc.updateTaskStatus(
                                          task.copyWith(status: val));
                                      taskStatus$.add(task.taskID!);
                                    },
                                  );
                                }),
                            title: Text(task.title ?? ''),
                            subtitle: Text(task.description ?? ''),
                          ),
                        ),
                      );
                    },
                    childCount: taskBloc.isTaskGroupEmpty(taskGroup)
                        ? 1
                        : taskBloc.tasks.length +
                            (taskBloc.tasks.isEmpty ? 1 : 1),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final _tabController;

  MySliverPersistentHeaderDelegate(this._tabController);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.grey,
      child: TabBar(
        indicatorWeight: 4,
        tabs: const [
          Tab(
            icon: Icon(
              Icons.pending_actions_sharp,
            ),
          ),
          Tab(
              icon: Icon(
            Icons.done_rounded,
          ))
        ],
        controller: _tabController,
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
