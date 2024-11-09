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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.info["title"],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "Episode ${widget.episodes[widget.index]["number"]}",
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Flexible(
            child: Query(
              ["watch-${widget.episodes[widget.index]["id"]}"],
              builder: (context, resp) {
                if (resp.loading) {
                  return const Loader();
                }
                if (resp.data == null) {
                  return const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                      child: const Text("error occured"),
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
        ],
      ),
    );
  }
}
