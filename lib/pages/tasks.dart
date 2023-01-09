import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/tasktile.dart';
import 'package:intl/intl.dart';

import '../data_models/global_data.dart';
import '../data_models/task_model.dart';
import '../widgets/newtask.dart';

//TODO: create another spinkit

ValueNotifier<bool> isNewTaskCreated = ValueNotifier(false);

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    print("TasksList FutureBuilder: checkpoint");
    return SafeArea(
        child: FutureBuilder(
            future: Hive.openBox('Tasks'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TasksListWidget(tasksBox: snapshot.data!);
              } else {
                return const Center(
                  child: SpinKitRotatingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                );
              }
            }));
  }
}

class TasksListWidget extends StatefulWidget {
  TasksListWidget({super.key, required this.tasksBox});
  Box tasksBox;

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  @override
  Widget build(BuildContext context) {
    print("TaskList ValueListenableBuilder: checkpoint");
    return ValueListenableBuilder(
        valueListenable: Hive.box('Tasks').listenable(),
        builder: (a, b, c) {
          if (b.isEmpty) {
            b.add(Task(
                taskContent:
                    "Welcome to tasks, here you can add, edit or delete your tasks logs.\nHappy Logging!",
                lastSaveTime: DateFormat.MMMEd('en-US').format(DateTime.now()),
                isChecked: false,
                colorMap: globalColorMap[0]));
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: isNewTaskCreated,
                    builder: (aa, bb, cc) {
                      return Visibility(visible: bb, child: const NewTask());
                    }),
                ListView.builder(
                    itemCount: b.length,
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      var taskBox = b.getAt(index) as Task;
                      if (taskBox.isChecked) {
                        return const SizedBox(
                          height: 1.0,
                        );
                      } else {
                        return TaskTile(
                            taskNoteInstance: taskBox,
                            taskIndex: index,
                            boxInstance: b);
                      }
                    }),
              ],
            ),
          );
        });
  }
}
