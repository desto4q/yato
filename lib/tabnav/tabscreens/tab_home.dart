import 'package:flutter/material.dart';
import 'package:yato/api/api.dart';
import 'package:yato/components/carousel.dart';
import 'package:yato/components/home_section.dart';
import 'package:yato/stackscreens/settings_screen.dart';

class TabHome extends StatelessWidget {
  const TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yato"),
        actions: [
          InkWell(
            onTap: (){
              final _settings_page = MaterialPageRoute(builder: (context) => SettingsScreen());
              Navigator.of(context).push(_settings_page);

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const Carousel(),
          const SizedBox(
            height: 18,
          ),
          HomeSection(
            title: "Top Airing",
            call: ZoroAnime().getTop,
          ),
          const SizedBox(
            height: 18,
          ),
          HomeSection(
            title: "Popular",
            call: ZoroAnime().getPopular,
          ),
          const SizedBox(
            height: 18,
          ),
          HomeSection(
            title: "Recent",
            call: ZoroAnime().getRecent,
          ),
        ],
      ),
    );
  }
}
