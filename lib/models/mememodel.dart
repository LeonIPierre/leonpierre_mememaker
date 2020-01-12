abstract class Meme {
  String author;
  DateTime dateCreated;
  String id;
  Uri uri;
  
  //aggregate the states across different platforms
  List<int> likes;

  //ml tags so that are found from the meme
  List<String> tags;
  
  Meme(this.id, this.uri, this.dateCreated, [this.likes, this.author, this.tags]);

  //Meme fromJson(Map<String, dynamic> json);
}

//need to be able to reate the state
class AudioMeme extends TextMeme {
  int startPosition;
  int endPosition;

  AudioMeme(String id, Uri uri, DateTime dateCreated, String text, [this.startPosition = 0, this.endPosition = 0])
    : super(id, uri, dateCreated, text);

  // static Meme fromJson(Map<String, dynamic> json) {
  //   // TODO: implement fromJson
  //   return null;
  // }
}

class GifMeme extends Meme {
  GifMeme(String id, Uri uri, DateTime dateCreated) : super(id, uri, dateCreated);

  @override
  Meme fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return null;
  }
}

class ImageMeme extends Meme {
  String text;
  ImageMeme(String id, Uri uri, DateTime dateCreated, this.text) : super(id, uri, dateCreated);

  static ImageMeme fromJson(Map<String, dynamic> json) {
    return new ImageMeme(json['id'], Uri.parse(json['path']), DateTime.parse(json['dateCreated']), '');
  }
}

class TextMeme extends Meme {
  String text;
  TextMeme(String id, Uri uri, DateTime dateCreated, this.text) : super(id, uri, dateCreated);

  @override
  TextMeme fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return null;
  }
}

//need to be able to reate the state
class VideoMeme extends Meme {
  int startPosition;
  int endPosition;
  VideoMeme(String id, Uri uri, DateTime dateCreated, [this.startPosition = 0, this.endPosition = 0])
    : super(id, uri, dateCreated);

    @override
  Meme fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return null;
  }
}