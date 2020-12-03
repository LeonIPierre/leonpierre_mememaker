import 'package:queries/collections.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'entities/meme.dart';

class DownloadsRepository {
  Database _database;

  Future<IEnumerable<MemeEntity>> getDownloadsByDateRangeAsync(
      DateTime start, DateTime end) async => await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        List parameters = [ start.millisecondsSinceEpoch, end.millisecondsSinceEpoch ];
        //TODO: query should be datetime(timestamp,'unixepoch') as dateCreated but its currently unsupported
        var downloads = await transaction.rawQuery(
                "SELECT id, timestamp, path FROM downloads WHERE timestamp BETWEEN ? AND ?", parameters);
        
        var results = downloads.map((result) {
          var clone = Map.of(result);
          
          //the DownloadEntity.fromJson expects datetime to be an int so convert it from string
          if(clone['timestamp'] != null)
            clone.update('timestamp', (update) => DateTime.fromMicrosecondsSinceEpoch(result['timestamp']).toString());
            
          return MemeEntity.fromJson(clone);
        }).toList();

        return Collection(results);
      });
    })
    .catchError((error) => _handleError(error));

  Future<IEnumerable<MemeEntity>> getDownloadsAsync(int startIndex, int limit) async =>
        await _initDatabaseInstance().then((database) async {
      return await database.transaction((transaction) async {
        List parameters = [ limit ];
        //TODO: query should be datetime(timestamp,'unixepoch') as dateCreated but its currently unsupported
        var downloads = await transaction.rawQuery(
                "SELECT id, timestamp, path FROM downloads LIMIT ?", parameters);
        
        var results = downloads.map((result) {
          var clone = Map.of(result);
          
          //the DownloadEntity.fromJson expects datetime to be an int so convert it from string
          if(clone['timestamp'] != null)
            clone.update('timestamp', (update) => DateTime.fromMicrosecondsSinceEpoch(result['timestamp']).toString());
            
          return MemeEntity.fromJson(clone);
        }).toList();

        return Collection(results);
      });
    })
    .catchError((error) => _handleError(error));

  Future<MemeEntity> getDownloadAsync(String id) {}

  Future<bool> deleteDownloadAsync(String id) async =>
      await _initDatabaseInstance().then((database) async {
        int deletedCluster = await database.delete('downloads', where: "id = ?", whereArgs: [id]);

        return deletedCluster == 1;
      })
      .catchError((error) => _handleError(error));

  void dispose() {
    _database.close();
    _database = null;
  }

  _handleError(Object error) {
    throw error;
    //log somewhere
  }

  Future<Database> _initDatabaseInstance() async {
    if (_database != null)
      return _database;

    _database = await getDatabasesPath().then((path) {
      var databasePath = join(path, 'user_database.db');

        return openDatabase(databasePath, onCreate: (db, version) {
          db.execute(
              "CREATE TABLE downloads(id TEXT PRIMARY KEY, memeType TEXT, path TEXT, timestamp DATETIME)");
        }, version: 1);
    });

    return _database;
  }

  Future<void> _dropDatabase() async {
    var databasePath = join(await getDatabasesPath(), 'user_database.db');
    await deleteDatabase(databasePath)
        .catchError((error) => _handleError(error));
  }
}
