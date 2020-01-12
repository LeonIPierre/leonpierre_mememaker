import 'dart:io';

import 'package:leonpierre_mememaker/models/memeclustermodel.dart';
import 'package:queries/collections.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClusteredMemeService {
  final String baseUrl = "https://09e842b8.ngrok.io/api/memes/clustered";

  Future<IEnumerable<MemeCluster>> byDateRange(
      DateTime start, DateTime end) async {
    final response = await http
        .get('$baseUrl/${start.toString()}/${end.toString()}')
        .timeout(Duration(minutes: 10));

    if (response.statusCode == 200) {
      List clusters = json.decode(response.body) as List;
      var results = clusters.map((value) => MemeCluster.fromJson(value));
      // If server returns an OK response, parse the JSON.
      return Collection(results.toList());
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load meme cluster');
    }
  }

  Future<MemeCluster> byId(String clusterId) async {
    final response =
        await http.get('$baseUrl/$clusterId').timeout(Duration(minutes: 10));

    if (response.statusCode == 200) {
      return MemeCluster.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load meme cluster');
    }
  }
}
