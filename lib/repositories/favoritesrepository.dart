import 'dart:async';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:path/path.dart';
import 'package:queries/collections.dart';
import 'package:sqflite/sqflite.dart';

//https://snowplowanalytics.com/blog/2018/03/26/building-a-model-for-atomic-event-data-as-a-graph/#the-next-post-in-the-series
class FavoritesRepository {
  final String auditLikeAdded = "LIKE_ADDED";
  final String auditLikeRemoved = "LIKE_REMOVED";

  Future<Database> _database;

  void _sync() {
    //when a user goes to premium save
  }

  Future<IEnumerable<MemeEntity>> getMemeFavoritesByHistory(DateTime start, DateTime end) async {
    return await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        List parameters = [ start, end ];
        var favorites = await transaction.rawQuery(
                //TODO: query should be datetime(b.timestamp,'unixepoch') as dateCreated but its currently unsupported
                "SELECT memeId AS id, b.timestamp as dateCreated, memeType, path FROM meme_favorites WHERE timestamp BETWEEN ? AND ?", parameters);
        var results = favorites.map((result) {
          var clone = Map.of(result);
          
          //convert the int to datetime string
          if(clone['dateCreated'] != null)
            clone.update('dateCreated', (update) => DateTime.fromMicrosecondsSinceEpoch(result['dateCreated']).toString());
            
          return MemeEntity.fromJson(clone);
        });

        return Collection(results);
      });
    });
  }

  Future<IEnumerable<ContentBaseEntity>> getClusterFavoritesByEntity(IEnumerable<ContentBase> clusters) async {
    return await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        String parameters = clusters.select((c) => "(?)").toList().join(',');
        return await transaction.rawQuery(
            "WITH clusterIds(clusterId) AS (VALUES $parameters) " +
                "SELECT a.clusterId as id,  b.timestamp as dateCreated, b.path as path," +
                "CASE WHEN b.timestamp IS NULL THEN 'false' ELSE 'true' END as isLiked " +
                "FROM clusterIds a LEFT JOIN cluster_favorites b ON a.clusterId=b.clusterId",
            clusters.select((c) => c.id).toList());
      });
    }).then((results) =>
        Collection(results.map((result) {
          var clone = Map.of(result);
          
          //convert the int to datetime string
          if(clone['dateCreated'] != null)
            clone.update('dateCreated', (update) => DateTime.fromMicrosecondsSinceEpoch(result['dateCreated']).toString());
            
          return ContentBaseEntity.fromJson(clone);
        }).toList()));
  }

  Future<bool> favoriteCluster(MemeCluster cluster, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int newLike = await database.insert('cluster_favorites', { "clusterId": cluster.id, "path": cluster.path, "timestamp": timestamp.millisecondsSinceEpoch });
        int audit = await database.insert('cluster_favorites_history', {
          "clusterId": cluster.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeAdded
        });
        return newLike > 0 && audit > 0;
      }).catchError((error) {
        throw error;
      });

  Future<bool> removeClusterFavorite(
          MemeCluster cluster, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int deletedCluster = await database.delete('cluster_favorites',
            where: "clusterId = ?", whereArgs: [cluster.id]);
        int audit = await database.insert('cluster_favorites_history', {
          "clusterId": cluster.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeRemoved
        });

        return deletedCluster == 1 && audit > 0;
      }).catchError((error) {

      });

  Future<bool> favoriteMeme(Meme meme, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int newLike = await database.insert('meme_favorites', 
        { "memeId": meme.id, "path": meme.path, "memeType": meme.runtimeType.toString(), "timestamp": timestamp.millisecondsSinceEpoch });
        int audit = await database.insert('meme_favorites_history', {
          "memeId": meme.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeAdded
        });

        return newLike > 0 && audit > 0;
      });

  Future<bool> removeMemeFavorite(Meme meme, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int deletedLike = await database
            .delete('meme_favorites', where: "memeId = ?", whereArgs: [meme.id]);
        int audit = await database.insert('meme_favorites_history', {
          "memeId": meme.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeRemoved
        });

        return deletedLike == 1 && audit > 0;
      });

  Future<Database> _initDatabaseInstance() async {
    var databasePath = join(await getDatabasesPath(), 'user_database.db');
    //await deleteDatabase(databasePath);

    if (_database == null)
      _database = openDatabase(databasePath, onCreate: (db, version) {
        db.execute(
            "CREATE TABLE cluster_favorites(id INTEGER AUTO_INCREMENT, clusterId TEXT PRIMARY KEY, path TEXT, timestamp DATETIME)");
        db.execute(
            "CREATE TABLE cluster_favorites_history(id INTEGER AUTO_INCREMENT PRIMARY KEY, clusterId TEXT, timestamp DATETIME, actionId TEXT)");
        db.execute(
            "CREATE TABLE meme_favorites(id INTEGER AUTO_INCREMENT, memeId TEXT PRIMARY KEY, memeType TEXT, path TEXT, timestamp DATETIME)");
        db.execute(
            "CREATE TABLE meme_favorites_history(id INTEGER AUTO_INCREMENT PRIMARY KEY, memeId TEXT, timestamp DATETIME, actionId TEXT)");
      }, version: 1);

    return await _database;
  }

  void dispose() {
    _initDatabaseInstance().then((database) => database.close());
  }
}
