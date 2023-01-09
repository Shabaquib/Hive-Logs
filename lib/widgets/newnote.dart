import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../pages/notes.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../data_models/note_model.dart';

//TODO: Color randomness between creating and saving!

class NewNote extends StatefulWidget {
  const NewNote({super.key, required this.colorValue});
  final List<int> colorValue;

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  TextEditingController topicController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  pushNote(List<int> colorArg) {
    print(topicController.text);
    print(contentController.text);

    if (topicController.text.isNotEmpty && contentController.text.isNotEmpty) {
      Hive.box('Notes').add(Note(
          noteTopic: topicController.text,
          noteContent: contentController.text,
          lastSaved: DateFormat.MMMEd('en-US').format(DateTime.now()),
          isInTrash: false,
          colorMap: colorArg));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(widget.colorValue[0], widget.colorValue[1],
            widget.colorValue[2], 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
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
                      hintText: "Enter topic here",
                      hintStyle: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                ),
                FractionallySizedBox(
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
                      hintText: "Enter content here",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Last Edited: "
                      "${DateFormat.MMMEd('en-US').format(DateTime.now())}",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.0, fontWeight: FontWeight.w600),
                    ),
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
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    pushNote(widget.colorValue);
                    isNewNoteCreated.value = false;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.save_rounded,
                      size: 20.0,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
