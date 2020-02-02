import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

enum FavoritesEventId {
  //ideal
  FavoritesLoaded,

  //empty
  NoFavoritesLoaded,

  //partial
  AllFavoritesRemoved,
  MemeClusterFavoriteAdded,
  MemeClusterFavoriteRemoved,
  MemeFavoriteAdded,
  MemeFavoriteRemoved,

  //loading
  LoadFavorites,

  //error
  ErrorLoadingFavorites,
  ErrorAddingMemeCluster,
  ErrorRemovingMemeCluster,
  ErrorAddingMeme,
  ErrorRemovingMeme,
}

class FavoritesEvent extends Equatable {
  final FavoritesEventId id;
  const FavoritesEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FavoritesLoadedEvent extends FavoritesEvent {
  final IEnumerable<UserLikeEntity> favorites;

  FavoritesLoadedEvent(this.favorites) : super(FavoritesEventId.FavoritesLoaded);  
}