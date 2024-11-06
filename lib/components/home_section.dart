import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:yato/components/loader.dart';
import 'package:yato/components/section_card.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.title, required this.call});
  final String title;
  final Function call;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 2 / 8 + 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Query([title],
                    builder: (builder, snapshot) {
                      if (snapshot.loading) {
                        return const Loader();
                      }
                      if (snapshot.error != null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(snapshot.error.toString()),
                            InkWell(
                              onTap: () {
                                queryCache.invalidateQueries(title);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("reload"),
                              ),
                            )
                          ],
                        );
                      }
                      final data = snapshot.data;
                      final List results = data["results"] ?? [];
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            return SectionCard(
                              mediaObject: results[index],
                            );
                          });
                    },
                    future: () async => await call()))
          ],
        ),
      ),
    );
  }
}
