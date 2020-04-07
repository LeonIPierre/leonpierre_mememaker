import 'dart:async';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:path/path.dart';
import 'package:queries/collections.dart';
import 'package:sqflite/sqflite.dart';

//https://snowplowanalytics.com/blog/2018/03/26/building-a-model-for-atomic-event-data-as-a-graph/#the-next-post-in-the-series
class FavoritesRepository {
  final String _auditLikeAdded = "LIKE_ADDED";
  final String auditLikeRemoved = "LIKE_REMOVED";

  Future<Database> _database;

  Future<IEnumerable<MemeEntity>> getMemesByHistory(DateTime start, DateTime end) async {
    return await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        List parameters = [ start.millisecondsSinceEpoch, end.millisecondsSinceEpoch ];
        //TODO: query should be datetime(b.timestamp,'unixepoch') as dateCreated but its currently unsupported
        var favorites = await transaction.rawQuery(
                "SELECT memeId AS id, timestamp as dateCreated, memeType as type, path as url " +
                "FROM meme_favorites WHERE timestamp BETWEEN ? AND ?", parameters);
        
        var results = favorites.map((result) {
          var clone = Map.of(result);
          
          //the MemeEntity.fromJson expects datetime to be an int so convert it from string
          if(clone['dateCreated'] != null)
            clone.update('dateCreated', (update) => DateTime.fromMicrosecondsSinceEpoch(result['dateCreated']).toString());
            
          return MemeEntity.fromJson(clone);
        }).toList();

        return Collection(results);
      });
    })
    .catchError((error) => _handleError(error));
  }

  Future<IEnumerable<ContentBaseEntity>> mapClustersToFavorites(IEnumerable<MemeCluster> clusters) async {
    return await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        String parameters = clusters.select((c) => "(?)").toList().join(',');
        return await transaction.rawQuery(
            "WITH clusterIds(clusterId) AS (VALUES $parameters) " +
                "SELECT a.clusterId as id,  b.timestamp as dateLiked, b.path as path " +
                "FROM clusterIds a LEFT JOIN cluster_favorites b ON a.clusterId=b.clusterId",
            clusters.select((c) => c.id).toList());
      });
    })
    .then((results) => Collection(results.map((result) {
          var clone = Map.of(result);
          
          //the ContentBaseEntity.fromJson expects datetime to be an string so convert it from int
          if(result['dateLiked'] != null)
            clone.update('dateLiked', (value) => DateTime.fromMicrosecondsSinceEpoch(value).toString());
            
          return ContentBaseEntity.fromJson(clone);
        }).toList()))
    .catchError((error) => _handleError(error));
  }
  
  Future<IEnumerable<ContentBaseEntity>> mapMemesToFavorites(List<Meme> memes) async =>
  await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        String parameters = memes.map((c) => "(?)").join(',');
        return await transaction.rawQuery(
            "WITH memeIds(memeId) AS (VALUES $parameters) " +
            "SELECT a.memeId as id, b.timestamp as dateLiked, b.path as path " +
            "FROM memeIds a LEFT JOIN meme_favorites b ON a.memeId=b.memeId",
            memes.map((c) => c.id).toList());
      })
      .then((results) =>
        Collection(results.map((result) {
          var clone = Map.of(result);
          
          //the ContentBaseEntity.fromJson expects datetime to be an string so convert it from int
          if(result['dateLiked'] != null)
            clone.update('dateLiked', (value) => DateTime.fromMicrosecondsSinceEpoch(value).toString());
            
          return ContentBaseEntity.fromJson(clone);
        }).toList()));
    })
    .catchError((error) => _handleError(error));

  Future<bool> favoriteCluster(MemeCluster cluster, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int newLike = await database.insert('cluster_favorites', { "clusterId": cluster.id, "path": cluster.path, "timestamp": timestamp.millisecondsSinceEpoch });
        int audit = await database.insert('cluster_favorites_history', {
          "clusterId": cluster.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": _auditLikeAdded
        });
        return newLike > 0 && audit > 0;
      })
      .catchError((error) => _handleError(error));

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
      })
      .catchError((error) => _handleError(error));

  Future<bool> favoriteMeme(Meme meme, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int newLike = await database.insert('meme_favorites', 
        { "memeId": meme.id, "path": meme.path.toString(), "memeType": meme.runtimeType.toString(), "timestamp": timestamp.millisecondsSinceEpoch });
        int audit = await database.insert('meme_favorites_history', {
          "memeId": meme.id,
          "timestamp": timestamp.millisecondsSinceEpoch,
          "actionId": _auditLikeAdded
        });

        return newLike > 0 && audit > 0;
      })
      .catchError((error) => _handleError(error));

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
      })
      .catchError((error) => _handleError(error));

  _handleError(Object error) {
    throw error;
    //log somewhere
  }

  Future<Database> _initDatabaseInstance() async {
    var databasePath = join(await getDatabasesPath(), 'user_database.db');

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

  Future<void> _dropDatabase() async {
    var databasePath = join(await getDatabasesPath(), 'user_database.db');
    await deleteDatabase(databasePath).catchError((error) => _handleError(error));
  }

  void dispose() {
    _initDatabaseInstance().then((database) {
      database.close();
      database = null;
    });
  }
}
