import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data_models/global_data.dart';
import 'package:intl/intl.dart';

import '../data_models/note_model.dart';

class NoteTile extends StatefulWidget {
  NoteTile(
      {super.key,
      required this.boxNoteInstance,
      required this.noteIndex,
      required this.boxInstance});
  Note boxNoteInstance;
  int noteIndex;
  Box boxInstance;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  bool isInEditMode = false;

  TextEditingController topicController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  int groupValue = 0;

  updateNote(int index, List<int> colorMap) {
    print(topicController.text);
    print(contentController.text);
    widget.boxInstance.putAt(
        index,
        Note(
            noteTopic: topicController.text,
            noteContent: contentController.text,
            lastSaved: DateFormat.MMMEd('en-US').format(DateTime.now()),
            isInTrash: false,
            colorMap: colorMap));
  }

  deleteNote(String topic, String content, String lastSaved, List<int> colorMap,
      int index) {
    widget.boxInstance.putAt(
        index,
        Note(
            noteTopic: topic,
            noteContent: content,
            lastSaved: lastSaved,
            isInTrash: true,
            colorMap: colorMap));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        width: screenWidth - 30,
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              widget.boxNoteInstance.colorMap[0],
              widget.boxNoteInstance.colorMap[1],
              widget.boxNoteInstance.colorMap[2],
              1.0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Container(
              padding: (isInEditMode)
                  ? const EdgeInsets.all(5.0)
                  : const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (isInEditMode)
                      ? SizedBox(
                          height: 70.0,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return Radio(
                                    value: index,
                                    groupValue: groupValue,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => Color.fromRGBO(
                                            globalColorMap[index][0],
                                            globalColorMap[index][1],
                                            globalColorMap[index][2],
                                            1.0)),
                                    activeColor: MaterialStateColor.resolveWith(
                                        (states) => Color.fromRGBO(
                                            globalColorMap[index][0],
                                            globalColorMap[index][1],
                                            globalColorMap[index][2],
                                            1.0)),
                                    onChanged: (index) {
                                      setState(() {
                                        groupValue = index as int;
                                      });
                                    });
                              },
                              itemCount: globalColorMap.length),
                        )
                      : const SizedBox(
                          height: 2.0,
                        ),
                  (isInEditMode)
                      ? FractionallySizedBox(
                          widthFactor: 1.0,
                          alignment: Alignment.topLeft,
                          child: TextField(
                            controller: topicController,
                            minLines: 1,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: Colors.black87,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )
                      : FractionallySizedBox(
                          widthFactor: 0.7,
                          alignment: Alignment.topLeft,
                          child: Text(
                            (widget.boxNoteInstance).noteTopic,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                  (isInEditMode)
                      ? const SizedBox(
                          height: 1.0,
                        )
                      : const Divider(
                          endIndent: 10.0,
                          height: 10.0,
                          thickness: 2.0,
                        ),
                  (isInEditMode)
                      ? FractionallySizedBox(
                          widthFactor: 1.0,
                          alignment: Alignment.topLeft,
                          child: TextField(
                            controller: contentController,
                            minLines: 1,
                            maxLines: null,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            cursorColor: Colors.black87,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )
                      : FractionallySizedBox(
                          widthFactor: 1.0,
                          alignment: Alignment.topLeft,
                          child: Text(
                            (widget.boxNoteInstance).noteContent,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  (isInEditMode)
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Last Edited: "
                              "${(widget.boxNoteInstance).lastSaved}",
                              // "${DateFormat.MMMEd('en-US').format(DateTime.now())}",
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : FractionallySizedBox(
                          widthFactor: 1.0,
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Last Edited: "
                            "${(widget.boxNoteInstance).lastSaved}",
                            // "${DateFormat.MMMEd('en-US').format(DateTime.now())}",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                ],
              ),
            ),
            Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: Container(
                  // color: Colors.black26,
                  alignment: Alignment.bottomRight,
                  child: (isInEditMode)
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isInEditMode = false;
                              updateNote(widget.noteIndex,
                                  widget.boxNoteInstance.colorMap);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.fromLTRB(
                                5.0, 10.0, 10.0, 10.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(
                              Icons.save_rounded,
                              size: 20.0,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isInEditMode = true;
                                  topicController.text =
                                      widget.boxNoteInstance.noteTopic;
                                  contentController.text =
                                      widget.boxNoteInstance.noteContent;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.fromLTRB(
                                    5.0, 10.0, 10.0, 10.0),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteNote(
                                    widget.boxNoteInstance.noteTopic,
                                    widget.boxNoteInstance.noteContent,
                                    widget.boxNoteInstance.lastSaved,
                                    widget.boxNoteInstance.colorMap,
                                    widget.noteIndex);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.fromLTRB(
                                    5.0, 10.0, 10.0, 10.0),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
