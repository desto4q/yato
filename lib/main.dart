import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:yato/tabnav/tab_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settings");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  var box = Hive.box("settings");

  
  @override
  Widget build(BuildContext context) {
    return HiveListener(
        box: box,
        builder: (builder) {
          return MaterialApp(
            title: 'Flutter Demo',
             theme: box.get('dark_theme', defaultValue: false) ? ThemeData.dark() : ThemeData.light(),
            home: const TabNav(),
          );
        });
  }
}
