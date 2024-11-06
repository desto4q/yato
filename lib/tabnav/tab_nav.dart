import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'package:yato/tabnav/tabscreens/tab_dummy.dart';
import 'package:yato/tabnav/tabscreens/tab_home.dart';

class TabNav extends StatefulWidget {
  const TabNav({super.key});

  @override
  State<TabNav> createState() => _TabNavState();
}

List<Map> items = [
  {"name": "home", "icon": Icons.home},
  {"name": "dummy", "icon": Icons.feed},
];
List<Widget> tabItems = [TabHome(), TabDummy()];

class _TabNavState extends State<TabNav> {
  int _selected_index = 0;
  Color _active_color = ThemeData.dark().focusColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIndexedStack(
        
        index: _selected_index,
        children: tabItems,
      ),
      bottomNavigationBar: FlashyTabBar(
        showElevation: true,
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        items: items.map((ele) {
          return FlashyTabBarItem(
              activeColor: const Color(0xff9496c1),
              inactiveColor: _active_color,
              icon: Icon(ele["icon"]),
              title: Text(ele["name"]));
        }).toList(),
        onItemSelected: (e) {
          setState(() {
            _selected_index = e;
          });
        },
        selectedIndex: _selected_index,
      ),
    );
  }
}
