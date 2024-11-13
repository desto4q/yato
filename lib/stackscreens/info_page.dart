import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:yato/api/api.dart';
import 'package:yato/components/loader.dart';
import 'package:yato/components/section_card.dart';
import 'package:yato/stackscreens/watch_page.dart';

final items = [
  {"name": "Details", "icon": Icons.info},
  {"name": "Episodes", "icon": Icons.list},
];

class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.mediaObject});
  final mediaObject;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _selected_index = 0;
  final ScrollController _scrollController = ScrollController();
  final Color _active_color = ThemeData.dark().focusColor;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cacheKey = ["info ${widget.mediaObject["id"]}"];
    void call() {
      queryCache.invalidateQueries(cacheKey);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(items[_selected_index]["name"] as String),
      ),
      body: Query(cacheKey,
          builder: (builder, resp) {
            if (resp.loading) {
              return const Loader();
            }

            final data = resp.data;

            if (data == null) {
              return ErrorWidget(call: call);
            }
            final String description = data["description"];
            final List episodes = data["episodes"];
            final List recommendations = data["recommendations"];
            return Column(
              children: [
                Expanded(
                  child: FadeIndexedStack(
                    index: _selected_index,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: 220, minWidth: 7 / 10 * 220),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.mediaObject["image"] ??
                                          data["image"],
                                      height: 220,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          widget.mediaObject["title"],
                                        ),
                                        Text(
                                          "Duration: ${widget.mediaObject["duration"]}",
                                        ),
                                        Text(
                                          "Episodes: ${widget.mediaObject["sub"]}",
                                        ),
                                        Text(
                                          "Nsfw: ${widget.mediaObject["nsfw"].toString()}",
                                        ),
                                        Text(
                                          "Type: ${widget.mediaObject["type"]}",
                                        ),
                                        Text(
                                          "Sub: ${widget.mediaObject["sub"]}",
                                        ),
                                        Text(
                                          "Dub: ${widget.mediaObject["dub"]}",
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ExpandableText(
                              description,
                              expandText: 'show more',
                              collapseText: 'show less',
                              maxLines: 8,
                              linkColor: Colors.blue,
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            const Text(
                              "Recommendations",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 240,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return SectionCard(
                                      mediaObject: recommendations[index]);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      VsScrollbar(
                        // style: VsScrollbarStyle(),
                        controller: _scrollController,
                        child: GridView.builder(
                            controller: _scrollController,
                            itemCount: episodes.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    final page = MaterialPageRoute(
                                        builder: (context) => WatchPage(
                                              episodes: episodes,
                                              index: index,
                                              info: data,
                                            ));

                                    Navigator.push(context, page);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                        color: Colors.blueGrey.shade800,
                                        child: Center(
                                            child: Text(episodes[index]["number"].toString())),
                                  )));
                            }),
                      )
                    ],
                  ),
                ),
                FlashyTabBar(
                    backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
                    selectedIndex: _selected_index,
                    items: items.map((ele) {
                      return FlashyTabBarItem(
                          activeColor: const Color(0xff9496c1),
                          inactiveColor: _active_color,
                          icon: Icon(ele["icon"] as IconData?),
                          title: Text(ele["name"] as String));
                    }).toList(),
                    onItemSelected: (page) {
                      setState(() {
                        _selected_index = page;
                      });
                    })
              ],
            );
          },
          future: () async =>
              await ZoroAnime().getInfo(widget.mediaObject["id"])),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.call});
  final Function call;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("error occured"),
          ElevatedButton(
              onPressed: () {
                call();
              },
              child: const Text("reload"))
        ],
      ),
    );
  }
}
