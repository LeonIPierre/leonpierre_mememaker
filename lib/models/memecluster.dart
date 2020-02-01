import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:queries/collections.dart';

class MemeCluster extends Equatable {
  final String id;

  final String description;

  final bool isLiked;

  final IEnumerable<Meme> memes;

  const MemeCluster(this.id, {this.description, this.memes, this.isLiked});

  @override
  List<Object> get props => [id, memes];

  static MemeCluster fromEntity(MemeClusterEntity entity) =>
      MemeCluster(entity.id,
          description: entity.description,
          memes: entity.memes.select((m) => Meme.mapFromEntity(m)));
}