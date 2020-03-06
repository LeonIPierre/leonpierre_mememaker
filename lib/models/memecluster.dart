import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:queries/collections.dart';

class MemeCluster extends ContentBase {
  final String description;
  final IEnumerable<Meme> memes;

  const MemeCluster(id, {this.description, this.memes, bool isLiked}) : super(id, isLiked: isLiked);

  @override
  List<Object> get props => [id];

  @override
  bool operator ==(covariant MemeCluster other) => this.id == other.id;

  @override
  int get hashCode => id.hashCode;

  MemeCluster clone({bool isLiked}) => MemeCluster(this.id, description: this.description, memes: this.memes, isLiked: isLiked);

  static MemeCluster fromEntity(MemeClusterEntity entity) =>
      MemeCluster(entity.id,
          description: entity.description,
          memes: entity.memes.select((m) => Meme.mapFromEntity(m)));
}