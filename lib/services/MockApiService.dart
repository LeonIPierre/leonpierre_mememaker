import 'package:faker/faker.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';

class MockApiService {
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
}
