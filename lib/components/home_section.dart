import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.title, required this.call});
  final String title;
  final Function call;
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Container(
      height: _size.height * 2 / 8 + 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            SizedBox(
              height: 12,
            ),
            Expanded(
                child: Query([title],
                    builder: (builder, snapshot) {
                      if (snapshot.loading) {
                        return Loader();
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

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.mediaObject});
  final mediaObject;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7 / 10,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(imageUrl: mediaObject["image"],fit: BoxFit.cover,),
            ),
            Text(
              mediaObject["title"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
