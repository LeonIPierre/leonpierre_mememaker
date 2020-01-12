import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:queries/collections.dart';

class MemeCluster {
  final String id;

  final String description;

  final IEnumerable<Meme> memes;

  MemeCluster({this.id, this.description, this.memes});

  factory MemeCluster.fromJson(Map<String, dynamic> json) {
    var memesJson = json['memes'] as List;

    return MemeCluster(
      id: json['id'],
      description: json['description'],
      memes: Collection(memesJson.map((i) => ImageMeme.fromJson(i)).toList())
    );
  }
}
