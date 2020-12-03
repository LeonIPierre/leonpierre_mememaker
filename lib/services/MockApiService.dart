import 'package:faker/faker.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:queries/collections.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';

import 'memeclustersservice.dart';

class MockApiService extends MemeClustersService{
  final mockApi = Faker();
  final DateTime now = DateTime.now();

  Future<List<Meme>> getMemesAsync({bool expression(Meme meme)}) async {
    var results = await _getAll();
    return expression == null ? results : results.where(expression).toList();
  }

  Future<List<Meme>> _getAll() async => Future.delayed(
      Duration(milliseconds: 500),
      () => [
            ImageMeme(
                "1",
                Uri.parse("http://via.placeholder.com/400x800.png?text=${faker.lorem.word()}"),
                now.subtract(Duration(days: 2)),
                text: "This is a placeholder"),
            ImageMeme(
                "2",
                Uri.parse("http://via.placeholder.com/400x800.png?text=${faker.lorem.word()}"),
                now.subtract(Duration(days: 1)),
                text: "This is a placeholder"),
            ImageMeme(
                "3",
                Uri.parse("http://via.placeholder.com/400x800.png?text=${faker.lorem.word()}"),
                now,
                text: "This is a placeholder"),
            ImageMeme(
                "4",
                Uri.parse("http://via.placeholder.com/400x800?text=${faker.lorem.word()}"),
                now.add(Duration(days: 1)),
                text: "This is a placeholder 2"),
            TextMeme("3", Uri(), DateTime.now().add(Duration(days: 5)),
                now.toString()),
          ]);

  @override
  Future<IEnumerable<MemeClusterEntity>> byDateRangeAsync(DateTime start, DateTime end) {
      List<MemeClusterEntity> clusters = List<MemeClusterEntity>();
      List<MemeEntity> memes = List<MemeEntity>();

      for(int i = 0; i < 5; i++)
      {
        
        memes.add(MemeEntity(i.toString(), "https://via.placeholder.com/400x800?text=${faker.lorem.word()}", "ImageMeme"));
        clusters.add(MemeClusterEntity(i.toString(), memes: Collection(memes)));
      }

      return Future.value(Collection(clusters));
    }
  
    @override
    Future<MemeClusterEntity> byIdAsync(String clusterId) {
    // TODO: implement byIdAsync
    throw UnimplementedError();
  }

  @override
  Future<IEnumerable<MemeClusterEntity>> byNewestAsync() {
    List<MemeClusterEntity> clusters = List<MemeClusterEntity>();
      List<MemeEntity> memes = List<MemeEntity>();

      for(int i = 0; i < 5; i++)
      {
        
        memes.add(MemeEntity(i.toString(), "https://via.placeholder.com/400x600?text=${faker.lorem.word()}", "ImageMeme"));
        clusters.add(MemeClusterEntity(i.toString(), memes: Collection(memes)));
      }

      return Future.value(Collection(clusters));
  }
}
