import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data.dart';
import 'package:todolist/edit_text_screen.dart';

const taskNameBox = 'task';
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: onSecendary,
    ),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());

  await Hive.openBox<Task>(taskNameBox);
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const Color secendaryTextColor = Color(0xffAFBED0);
const Color onSecendary = Color(0xffAFBED0);
const Color primaryTextColor = Color(0xff1D2830);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          surface: Color(0xffF3F5F8),
          onSurface: Colors.black,
          secondary: primaryColor,
          onSecondary: secendaryTextColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

final ThemeData themeDataC = ThemeData();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textThemeC = Theme.of(context).textTheme;

    final box = Hive.box<Task>(taskNameBox);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) {
                  return EditTextScreen(
                    tastDataEdit: Task(),
                  );
                },
              ),
            );
          },
          label: const Text('Add New Text'),
        ),
        body: Column(
          children: [
            Container(
              height: 120,
              color: primaryVariantColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'to do list',
                          style: textThemeC.headlineMedium,
                        ),
                        const Icon(
                          CupertinoIcons.share,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themeDataC.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  if (box.isNotEmpty) {
                    return ListView.builder(
                      itemCount: box.values.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'today',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color: themeDataC.colorScheme.onSurface,
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: themeDataC.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  color: const Color(0xffEAEFF5),
                                  onPressed: () {
                                    box.clear();
                                  },
                                  child: Text(
                                    'Delete All',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeDataC.colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          final Task taskData = box.values.toList()[index - 1];
                          return TastData(taskData: taskData);
                        }
                      },
                    );
                  } else {
                    return EmptyState();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TastData extends StatefulWidget {
  const TastData({
    super.key,
    required this.taskData,
  });

  final Task taskData;

  @override
  State<TastData> createState() => _TastDataState();
}

class _TastDataState extends State<TastData> {
  @override
  Widget build(BuildContext context) {
    final Color colorCP;

    switch (widget.taskData.priority) {
      case Priority.low:
        colorCP = Colors.green;
        break;

      case Priority.normal:
        colorCP = Colors.blueAccent;
        break;
      case Priority.high:
        colorCP = Colors.orange;
        break;
    }

    return InkWell(
      onLongPress: () {
        widget.taskData.delete();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                EditTextScreen(tastDataEdit: widget.taskData)));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          height: 75,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CheckBox(
                value: widget.taskData.isCompleted,
                onTap: () {
                  setState(() {
                    widget.taskData.isCompleted = !widget.taskData.isCompleted;
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.taskData.name,
                  style: widget.taskData.isCompleted
                      ? const TextStyle(
                          fontSize: 24,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w700,
                        )
                      : const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
              Container(
                height: 75,
                width: 6,
                decoration: BoxDecoration(
                  color: colorCP,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/empty_state.svg',
          height: 100,
        ),
        SizedBox(
          height: 20,
        ),
        Text('Your task list is empty'),
      ],
    );
  }
}

class CheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const CheckBox({
    super.key,
    required this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: value ? themeDataC.colorScheme.primary : null,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: value
              ? const Icon(
                  CupertinoIcons.check_mark,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
