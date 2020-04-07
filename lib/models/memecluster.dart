import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:queries/collections.dart';

class MemeCluster extends ContentBase {
  final String description;
  final IEnumerable<Meme> memes;

  const MemeCluster(id, {this.description, this.memes, bool isLiked}) : super(id, isLiked: isLiked);
  
  MemeCluster clone({IEnumerable<Meme> memes, bool isLiked}) => 
    MemeCluster(this.id, description: this.description, memes: memes ?? this.memes, isLiked: isLiked ?? this.isLiked);

  static MemeCluster fromEntity(MemeClusterEntity entity) =>
      MemeCluster(entity.id,
          description: entity.description,
          isLiked: entity.dateLiked != null,
          memes: entity.memes == null ? null : entity.memes.select((m) => Meme.mapFromEntity(m)));
}