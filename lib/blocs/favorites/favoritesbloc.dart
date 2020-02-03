import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:queries/collections.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc(this._favoritesRepository);

  @override
  FavoritesState get initialState => FavoritesEmptyState();

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    switch (event.id) {
      case FavoritesEventId.LoadFavoritedClustersAndMemes:
        var entities = (event as MemeClusterFavoritesLoad).clusters;
        var clusters = await _mapClustersToFavorites(entities);
         yield clusters != null && clusters.any()
            ? MemeClusterAndMemesFavoritesLoadedState(clusters)
            : FavoritesEmptyState();
        break;
      case FavoritesEventId.LoadMemeClusterFavorites:
        var entities = (event as MemeClusterFavoritesLoad).clusters;
        var favorites =
            await _favoritesRepository.getClusterFavoritesAsync(entities);

        yield favorites != null && favorites.any()
            ? MemeClusterFavoritesLoadedState(favorites)
            : FavoritesEmptyState();
        break;
      case FavoritesEventId.MemeClusterAdded:
        var cluster = (event as MemeClusterFavoriteStateChangedEvent).cluster;
        var success =
            await _favoritesRepository.favoriteCluster(cluster, DateTime.now());

        yield success
            ? MemeClusterFavoritedStateChanged(cluster)
            : FavoritesErrorState();
        break;
      case FavoritesEventId.MemeClusterRemoved:
        var cluster = (event as MemeClusterFavoriteStateChangedEvent).cluster;
        var success = await _favoritesRepository.removeClusterFavorite(
            cluster, DateTime.now());

        yield success
            ? MemeClusterFavoritedStateChanged(cluster)
            : FavoritesErrorState();
        break;
      case FavoritesEventId.LoadMemeFavorites:
        var memes = (event as MemeFavoritesLoad).memes;
        var favorites = await _favoritesRepository.getMemeFavoritesAsync(memes);

        yield favorites != null && favorites.any()
            ? FavoritesLoaded(FavoritesEventId.MemeFavoritesLoaded, favorites)
            : FavoritesErrorState();
        break;
      case FavoritesEventId.MemeAdded:
        var meme = (event as MemeFavoritedStateChanged).meme;
        var success = await _favoritesRepository.favoriteMeme(meme, DateTime.now());

        yield success ? MemeFavoritedStateChanged(meme) : FavoritesErrorState();
        break;
      case FavoritesEventId.MemeRemoved:
        var meme = (event as MemeFavoritedStateChanged).meme;
        var success =
            await _favoritesRepository.removeMemeFavorite(meme, DateTime.now());

        yield success ? MemeFavoritedStateChanged(meme) : FavoritesErrorState();
        break;
      default:
        yield state;
    }
  }

  Future<IEnumerable<MemeCluster>> _mapClustersToFavorites(
      IEnumerable<MemeClusterEntity> clusterEntities) async {
    return await _favoritesRepository
        .getClusterFavoritesAsync(clusterEntities)
        .then((userClusterLikes) {
      return clusterEntities.join(
          userClusterLikes,
          (entity) => entity.id,
          (favorite) => (favorite as UserLikeEntity).id,
          (entity, favorite) => {"entity": entity, "like": favorite as UserLikeEntity});
    }).then((mappedClusters) async {
      var clusters = List<MemeCluster>();
      final clusterFutures = <Future<void>>[];

      //TODO run 1 query for all memes then map them back to the clusters
      mappedClusters.toList().forEach((mappedCluster) {
        var entity = mappedCluster["entity"] as MemeClusterEntity;
        var like = mappedCluster["like"] as UserLikeEntity;

        clusterFutures.add(_mapMemesToFavorites(entity.memes)
            .then((memes) => MemeCluster(entity.id,
                memes: memes,
                description: entity.description,
                isLiked: like.isLiked))
            .then((cluster) => clusters.add(cluster)));
      });

      return await Future.wait(clusterFutures).then((value) {
        return Collection(clusters);
      });
    });
  }

  Future<IEnumerable<Meme>> _mapMemesToFavorites(
          IEnumerable<MemeEntity> memes) async =>
      await _favoritesRepository.getMemeFavoritesAsync(memes).then(
          (userLikes) => memes.join(
              userLikes,
              (entity) => entity.id,
              (favorite) => (favorite as UserLikeEntity).id,
              (entity, favorite) => Meme.mapFromCopy(entity.type,
                  id: entity.id,
                  uri: entity.uri,
                  dateCreated: entity.dateCreated,
                  datePosted: entity.datePosted,
                  isLiked: (favorite as UserLikeEntity).isLiked,
                  author: entity.author)));
}
