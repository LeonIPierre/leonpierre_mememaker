import 'package:equatable/equatable.dart';

enum FavoriteEventId {
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

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}