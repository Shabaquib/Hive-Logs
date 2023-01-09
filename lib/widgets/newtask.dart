import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data_models/task_model.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../data_models/global_data.dart';
import '../pages/tasks.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController contentController = TextEditingController();
  List<int> taskColor = [];

  pushTask(List<int> colorArg) {
    print("getting taskColor: $colorArg");
    print(contentController.text);

    if (contentController.text.isNotEmpty) {
      Hive.box('Tasks').add(Task(
          taskContent: contentController.text,
          lastSaveTime: DateFormat.MMMEd('en-US').format(DateTime.now()),
          isChecked: false,
          colorMap: colorArg));
    }
  }

  @override
  void initState() {
    taskColor = globalColorMap[math.Random().nextInt(12)];
    print("intial state tasColor: $taskColor");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth - 40,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(taskColor[0], taskColor[1], taskColor[2], 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: contentController,
            maxLines: null,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Enter text here",
              hintStyle: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: Container(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  pushTask(taskColor);
                  isNewTaskCreated.value = false;
                },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.save_rounded,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
