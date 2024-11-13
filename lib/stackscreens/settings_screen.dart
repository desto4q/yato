import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var box = Hive.box("settings");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          HiveListener(
              box: box,
              builder: (_) {
                return SwitchListTile.adaptive(
                    title: Text("Dark Theme"),
                    value: box.get("dark_theme", defaultValue: false),
                    onChanged: (_) {
                      var theme = box.get("dark_theme", defaultValue: false);

                      box.put("dark_theme", !theme);
                    });
              }),
          HiveListener(
              box: box,
              builder: (builder) {

                final val = box.get("info_page_index", defaultValue: 0);
                return ListTile(
                  title: Text("Info Page Screen"),
                  trailing: DropdownButton(
                      hint: Text(
                         val  == 0
                              ? "Details"
                              : "Episodes"),
                      items: [
                        DropdownMenuItem(
                          child: Text("Episode"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Details"),
                          value: 0,
                        )
                      ],
                      onChanged: (_) {
                        box.put("info_page_index", _);
                      }),
                  subtitle: Text(
                    val == 0
                          ? "Details"
                          : "Episodes"),
                );
              })
        ],
      ),
    );
  }
}
