import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:queries/collections.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClusteredMemeService {
  final String baseUrl = "https://9bf181cd.ngrok.io/api/memes/clustered";

  Future<IEnumerable<MemeCluster>> byDateRangeAsync(
      DateTime start, DateTime end) async {
    final response =
        await _getResponse('$baseUrl/${start.toString()}/${end.toString()}');

    if (response.statusCode != 200)
      throw Exception('Failed to clusters for dates between $start and $end');

    List clusters = json.decode(response.body) as List;
    var results = clusters.map((value) => MemeCluster.fromJson(value));
    
    return Collection(results.toList());
  }

  Future<MemeCluster> byIdAsync(String clusterId) async {
    final response = await _getResponse('$baseUrl/$clusterId');

    if (response.statusCode != 200)
      throw Exception('Failed to load meme cluster $clusterId');

    return MemeCluster.fromJson(json.decode(response.body));
  }

  Future<IEnumerable<MemeCluster>> byNewestAsync() async {
    var start = DateTime.now().toString();
    var end = DateTime.now().toString();
    final response = await _getResponse('$baseUrl/$start/$end');

    if (response.statusCode != 200)
      throw Exception('Failed to load newest clusters');

    List clusters = json.decode(response.body) as List;
    var results = clusters.map((value) => MemeCluster.fromJson(value));
    
    return Collection(results.toList());
  }

  Future<http.Response> _getResponse(String url) async =>
      await http.get(url).timeout(Duration(minutes: 10));
}
