import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:yato/api/api.dart';
import 'package:yato/stackscreens/info_page.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final _controller = FlutterCarouselController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 2 / 8 + 60,
      child: Query(
        const ["cacheKey"],
        builder: (context, snapshot) {
          if (snapshot.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            return const Center(
              child: Text("error"),
            );
          }
          if (snapshot.error != null) {
            return Center(
              child: InkWell(
                onTap: () {
                  queryCache.invalidateQueries("cacheKey");
                },
                child: const Text("refetch"),
              ),
            );
          }
          final data = snapshot.data;
          List results = data["results"] ?? [];

          // if (snapshot.data != null) {
          //   return Text(results.toString());
          // }
          return Stack(children: [
            FlutterCarousel.builder(
              itemCount: results.length,
              itemBuilder: (context, index, _) {
                return Card(
                  index: index,
                  mediaObject: results[index],
                );
              },
              options: FlutterCarouselOptions(
                  initialPage: _currentPage.value,
                  viewportFraction: 1,
                  showIndicator: false,
                  height: double.infinity,
                  // enableInfiniteScroll: true,
                  autoPlay: true,
                  pauseAutoPlayOnManualNavigate: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  autoPlayCurve: Curves.easeInOut,
                  controller: _controller,
                  onPageChanged: (page, _) {
                    _currentPage.value = page;
                  }),
            ),
          ]);
        },
        future: () async => await ZoroAnime().getSpot(),
      ),
    );
  }
}

class Card extends StatelessWidget {
  Card({super.key, this.index, required this.mediaObject});
  int? index;
  Map mediaObject;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) {
            return InfoPage(mediaObject: mediaObject);
          },
        );
        Navigator.push(context, route);
        
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: mediaObject["banner"],
                ),
              ),
            ),
            Text(
              mediaObject["title"],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("Episodes: ${mediaObject["sub"]}"),
                const SizedBox(
                  width: 8,
                ),
                Text("Release: ${mediaObject["releaseDate"]}")
              ],
            )
          ],
        ),
      ),
    );
  }
}
