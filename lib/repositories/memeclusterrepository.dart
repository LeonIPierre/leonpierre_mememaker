import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/services/memeclustersservice.dart';
import 'package:queries/collections.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemeClusterRepository extends MemeClustersService {
  final String _baseUrl;

  MemeClusterRepository(this._baseUrl);
  
  Future<IEnumerable<MemeClusterEntity>> byDateRangeAsync(
      DateTime start, DateTime end) async =>
      await _getResponse('$_baseUrl/memes/clustered/${start.toString()}/${end.toString()}').then((response) {
          if (response.statusCode != 200)
            throw Exception('Failed to clusters for dates between $start and $end');

          List clusters = json.decode(response.body) as List;
          var results = clusters.map((value) => MemeClusterEntity.fromJson(value));
          return Collection(results.toList());
        });
        
  Future<MemeClusterEntity> byIdAsync(String clusterId) async { 
    final response = await _getResponse('$_baseUrl/memes/clustered/$clusterId');

    if (response.statusCode != 200)
      throw Exception('Failed to load meme cluster $clusterId');

    return MemeClusterEntity.fromJson(json.decode(response.body));
  }

  Future<IEnumerable<MemeClusterEntity>> byNewestAsync({int days = 730}) async {
    var start = DateTime.now().subtract(Duration(days: days)).toString();
    var end = DateTime.now().toString();
    final response = await _getResponse('$_baseUrl/memes/clustered/$start/$end');

    if (response.statusCode != 200)
      throw Exception('Failed to load newest clusters from $start to $end');

    List clusters = json.decode(response.body) as List;
    var results = clusters.map((value) => MemeClusterEntity.fromJson(value));
    
    return Collection(results.toList());
  }

  Future<http.Response> _getResponse(String url) async =>
      await http.get(url).timeout(Duration(seconds: 30));
}