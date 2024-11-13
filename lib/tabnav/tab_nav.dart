import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'package:yato/tabnav/tabscreens/tab_dummy.dart';
import 'package:yato/tabnav/tabscreens/tab_home.dart';
import 'package:yato/tabnav/tabscreens/tab_search.dart';

class TabNav extends StatefulWidget {
  const TabNav({super.key});

  @override
  State<TabNav> createState() => _TabNavState();
}

List<Map> items = [
  {"name": "Home", "icon": Icons.home},
  {"name": "Search", "icon": Icons.search},
  {"name": "Dummy", "icon": Icons.feed}
];
List<Widget> tabItems = [
  const TabHome(),
  const TabSearch(),
  const TabDummy(),
];

class _TabNavState extends State<TabNav> {
  int _selected_index = 0;
  final Color _active_color = ThemeData.dark().focusColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FadeIndexedStack(
        index: _selected_index,
        children: tabItems,
      ),
      bottomNavigationBar: FlashyTabBar(
        showElevation: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: items.map((ele) {
          return FlashyTabBarItem(
              // activeColor: const Color(0xff9496c1),
              inactiveColor: Theme.of(context).dividerColor,
              activeColor:Theme.of(context).textTheme.bodyLarge!.color?? Colors.red,
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
