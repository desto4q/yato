import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:yato/api/api.dart';
import 'package:yato/components/loader.dart';
import 'package:yato/components/search_card.dart';

class TabSearch extends StatefulWidget {
  const TabSearch({super.key});

  @override
  State<TabSearch> createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  String searchTerm = "";
  String cacheKey = "search";
  late SearchController _controller = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    _controller = SearchController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: SearchBar(
                    controller: _controller,
                    hintText: "Naruto...",
                    hintStyle: WidgetStatePropertyAll<TextStyle>(
                      TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                    onSubmitted: (e) {
                      setState(() {
                        searchTerm = e;
                        queryCache.invalidateQueries(cacheKey);
                      });
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    final val = _controller.value.text;
                    setState(() {
                      searchTerm = val;
                      queryCache.invalidateQueries(cacheKey);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Center(
                        child: Icon(
                      Icons.search,
                      size: 32,
                    )),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Query(cacheKey,
                  builder: (BuildContext context, resp) {
                    if (searchTerm == "") {
                      return const Center(
                        child: Text("search something..."),
                      );
                    }
                    if (resp.loading) {
                      return const Loader();
                    }
                    if (resp.error != null) {
                      return const Text("error occured");
                    }

                    final Map<String, dynamic> data = resp.data ?? {};
                    final List results = data["results"];
                    // return Text(searchTerm);
                    // return Text(results.toString());
                    final bool hasNextPage = data["hasNextPage"];
                    final int? currentPage = data["currentPage"];
                    if (data == null) {
                            return Loader();
                    }
                    return Stack(
                      children: [
                        GridView.builder(
                            itemCount: results.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 6 / 10),
                            itemBuilder: (BuildContext context, int index) {
                              return SearchCard(mediaObject: results[index]);
                            }),
                        Positioned(
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: currentPage != null
                                        ? currentPage >= 1
                                            ? () {}
                                            : null
                                        : null,
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(currentPage != null
                                      ? currentPage.toString()
                                      : "1"),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ElevatedButton(
                                    onPressed: hasNextPage ? () {} : null,
                                    child: const Icon(Icons.arrow_forward),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  future: () async => await ZoroAnime().getQuery(searchTerm)),
            )
          ],
        ),
      ),
    );
  }
}
