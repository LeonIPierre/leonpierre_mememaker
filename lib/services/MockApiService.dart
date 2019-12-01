import 'package:faker/faker.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';

class MockApiService {
  final mockApi = Faker();

  Future<List<Meme>> getMemesAsync() async {
    return [
      ///VideoMeme("", Uri()),
      //GifMeme("", Uri()),
      //AudioMeme("", Uri()),

      //AudioMeme("", Uri()),
      ImageMeme("", Uri.parse("http://via.placeholder.com/400x800.png?text=Meme1"),
        DateTime.now(), "This is a placeholder"),
      ImageMeme("", Uri.parse("http://via.placeholder.com/400x800?text=Meme2"),
        DateTime.now(), "This is a placeholder 2"),
      TextMeme("", Uri(),DateTime.now(), Faker().lorem.word()),
    ];
  }
}