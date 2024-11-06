import 'package:dio/dio.dart';

class ZoroAnime {
  // Method to fetch the data
  Future getSpot() async {
    try {
      final response = await Dio()
          .get("https://dezz-consument.vercel.app/anime/zoro/spotlight");

      // If the response is successful and status code is 200
      if (response.statusCode == 200) {
        // Parse and return the data as ZoroAnimeResponse
        return response.data;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print('Error fetching data: $err');
      return null;
    }
  }

  Future getTop() async {
    try {
      final response = await Dio()
          .get("https://dezz-consument.vercel.app/anime/zoro/top-airing");

      // If the response is successful and status code is 200
      if (response.statusCode == 200) {
        // Parse and return the data as ZoroAnimeResponse
        return response.data;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print('Error fetching data: $err');
      return null;
    }
  }
  Future getPopular() async {
    try {
      final response = await Dio()
          .get("https://dezz-consument.vercel.app/anime/zoro/most-popular");

      // If the response is successful and status code is 200
      if (response.statusCode == 200) {
        // Parse and return the data as ZoroAnimeResponse
        return response.data;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print('Error fetching data: $err');
      return null;
    }
  }
  Future getRecent() async {
    try {
      final response = await Dio()
          .get("https://dezz-consument.vercel.app/anime/zoro/recent-added");

      // If the response is successful and status code is 200
      if (response.statusCode == 200) {
        // Parse and return the data as ZoroAnimeResponse
        return response.data;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print('Error fetching data: $err');
      return null;
    }
  }
}
