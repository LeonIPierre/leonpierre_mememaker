import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  Stream<List<ContentBase>> get favorites => _favoritesSubject.stream;

  final Set<ContentBase> _favoritesList = Set<ContentBase>();
  final BehaviorSubject<List<ContentBase>> _favoritesSubject = BehaviorSubject<List<ContentBase>>();
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc(this._favoritesRepository);

  @override
  FavoritesState get initialState => FavoritesEmptyState();

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    switch (event.id) {
      case FavoritesEventId.FavoritesUnitialized:
        var start = DateTime.now();
        var end = start.subtract(Duration(days: 7));
        var entities = await _favoritesRepository.getMemeFavoritesByHistory(start, end);

        if (entities.any()) {
          var memes = entities.select((x) => Meme.mapFromEntity(x));

          _favoritesList.addAll(memes.asIterable());
          _favoritesSubject.add(UnmodifiableListView(_favoritesList));
          //var start = entities.orderBy((x) => x.dateLiked).toList().first.dateLiked;
          //var end = start.subtract(Duration(days: 7));

          yield FavoritedContentLoadedByDateRangeState(memes, start, end, hasReachedMax: false);
        } else {
          yield FavoritesEmptyState();
        }
        break;
      case FavoritesEventId.LoadFavoritedMemeClusters:
      //case FavoritesEventId.LoadFavoritedMemes:
        if (state is FavoritedContentLoadedByDateRangeState) {
          var currentState = state as FavoritedContentLoadedByDateRangeState;
          var currentMemes = currentState.items;
          var entities = await _favoritesRepository.getMemeFavoritesByHistory(currentState.start, currentState.end);
          var memes = entities.select((x) => Meme.mapFromEntity(x));

          if (entities.any()) {
            _favoritesList.addAll(memes.asIterable());
            _favoritesSubject.add(UnmodifiableListView(_favoritesList));
            yield FavoritedContentLoadedState<Meme>(currentMemes.concat(memes), hasReachedMax: false);
          } else {
            yield FavoritedContentLoadedState<Meme>(memes, hasReachedMax: true);
          }
        } else {
            var items = (event as FavoritesByContentLoadEvent<MemeCluster>).items;
            var entities = await _favoritesRepository.getClusterFavoritesByEntity(items);

            if(entities.any()) {
              var favorites = _mapClustersToFavorites(items, entities.select((x) => ContentBase.fromEntity(x)));
              _favoritesList.addAll(favorites.where((x) => x.isLiked).asIterable());
              _favoritesSubject.add(_favoritesList.toList());
              yield FavoritedContentLoadedState<MemeCluster>(favorites);
            } else {
              yield FavoritesEmptyState();
            }
        }
        break;

      case FavoritesEventId.MemeClusterAdded:
        var cluster = (event as FavoriteStateChangedEvent<MemeCluster>).item;
        var success = await _favoritesRepository.favoriteCluster(cluster, DateTime.now());
        var clone = cluster.clone(isLiked: true);

        if(success && _favoritesList.add(clone)) {
          var list = _favoritesList.where((x) => x.runtimeType == MemeCluster).map((x) => x as MemeCluster).toList();
          _favoritesSubject.add(list);
          
          yield FavoritedContentChangedState(clone);
        } else {
          yield FavoritesErrorState();
        }
        break;
      case FavoritesEventId.MemeClusterRemoved:
        var cluster = (event as FavoriteStateChangedEvent<MemeCluster>).item;
        var success = await _favoritesRepository.removeClusterFavorite(cluster, DateTime.now());
        var clone = cluster.clone(isLiked: false);

        if(success && _favoritesList.remove(cluster)) {
          var list = _favoritesList.where((x) => x.runtimeType == MemeCluster).map((x) => x as MemeCluster).toList();
          _favoritesSubject.add(list);
          
          yield FavoritedContentChangedState(clone);
        } else {
          yield FavoritesErrorState();
        }
        break;
      // case FavoritesEventId.MemeAdded:
      //   var meme = (event as FavoriteStateChangedEvent<Meme>).item;
      //   var success =
      //       await _favoritesRepository.favoriteMeme(meme, DateTime.now());

      //   if (success) {
      //     _favoritesList.add(meme);
      //     _favoritesSubject.add(UnmodifiableListView(_favoritesList));
      //     //yield FavoritedContentChangedState(meme);
      //   } else {
      //     yield FavoritesErrorState();
      //   }
      //   break;
      // case FavoritesEventId.MemeRemoved:
      //   var meme = (event as FavoriteStateChangedEvent).item;
      //   var success =
      //       await _favoritesRepository.removeMemeFavorite(meme, DateTime.now());

      //   if (success) {
      //     _favoritesList.remove(meme);
      //     _favoritesSubject.add(UnmodifiableListView(_favoritesList));
      //     yield FavoritedContentChangedState(meme);
      //   } else {
      //     yield FavoritesErrorState();
      //   }
      //   break;
      default:
        yield state;
    }
  }

  void dispose() {
    _favoritesSubject.close();
  }

  IEnumerable<MemeCluster> _mapClustersToFavorites(IEnumerable<MemeCluster> items, IEnumerable<ContentBase> favorites) {
    return items.join(favorites, (item) => item.id, (ContentBase fav) => fav.id, (item, ContentBase fav) => 
      MemeCluster(item.id, memes: item.memes, description: item.description, isLiked: fav.isLiked));
  }

  
  // Future<IEnumerable<MemeCluster>> _getMappedClustersToFavorites(
  //     IEnumerable<MemeClusterEntity> clusterEntities) async {
  //   return await _favoritesRepository
  //       .getClusterFavoritesByEntity(clusterEntities)
  //       .then((userClusterLikes) {
  //     return clusterEntities.join(
  //         userClusterLikes,
  //         (entity) => entity.id,
  //         (favorite) => (favorite as UserLikeEntity).contentId,
  //         (entity, favorite) =>
  //             {"entity": entity, "like": favorite as UserLikeEntity});
  //   }).then((mappedClusters) async {
  //     var clusters = List<MemeCluster>();
  //     final clusterFutures = <Future<void>>[];

  //     //TODO: run 1 query for all memes then map them back to the clusters
  //     mappedClusters.toList().forEach((mappedCluster) {
  //       var entity = mappedCluster["entity"] as MemeClusterEntity;
  //       var like = mappedCluster["like"] as UserLikeEntity;

  //       clusterFutures.add(_mapMemesToFavorites(entity.memes)
  //           .then((memes) => MemeCluster(entity.id,
  //               memes: memes,
  //               description: entity.description,
  //               isLiked: like.isLiked))
  //           .then((cluster) => clusters.add(cluster)));
  //     });

  //     return await Future.wait(clusterFutures).then((value) {
  //       return Collection(clusters);
  //     }).catchError((error) {
  //       throw Exception("Error when mapping cluster to favorites");
  //     });
  //   });
  // }

  // Future<IEnumerable<Meme>> _mapMemesToFavorites(
  //         IEnumerable<MemeEntity> memes) async =>
  //     await _favoritesRepository
  //         .getMemeFavoritesByEntity(memes)
  //         .then((userLikes) => memes.join(
  //             userLikes,
  //             (entity) => entity.id,
  //             (favorite) => (favorite as UserLikeEntity).contentId,
  //             (entity, favorite) => Meme.mapFromCopy(entity.type,
  //                 id: entity.id,
  //                 uri: entity.uri,
  //                 dateCreated: entity.dateCreated,
  //                 datePosted: entity.datePosted,
  //                 isLiked: (favorite as UserLikeEntity).isLiked,
  //                 author: entity.author)))
  //         .catchError((error) {
  //       throw Exception("Error thrown when trying to map meme to favorites");
  //     });
}
