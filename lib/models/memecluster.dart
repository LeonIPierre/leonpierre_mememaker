import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:queries/collections.dart';

class MemeCluster extends Equatable{
  final String id;

  final String description;

  final IEnumerable<Meme> memes;

  const MemeCluster({this.id, this.description, this.memes});

  factory MemeCluster.fromJson(Map<String, dynamic> json) {
    var memesJson = json['memes'] as List;

    return MemeCluster(
      id: json['id'],
      description: json['description'],
      memes: Collection(memesJson.map((i) => ImageMeme.fromJson(i)).toList())
    );
  }

  @override
  List<Object> get props => [id, memes];
}
