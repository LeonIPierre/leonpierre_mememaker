import 'dart:async';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:path/path.dart';
import 'package:queries/collections.dart';
import 'package:sqflite/sqflite.dart';

class UserLikesRepository {
  final String auditLikeAdded = "LIKE_ADDED";
  final String auditLikeRemoved = "LIKE_REMOVED";

  Future<Database> _database;

  void _sync() {
    //when a user goes to premium save
  }

  Future<IEnumerable<UserLikeEntity>> getUserClusterLikesAsync(
      IEnumerable<MemeClusterEntity> clusters) async {
    return await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        String parameters = clusters.select((c) => "(?)").toList().join(',');
        return await transaction.rawQuery(
            "WITH clusterIds(clusterId) AS (VALUES $parameters) " +
                "SELECT a.clusterId as id, CASE WHEN b.dateliked IS NULL THEN 'false' ELSE 'true' " +
                "END As isLiked FROM clusterIds a " +
                "LEFT JOIN cluster_likes b ON a.clusterId=b.clusterId",
            clusters.select((c) => c.id).toList());
      });
    }).then((results) =>
        Collection(results.map((m) => UserLikeEntity.fromMap(m)).toList()));
  }

  Future<IEnumerable<UserLikeEntity>> getUserMemeLikesAsync(IEnumerable<MemeEntity> memes) async {
    return await _initDatabaseInstance().then((database) async {
        return database.transaction((transaction) async {
          String parameterValues = memes.select((c) => "(?)").toList().join(',');
          return await transaction.rawQuery("WITH memeIds(memeId) AS (VALUES $parameterValues) " +
              "SELECT a.memeId as id, CASE WHEN b.dateliked IS NULL THEN 'false' ELSE 'true' END As isLiked FROM memeIds a " +
              "LEFT JOIN meme_likes b ON a.memeId=b.memeId",
          memes.select((m) => m.id).toList());
        });
      }).then((results) =>
        Collection(results.map((m) => UserLikeEntity.fromMap(m)).toList()));
  }

  Future<bool> likeCluster(MemeCluster cluster, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int newLike = await database.insert(
            'cluster_likes', {"clusterId": cluster.id, "dateLiked": timestamp.millisecondsSinceEpoch});
        int audit = await database.insert('cluster_likes_audit', {
          "clusterId": cluster.id,
          "auditTimestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeAdded
        });
        return newLike == 1 && audit == 1;
      });

  Future<bool> removeClusterLike(MemeCluster cluster, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int deletedCluster = await database.delete('cluster_likes',
            where: "clusterId = ?", whereArgs: [cluster.id]);
        int audit = await database.insert('cluster_likes_audit', {
          "clusterId": cluster.id,
          "auditTimestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeRemoved
        });

        return deletedCluster == 1 && audit == 1;
      });

  Future<bool> likeMeme(Meme meme, DateTime timestamp) async {
    final db = await _initDatabaseInstance();

    int newLike = await db
        .insert('meme_likes', {"memeId": meme.id, "dateLiked": timestamp});
    int audit = await db.insert('meme_likes_audit', {
      "memeId": meme.id,
      "auditTimestamp": timestamp.millisecondsSinceEpoch,
      "actionId": auditLikeAdded
    });

    return newLike == 1 && audit == 1;
  }

  Future<bool> removeMemeLike(Meme meme, DateTime timestamp) async =>
      await _initDatabaseInstance().then((database) async {
        int deletedLike = await database
            .delete('meme_likes', where: "memeId = ?", whereArgs: [meme.id]);
        int audit = await database.insert('meme_likes_audit', {
          "memeId": meme.id,
          "auditTimestamp": timestamp.millisecondsSinceEpoch,
          "actionId": auditLikeRemoved
        });

        return deletedLike == 1 && audit == 1;
      });

  Future<Database> _initDatabaseInstance() async {
    if (_database == null)
      _database =
          openDatabase(join(await getDatabasesPath(), 'user_database.db'),
              onCreate: (db, version) {
        db.execute(
            "CREATE TABLE cluster_likes(clusterId TEXT PRIMARY KEY, dateLiked DATETIME)");
        db.execute(
            "CREATE TABLE cluster_likes_audit(clusterId TEXT, auditTimestamp DATETIME, actionId TEXT)");
        db.execute(
            "CREATE TABLE meme_likes(memeId TEXT PRIMARY KEY, dateLiked DATETIME)");
        db.execute(
            "CREATE TABLE meme_likes_audit(memeId TEXT, auditTimestamp DATETIME, actionId TEXT)");
      }, version: 1);

    return await _database;
  }

  void dispose() {
    _initDatabaseInstance().then((database) => database.close());
  }
}
