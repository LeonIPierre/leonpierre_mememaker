import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

enum FavoritesEventId {
  LoadFavoritedClustersAndMemes,

  MemeClusterFavoritesLoaded,
  LoadMemeClusterFavorites,

  MemeFavoritesLoaded,
  LoadMemeFavorites,

  MemeClusterAdded,
  MemeClusterRemoved,

  MemeAdded,
  MemeRemoved
}

abstract class FavoritesEvent extends Equatable {
  final FavoritesEventId id;
  const FavoritesEvent(this.id);
}

class FavoritesLoaded extends FavoritesEvent {
  final IEnumerable<UserLikeEntity> favorites;

  FavoritesLoaded(FavoritesEventId id, this.favorites) : super(id);

  @override
  List<Object> get props => [id, favorites];
}

class MemeClusterFavoritesLoad extends FavoritesEvent {
  final IEnumerable<MemeClusterEntity> clusters;

  MemeClusterFavoritesLoad(FavoritesEventId id, this.clusters) : super(id);

  @override
  List<Object> get props => [clusters];
}

class MemeFavoritesLoad extends FavoritesEvent {
  final IEnumerable<MemeEntity> memes;

  MemeFavoritesLoad(this.memes) : super(FavoritesEventId.LoadMemeFavorites);

  @override
  List<Object> get props => [memes];
}

class MemeClusterFavoriteStateChangedEvent extends FavoritesEvent {
  final MemeCluster cluster;

  MemeClusterFavoriteStateChangedEvent(FavoritesEventId id, this.cluster)
      : super(id);

  @override
  List<Object> get props => [cluster];
}