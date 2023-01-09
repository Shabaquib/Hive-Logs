import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../data_models/global_data.dart';
import '../data_models/task_model.dart';

class TaskTile extends StatefulWidget {
  TaskTile(
      {super.key,
      required this.taskNoteInstance,
      required this.taskIndex,
      required this.boxInstance});
  Task taskNoteInstance;
  int taskIndex;
  Box boxInstance;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isInEditMode = false;

  ValueNotifier<bool> isChecked = ValueNotifier(false);

  TextEditingController contentController = TextEditingController();

  // updateTask(int index) {
  // widget.boxInstance.putAt(
  //     index,
  //     Task(
  //         taskContent: contentController.text,
  //         lastSaveTime: DateFormat.MMMEd('en-US').format(DateTime.now()),
  //         isChecked: false,
  //         colorMap: globalColorMap[5]));
  // }

  updateTask(int index) {
    Future.delayed(Duration(milliseconds: 800), () {
      widget.boxInstance.putAt(
          index,
          Task(
              taskContent: contentController.text,
              lastSaveTime: DateFormat.MMMEd('en-US').format(DateTime.now()),
              isChecked: false,
              colorMap: globalColorMap[5]));
    });
  }

  deleteTask(int index, List<int> colorMap) {
    Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
      widget.boxInstance.putAt(
          index,
          Task(
              taskContent: widget.taskNoteInstance.taskContent,
              lastSaveTime: widget.taskNoteInstance.lastSaveTime,
              isChecked: true,
              colorMap: colorMap));
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return (isInEditMode)
        ? Container(
            width: screenWidth - 40,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(
                  widget.taskNoteInstance.colorMap[0],
                  widget.taskNoteInstance.colorMap[1],
                  widget.taskNoteInstance.colorMap[2],
                  1.0),
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
                        updateTask(widget.taskIndex);
                        isInEditMode = false;
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
          )
        : Container(
            width: screenWidth - 40,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
            padding: const EdgeInsets.fromLTRB(5.0, 15.0, 15.0, 15.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(
                  widget.taskNoteInstance.colorMap[0],
                  widget.taskNoteInstance.colorMap[1],
                  widget.taskNoteInstance.colorMap[2],
                  1.0),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 2,
                    child: IconButton(
                        onPressed: () {
                          isChecked.value = true;
                          deleteTask(widget.taskIndex,
                              widget.taskNoteInstance.colorMap);
                        },
                        icon: ValueListenableBuilder<bool>(
                            valueListenable: isChecked,
                            builder: (a, b, c) {
                              return (b)
                                  ? const Icon(Icons.check_box_rounded)
                                  : const Icon(
                                      Icons.check_box_outline_blank_rounded);
                            }))),
                Flexible(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        contentController.text =
                            widget.taskNoteInstance.taskContent;
                        isInEditMode = true;
                      });
                    },
                    child: ValueListenableBuilder(
                        valueListenable: isChecked,
                        builder: (a, b, c) {
                          return Text(
                            widget.taskNoteInstance.taskContent,
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: (b)
                                ? const TextStyle(
                                    fontSize: 16.0,
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : const TextStyle(
                                    fontSize: 16.0,
                                  ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
  }
}
