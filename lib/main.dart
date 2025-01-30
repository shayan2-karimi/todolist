import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/constant.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/hive/hive_data_source.dart';
import 'package:todolist/data/repasitory/repasitory.dart';
import 'package:todolist/screen/home/bloc/task_list_bloc.dart';
import 'package:todolist/screen/home/home_screen.dart';

const taskNameBox = 'task';
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: MyColor.primaryVariantColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());

  await Hive.openBox<Task>(taskNameBox);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Repasitory(
            HiveDataSource(
              Hive.box(taskNameBox),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => TaskListBloc(context.read<Repasitory<Task>>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

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
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
          primary: MyColor.primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          secondary: MyColor.primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
