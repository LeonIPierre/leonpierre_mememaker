import 'package:leonpierre_mememaker/repositories/entities/meme.dart';

abstract class Meme {
  final DateTime dateCreated;
  final  DateTime datePosted;
  final String id;
  final Uri uri;

  final String author;
  final bool isLiked;

  //aggregate the states across different platforms
  List<int> likes;

  //ml tags so that are found from the meme
  List<String> tags;

  Meme(this.id, this.uri, this.dateCreated,
      {this.datePosted, this.isLiked, this.author, this.tags});

  static Meme mapFromEntity(MemeEntity entity) {
    switch (entity.type) {
      case "ImageMeme":
        return ImageMeme.fromEntity(entity);
      default:
       throw new Exception();
    }
  }

  static Meme mapFromCopy(String type, {String id, Uri uri, DateTime dateCreated, DateTime datePosted, bool isLiked, String author, List<String> tags}) {
    switch (type) {
      case "ImageMeme":
        return ImageMeme(id, uri, dateCreated, datePosted: datePosted, isLiked: isLiked, author: author);
      default:
       throw new Exception();
    }
  }
}

//need to be able to reate the state
class AudioMeme extends TextMeme {
  int startPosition;
  int endPosition;

  AudioMeme(String id, Uri uri, DateTime dateCreated, String text,
      [this.startPosition = 0, this.endPosition = 0])
      : super(id, uri, dateCreated, text);
}

class GifMeme extends Meme {
  GifMeme(String id, Uri uri, DateTime dateCreated)
      : super(id, uri, dateCreated);
}

class ImageMeme extends Meme {
  String text;
  ImageMeme(String id, Uri uri, DateTime dateCreated, {DateTime datePosted, this.text, bool isLiked, String author})
      : super(id, uri, dateCreated, isLiked: isLiked, author: author);

  ImageMeme copy({String id, Uri uri, DateTime dateCreated, DateTime datePosted, String text, bool isLiked, String author}) {
    return ImageMeme(
      id ?? this.id,
      uri ?? this.uri,
      dateCreated ?? this.dateCreated,
      datePosted: datePosted ?? this.datePosted,
      text: text ?? this.text,
      author: author ?? this.author,
      isLiked: isLiked ?? this.isLiked);
  }

  static ImageMeme fromJson(Map<String, dynamic> json) {
    return new ImageMeme(json['id'], Uri.parse(json['url']),
        DateTime.parse(json['dateCreated']));
  }

  static ImageMeme fromEntity(MemeEntity entity) {
    return ImageMeme(entity.id, entity.uri, entity.dateCreated, datePosted: entity.datePosted, author: entity.author);
  }
}

class TextMeme extends Meme {
  String text;
  TextMeme(String id, Uri uri, DateTime dateCreated, this.text)
      : super(id, uri, dateCreated);
}

//need to be able to reate the state
class VideoMeme extends Meme {
  int startPosition;
  int endPosition;
  VideoMeme(String id, Uri uri, DateTime dateCreated,
      [this.startPosition = 0, this.endPosition = 0])
      : super(id, uri, dateCreated);
}
