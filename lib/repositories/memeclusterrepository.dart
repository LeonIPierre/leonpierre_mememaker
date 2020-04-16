import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:queries/collections.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemeClusterRepository {
  //final String baseUrl = "https://leonipierre.ngrok.io/api/memes/clustered";
  final String baseUrl = "http://108.175.11.170/api/memes/clustered";
  
  Future<IEnumerable<MemeClusterEntity>> byDateRangeAsync(
      DateTime start, DateTime end) async =>
      await _getResponse('$baseUrl/${start.toString()}/${end.toString()}').then((response) {
          if (response.statusCode != 200)
            throw Exception('Failed to clusters for dates between $start and $end');

          List clusters = json.decode(response.body) as List;
          var results = clusters.map((value) => MemeClusterEntity.fromJson(value));
          return Collection(results.toList());
        });
        
  Future<MemeClusterEntity> byIdAsync(String clusterId) async { 
    final response = await _getResponse('$baseUrl/$clusterId');

    if (response.statusCode != 200)
      throw Exception('Failed to load meme cluster $clusterId');

    return MemeClusterEntity.fromJson(json.decode(response.body));
  }

  Future<IEnumerable<MemeClusterEntity>> byNewestAsync() async {
    var start = DateTime.now().subtract(Duration(days: 365)).toString();
    var end = DateTime.now().toString();
    final response = await _getResponse('$baseUrl/$start/$end');

    if (response.statusCode != 200)
      throw Exception('Failed to load newest clusters from $start to $end');

    List clusters = json.decode(response.body) as List;
    var results = clusters.map((value) => MemeClusterEntity.fromJson(value));
    
    return Collection(results.toList());
  }

  Future<http.Response> _getResponse(String url) async =>
      await http.get(url).timeout(Duration(minutes: 10));
}