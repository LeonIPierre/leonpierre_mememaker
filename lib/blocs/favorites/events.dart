part of 'favoritesbloc.dart';

enum FavoritesEventId {
  //empty
  FavoritesUnitialized,
  FavoritesEmpty,

  //loading
  LoadFavoritesByEntities,
  LoadFavoritedClustersAndMemes,
  LoadFavoritedMemeClusters,
  LoadFavoritedMemes,

  //ideal
  MemeClusterFavoritesLoaded,
  MemeFavoritesLoaded,
  
  //partial
  MemeClusterAdded,
  MemeClusterRemoved,
  MemeAdded,
  MemeRemoved
  
  //error
}

abstract class FavoritesEvent extends Equatable {
  final FavoritesEventId id;
  const FavoritesEvent(this.id);
}

class FavoritesLoadEvent extends FavoritesEvent {
  const FavoritesLoadEvent(FavoritesEventId id): super(id);

  @override
  List<Object> get props => [id];
}

class FavoritesLoadedEvent<T extends ContentBase> extends FavoritesEvent {
  final IEnumerable<T> favorites;

  FavoritesLoadedEvent(FavoritesEventId id, this.favorites) : super(id);

  @override
  List<Object> get props => [id, favorites];
}

class FavoritesByContentLoadEvent<T extends ContentBase> extends FavoritesEvent {
  final IEnumerable<T> items;

  FavoritesByContentLoadEvent(FavoritesEventId id, this.items) : super(id);

  @override
  List<Object> get props => [id, items];
}

class FavoriteStateChangedEvent<T extends ContentBase> extends FavoritesEvent {
  final T item;

  FavoriteStateChangedEvent(FavoritesEventId id, this.item)
      : super(id);

  @override
  List<Object> get props => [id, item];
}