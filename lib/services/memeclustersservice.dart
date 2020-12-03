import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:queries/collections.dart';

abstract class MemeClustersService {
  //Future<List<Meme>> getMemes({bool expression(Meme meme)});

  Future<IEnumerable<MemeClusterEntity>> byDateRangeAsync(DateTime start, DateTime end);

  Future<MemeClusterEntity> byIdAsync(String clusterId);

  Future<IEnumerable<MemeClusterEntity>> byNewestAsync();
}