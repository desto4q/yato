import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:yato/api/api.dart';
import 'package:yato/components/loader.dart';

class WatchPage extends StatefulWidget {
  WatchPage(
      {super.key,
      required this.info,
      required this.episodes,
      required this.index});
  final info;
  final List episodes;
  final int index;
  late BetterPlayerController _betterPlayerController;
  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late BetterPlayerController _betterPlayerController;
  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cacheKey = "watch-${widget.episodes[widget.index]["id"]}";
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Query(
              cacheKey,
              builder: (context, resp) {
                if (resp.loading) {
                  return const Loader();
                }
                if (resp.data == null) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          queryCache.invalidateQueries(cacheKey);
                        },
                        child: Container(
                          color: Colors.grey.shade400,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("error occured"),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final data = resp.data;
                final List source = data["sources"];
                final List subs = data['subtitles'];
                final firstUrl = source.first;
                final String url = firstUrl["url"];
                final dataSource = BetterPlayerDataSource(
                    BetterPlayerDataSourceType.network, url,
                    placeholder:
                        CachedNetworkImage(imageUrl: widget.info["image"]),
                    subtitles: subs.map((ele) {
                      return BetterPlayerSubtitlesSource(
                          type: BetterPlayerSubtitlesSourceType.network,
                          urls: [ele["url"]],
                          name: ele["lang"]);
                    }).toList());
                // _betterPlayerController

                _betterPlayerController = BetterPlayerController(
                    const BetterPlayerConfiguration(),
                    betterPlayerDataSource: dataSource);

                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(controller: _betterPlayerController),
                );
              },
              future: () async {
                final resp = await ZoroAnime()
                    .getStream(widget.episodes[widget.index]["id"]);

                return resp;
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.info["title"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Episode ${widget.episodes[widget.index]["number"]}",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700
                  // fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Episodes",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: GridView.builder(
                itemCount: widget.episodes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (context, index) {
                  return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        final page = MaterialPageRoute(
                            builder: (context) => WatchPage(
                                  episodes: widget.episodes,
                                  index: index,
                                  info: widget.info,
                                ));

                        Navigator.pushReplacement(context, page);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            color: Colors.blueGrey.shade800,
                            child: Center(child: Text(index.toString()))),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
