import 'package:flutter/material.dart';
import 'package:yato/api/api.dart';
import 'package:yato/components/carousel.dart';
import 'package:yato/components/home_section.dart';

class TabHome extends StatelessWidget {
  const TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yato"),
      ),
      body: ListView(
        children: [
          Carousel(),
          SizedBox(
            height: 18,
          ),
          HomeSection(
            title: "Top Airing",
            call: ZoroAnime().getTop,
          ),
          SizedBox(
            height: 18,
          ),
          HomeSection(
            title: "Popular",
            call: ZoroAnime().getPopular,
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
