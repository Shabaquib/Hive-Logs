import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import '../data_models/global_data.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../data_models/note_model.dart';
import '../widgets/newnote.dart';
import '../widgets/notetile.dart';

ValueNotifier<bool> isNewNoteCreated = ValueNotifier(false);

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    print("NoteList Future: checkpoint");
    return SafeArea(
        child: FutureBuilder(
            future: Hive.openBox('Notes'),
            builder: (BuildContext ctx, AsyncSnapshot<Box<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const NotesListWidget();
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

class NotesListWidget extends StatefulWidget {
  const NotesListWidget({super.key});

  @override
  State<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    print("Notes List: ValueListenable");
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: Hive.box('Notes').listenable(),
        builder: (a, b, c) {
          print("Inside Note Listener: checkpoint");
          if (b.isEmpty) {
            b.add(Note(
                noteTopic: "Welcome to Hive Logs",
                noteContent:
                    "Welcome to Hive Logs, here you can add edit and save your logs for later use. \nHappy logging!",
                lastSaved: DateFormat.MMMEd('en-US').format(DateTime.now()),
                isInTrash: false,
                colorMap: globalColorMap[math.Random().nextInt(12)]));
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Hive keys: ${b.keys}"),
                ValueListenableBuilder<bool>(
                    valueListenable: isNewNoteCreated,
                    builder: (aa, bb, cc) {
                      return Visibility(
                        visible: bb,
                        child: AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.decelerate,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            width: screenWidth - 30,
                            child: NewNote(
                                colorValue:
                                    globalColorMap[math.Random().nextInt(12)])),
                      );
                    }),
                ListView.builder(
                    itemCount: b.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (BuildContext ctx, int index) {
                      print("ListView Note builder: checkpoint");
                      var noteBox = b.getAt(index) as Note;
                      if (noteBox.isInTrash) {
                        return const SizedBox(
                          height: 1.0,
                        );
                      } else {
                        return NoteTile(
                          boxNoteInstance: noteBox,
                          noteIndex: index,
                          boxInstance: b,
                        );
                      }
                    }),
              ],
            ),
          );
        });
  }
}
