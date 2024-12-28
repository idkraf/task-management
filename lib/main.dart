import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/theme_provider.dart';
import 'package:task_management/ui/login_page.dart';
import 'package:task_management/ui/main_page.dart';
import 'package:task_management/ui/splash_screen_page.dart';
import 'package:task_management/model/standard_list_model.dart';
import 'package:provider/provider.dart';
import 'package:task_management/ui/task_page.dart';

import 'model/task_model.dart'; // Add this import for ChangeNotifierProvider


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Open a box to store your tasks data
  Hive.registerAdapter(TaskModelAdapter()); // Register Task adapter
  Hive.registerAdapter(TaskStatusAdapter()); // Register TaskStatus adapter
  await Hive.openBox<TaskModel>('tasks');

  //example get data
  Hive.registerAdapter(StandardListModelsAdapter());
  await Hive.openBox<StandardListModels>('taskBox');

  // Run the app with ThemeProvider
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Management',
            theme: ThemeData.light(), // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Switch between themes
            home: Scaffold(
              backgroundColor: Colors.white,
              body: SplashScreenPage(),
            ),
            builder: (context, child) {
              return MediaQuery(
                child: child!,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            routes: <String, WidgetBuilder>{
              '/main_page': (BuildContext context) => MainPage(),
              '/task_page': (BuildContext context) => TaskPage(),
              '/login_page': (BuildContext context) => LoginPage(),
              '/splash_screen_page': (BuildContext context) => SplashScreenPage(),
            },
          );
        },
      ),
    );
  }
}
