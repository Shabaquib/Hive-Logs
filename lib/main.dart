import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './data_models/note_model.dart';
import './data_models/task_model.dart';
import './pages/notes.dart';
import './pages/tasks.dart';

//TODO: Add visual cue of tasks and notes
//TODO: Add a suitable light and dark theme

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "RedHat",
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> pageValue = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    print("Home page: checkpoint");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text("Hive Logs"),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [],
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF751717),
            )),
        title: ValueListenableBuilder<int>(
            valueListenable: pageValue,
            builder: (a, b, c) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (b == 0)
                      ? const Icon(
                          Icons.check_box,
                          size: 35.0,
                          color: Color(0xFF751717),
                        )
                      : const Icon(
                          Icons.check_box_outlined,
                          size: 27.0,
                          color: Color(0xFF751717),
                        ),
                  const SizedBox(
                    width: 70.0,
                  ),
                  (b == 1)
                      ? const Icon(
                          Icons.sticky_note_2,
                          size: 35.0,
                          color: Color(0xFF751717),
                        )
                      : const Icon(
                          Icons.sticky_note_2_outlined,
                          size: 27.0,
                          color: Color(0xFF751717),
                        ),
                ],
              );
            }),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_rounded,
                color: Color(0x00751717),
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFECFFEB),
      body: SafeArea(
        child: PageView(
          children: const [
            NoteList(),
            TasksList(),
          ],
          onPageChanged: (value) {
            pageValue.value = value;
          },
        ),
      ),
      bottomNavigationBar: const SizedBox(
        height: 10.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pageValue.value == 0) {
            isNewNoteCreated.value = true;
          } else {
            isNewTaskCreated.value = true;
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF344E41),
        elevation: 5.0,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
