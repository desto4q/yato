import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TabDummy extends StatefulWidget {
  const TabDummy({super.key});

  @override
  State<TabDummy> createState() => _TabDummyState();
}

class _TabDummyState extends State<TabDummy> {
  var box = Hive.box("settings");
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () {
        var theme = box.get("dark_theme",defaultValue: false);
        box.put("dark_theme", !theme);

      }, child: Text("dummy")),
    );
  }
}
