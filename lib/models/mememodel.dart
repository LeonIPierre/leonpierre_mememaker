import 'package:flutter/cupertino.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';

@immutable
abstract class Meme extends ContentBase {
  final DateTime dateCreated;
  final  DateTime datePosted;

  //aggregate the states across different platforms
  final List<int> likes;

  //ml tags so that are found from the meme
  final List<String> tags;

  Meme(id, Uri locationPath, this.dateCreated,
      {this.datePosted, isLiked, author, this.likes, this.tags}) :
      super(id, path: locationPath, isLiked: isLiked, author: author);

  Object clone({Meme copyFrom});

  Meme cloneWithProps({bool isLiked});

  static Meme mapFromEntity(MemeEntity entity) {
    switch (entity.type) {
      case "ImageMeme":
        return ImageMeme.fromEntity(entity);
      default:
       throw new Exception("Invalid entity type ${entity.type}");
    }
  }
}

//need to be able to reate the state
class AudioMeme extends TextMeme {
  final int startPosition;
  final int endPosition;

  AudioMeme(String id, Uri uri, DateTime dateCreated, String text,
      {this.startPosition = 0, this.endPosition = 0, bool isLiked})
      : super(id, uri, dateCreated, text);
      
  @override
  Object clone({Meme copyFrom}) {
    return AudioMeme(id, path, dateCreated, text);
  }

  @override
  Meme cloneWithProps({bool isLiked}) {
    return AudioMeme(id, path, dateCreated, text, isLiked: isLiked);
  }
}

class GifMeme extends Meme {
  GifMeme(String id, Uri uri, DateTime dateCreated)
      : super(id, uri, dateCreated);

  @override
  Object clone({Meme copyFrom}) {
    return GifMeme(id, path, dateCreated);
  }

  @override
  Meme cloneWithProps({bool isLiked}) {
    // TODO: implement cloneWithProps
    return null;
  }
}

class ImageMeme extends Meme {
  final String text;
  ImageMeme(String id, Uri uri, DateTime dateCreated, {DateTime datePosted, this.text, bool isLiked, String author})
      : super(id, uri, dateCreated, isLiked: isLiked, author: author);

  @override
  Object clone({Meme copyFrom}) {
    return ImageMeme(id, path, dateCreated, datePosted: datePosted, text: text,
      isLiked: copyFrom.isLiked, author: author);
  }

  @override
  Meme cloneWithProps({bool isLiked}) {
    return ImageMeme(this.id, this.path, this.dateCreated, datePosted: this.datePosted,
    text: this.text, author: this.author, isLiked: isLiked);
  }

  static ImageMeme fromJson(Map<String, dynamic> json) {
    return new ImageMeme(json['id'], Uri.parse(json['url']),
        DateTime.parse(json['dateCreated']));
  }

  static ImageMeme fromEntity(MemeEntity entity) {
    return ImageMeme(entity.id, Uri.parse(entity.path), entity.dateCreated, datePosted: entity.datePosted, author: entity.author, isLiked: entity.dateLiked != null);
  }
}

class TextMeme extends Meme {
  final String text;
  TextMeme(String id, Uri uri, DateTime dateCreated, this.text)
      : super(id, uri, dateCreated);

  @override
  Object clone({Meme copyFrom}) {
    return TextMeme(copyFrom?.id ?? id, copyFrom?.path ?? path, copyFrom?.dateCreated ?? dateCreated, text);
  }

  @override
  Meme cloneWithProps({bool isLiked}) {
    // TODO: implement cloneWithProps
    return null;
  }
}

//need to be able to reate the state
class VideoMeme extends Meme {
  final int startPosition;
  final int endPosition;
  VideoMeme(String id, Uri uri, DateTime dateCreated,
      [this.startPosition = 0, this.endPosition = 0])
      : super(id, uri, dateCreated);

  @override
  Object clone({Meme copyFrom}) {
    return VideoMeme(id, path, dateCreated, startPosition, endPosition);
  }

  @override
  Meme cloneWithProps({bool isLiked}) {
    // TODO: implement cloneWithProps
    return null;
  }
}
