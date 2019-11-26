class Meme {
  String author;
  DateTime dateCreated;
  String id;
  Uri uri;
  
  //aggregate the states across different platforms
  List<int> likes;

  //ml tags so that are found from the meme
  List<String> tags;
  
  Meme(String id, Uri uri);
}

//need to be able to reate the state
class AudioMeme extends TextMeme {
  int startPosition;
  int endPosition;

  AudioMeme(String id, Uri uri, String text, [this.startPosition = 0, this.endPosition = 0]) : super(id, uri, text);
}

class GifMeme extends Meme {
  GifMeme(String id, Uri uri) : super(id, uri);
}

class ImageMeme extends Meme {
  String text;
  ImageMeme(String id, Uri uri, this.text) : super(id, uri);
}

class TextMeme extends Meme {
  String text;
  TextMeme(String id, Uri uri, this.text) : super(id, uri);
}

//need to be able to reate the state
class VideoMeme extends Meme {
  int startPosition;
  int endPosition;
  VideoMeme(String id, Uri uri, [this.startPosition = 0, this.endPosition = 0]) : super(id, uri);
}