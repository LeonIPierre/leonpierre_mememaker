import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  BehaviorSubject<Set<ContentBase>> get favorites => Stream.fromFuture(_clusterFavoritesSubject.addStream(_memeFavoritesSubject.stream));
  BehaviorSubject<Set<ContentBase>> get clusterFavorites => _clusterFavoritesSubject.stream;
  BehaviorSubject<Set<ContentBase>> get memeFavorites => _memeFavoritesSubject.stream;
  
  final Set<ContentBase> _clusterFavorites = Set<ContentBase>();
  final Set<ContentBase> _memeFavorites = Set<ContentBase>();
  final BehaviorSubject<Set<ContentBase>> _clusterFavoritesSubject = BehaviorSubject<Set<ContentBase>>();
  final BehaviorSubject<Set<ContentBase>> _memeFavoritesSubject = BehaviorSubject<Set<ContentBase>>();
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc(this._favoritesRepository);

  @override
  FavoritesState get initialState => FavoritesEmptyState();

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    switch (event.id) {
      case FavoritesEventId.FavoritesUnitialized:
        var end = DateTime.now();
        var start = end.subtract(Duration(days: 7));
        yield* _mapUnitializedState(start, end);
        break;
      case FavoritesEventId.LoadFavoritedMemeClusters:
        yield* _mapFavoritesRequest(event as FavoritesByContentLoadEvent<MemeCluster>);
        break;
      case FavoritesEventId.LoadFavoritedMemes:
        var memes = (state as FavoritedContentLoadedState<Meme>).items;
        var start = memes.last().dateCreated;
        var end = start.subtract(Duration(days: 7));
        yield* _mapLoadFavoriteMemesState(start, end);
        break;
      case FavoritesEventId.MemeClusterAdded:
        yield* _mapMemeClusterAddedState(event as FavoriteStateChangedEvent<MemeCluster>);
        break;
      case FavoritesEventId.MemeClusterRemoved:
        yield* _mapMemeClusterRemovedState(event as FavoriteStateChangedEvent<MemeCluster>);
        break;
      case FavoritesEventId.MemeAdded:
        yield* _mapMemeAddedState(event as FavoriteStateChangedEvent<Meme>);
        break;
      case FavoritesEventId.MemeRemoved:
        yield* _mapMemeRemovedState(event as FavoriteStateChangedEvent<Meme>);
        break;
      default:
        throw Exception("Invalid error ${event.id}");
    }
  }

  @override
  Future<void> close() {
    _favoritesRepository.dispose();
    _clusterFavoritesSubject.close();
    _memeFavoritesSubject.close();
    return super.close();
  }

  bool _hasReachedMax(FavoritesState state) =>
      state is FavoritedContentLoadedState && state.hasReachedMax;

  Stream<FavoritesState> _mapUnitializedState(DateTime start, DateTime end) async* {
    yield await _favoritesRepository.getMemesByHistory(start, end).then((entities){
      if (!entities.any()) {
        return FavoritesEmptyState();
      }

      /*TODO figure out why there needs to be a where clause here.
      Removing it causes duplicate items to appear*/
      var memes = entities.select((x) => Meme.mapFromEntity(x)).where((x) => x.isLiked);

      _memeFavorites.addAll(memes.asIterable());
      _memeFavoritesSubject.add(_memeFavorites);
      
      return FavoritedContentLoadedByDateRangeState(memes, start, end, hasReachedMax: false);
    });
  }

  Stream<FavoritesState> _mapLoadFavoriteMemesState(DateTime start, DateTime end) async* {
    if (_hasReachedMax(state)) {
      return;
    }

    var entities = await _favoritesRepository.getMemesByHistory(start, end);

    if (entities.any()) {
      var memes = entities.select((x) => Meme.mapFromEntity(x));

      _memeFavorites.addAll(memes.asIterable());
      _memeFavoritesSubject.add(_memeFavorites);

      yield FavoritedContentLoadedByDateRangeState<Meme>(memes, start, end);
    } else {
      var memes = (state as FavoritedContentLoadedState).items;
      yield FavoritedContentLoadedState<Meme>(memes, hasReachedMax: true);
    }
  }

  Stream<FavoritesState> _mapFavoritesRequest(FavoritesByContentLoadEvent<MemeCluster> event) async* {
    yield await _favoritesRepository.mapClustersToFavorites(event.items)
    .then((entities) {
      return entities.select((x) => ContentBase.fromEntity(x));
    })
    .then((clusterEntities) async {
      return await _favoritesRepository
        .mapMemesToFavorites(event.items.selectMany((x) => x.memes).toList())
        .then((entities) {
          return entities.select((x) => ContentBase.fromEntity(x));
        })
        .then((memeEntities) {
          var favorites = _mapClustersToFavorites(event.items, clusterEntities, memeEntities);
          var clusterLikes = favorites.where((x) => x.isLiked);
          var memeLikes = favorites.selectMany((x) => x.memes).where((x) => x.isLiked);

          if(clusterLikes.any()) {
             _clusterFavorites.addAll(clusterLikes.asIterable());
             _clusterFavoritesSubject.add(_clusterFavorites);
          }

          if(memeLikes.any()) {
             _memeFavorites.addAll(memeLikes.asIterable());
             _memeFavoritesSubject.add(_memeFavorites);
          }

          return FavoritedContentRequestedState<MemeCluster>(favorites);
        });
    })
    .catchError((error) { 
      return FavoritesErrorState();
    });
  }

  Stream<FavoritesState> _mapMemeClusterAddedState(FavoriteStateChangedEvent<MemeCluster> event) async* {
    var cluster = event.item;
    var success = await _favoritesRepository.favoriteCluster(cluster, DateTime.now());
    var clone = cluster.clone(isLiked: true);

    _clusterFavorites.removeWhere((x) => x.id == clone.id);

    if (success && _clusterFavorites.add(clone)) {
      //want to do a replace or add
      _clusterFavoritesSubject.add(_clusterFavorites);
      yield FavoritedContentChangedState(clone);
    } else {
      yield FavoritesErrorState();
    }
  }

  Stream<FavoritesState> _mapMemeClusterRemovedState(FavoriteStateChangedEvent<MemeCluster> event) async* {
    var cluster = event.item;
    var success = await _favoritesRepository.removeClusterFavorite(cluster, DateTime.now());
    var clone = cluster.clone(isLiked: false);

    if (success && _clusterFavorites.remove(cluster)) {
      _clusterFavoritesSubject.add(_clusterFavorites);
      yield FavoritedContentChangedState(clone);
    } else {
      yield FavoritesErrorState();
    }
  }

  Stream<FavoritesState> _mapMemeAddedState(FavoriteStateChangedEvent<Meme> event) async* {
    yield await _favoritesRepository.favoriteMeme(event.item, DateTime.now())
    .then((success) {
      var clone = event.item.cloneWithProps(isLiked: true);

      _memeFavorites.removeWhere((x) => x.id == clone.id);
      
      if (success && _memeFavorites.add(clone)) {
        _memeFavoritesSubject.add(_memeFavorites);
        return FavoritedContentChangedState(clone);
      } else {
        return FavoritesErrorState();
      }
    });
  }
  
  Stream<FavoritesState> _mapMemeRemovedState(FavoriteStateChangedEvent<Meme> event) async* {
    yield await _favoritesRepository.removeMemeFavorite(event.item, DateTime.now())
    .then((success) {
      if (success && _memeFavorites.remove(event.item)) {
        _memeFavoritesSubject.add(_memeFavorites);
        var clone = event.item.cloneWithProps(isLiked: false);
        return FavoritedContentChangedState(clone);
      } else {
        return FavoritesErrorState();
      }
    });
  }

  IEnumerable<MemeCluster> _mapClustersToFavorites(
      IEnumerable<MemeCluster> items, IEnumerable<ContentBase> clusterFavorites,
      [IEnumerable<ContentBase> memeFavorites]) {
    return items.join(
        clusterFavorites,
        (item) => item.id,
        (ContentBase fav) => fav.id,
        (item, ContentBase fav) => MemeCluster(item.id,
            memes: _mapMemesToFavorites(item.memes, memeFavorites),
            description: item.description,
            isLiked: fav.isLiked));
  }

  IEnumerable<Meme> _mapMemesToFavorites(IEnumerable<Meme> memes, IEnumerable<ContentBase> favorites) {
    return memes.join(favorites, (item) => item.id, (ContentBase fav) => fav.id,
        (item, ContentBase fav) => item.cloneWithProps(isLiked: fav.isLiked));
  }
}
