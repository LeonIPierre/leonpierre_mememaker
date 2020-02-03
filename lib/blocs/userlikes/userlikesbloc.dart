import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/userlikes/events.dart';
import 'package:leonpierre_mememaker/blocs/userlikes/states.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:leonpierre_mememaker/repositories/userlikesrepository.dart';
import 'package:queries/collections.dart';

class UserLikesBloc extends Bloc<UserLikeEvent, UserLikeState> {
  final UserLikesRepository _userLikesRepository;

  UserLikesBloc(this._userLikesRepository);

  @override
  UserLikeState get initialState => UserLikesEmptyState();

  @override
  Stream<UserLikeState> mapEventToState(UserLikeEvent event) async* {
    switch (event.id) {
      case UserLikesEventId.LoadClusterAndMemeLikes:
        var entities = (event as UserLikesMemeClusterLoad).clusters;
        var clusters = await _mapMemeClustersToLikes(entities);
         yield clusters != null && clusters.any()
            ? UserLikesMemeClusterAndMemesLoadedState(clusters)
            : UserLikesEmptyState();
        break;
      case UserLikesEventId.LoadMemeClusterLikes:
        var entities = (event as UserLikesMemeClusterLoad).clusters;
        var likes =
            await _userLikesRepository.getUserClusterLikesAsync(entities);

        yield likes != null && likes.any()
            ? UserLikesMemeClusterLoadedState(likes)
            : UserLikesEmptyState();
        break;
      case UserLikesEventId.MemeClusterLikeAdded:
        var cluster = (event as MemeClusterLikeStateChangedEvent).cluster;
        var success =
            await _userLikesRepository.likeCluster(cluster, DateTime.now());

        yield success
            ? MemeClusterLikeStateChanged(cluster)
            : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeClusterLikeRemoved:
        var cluster = (event as MemeClusterLikeStateChangedEvent).cluster;
        var success = await _userLikesRepository.removeClusterLike(
            cluster, DateTime.now());

        yield success
            ? MemeClusterLikeStateChanged(cluster)
            : UserLikesErrorState();
        break;
      case UserLikesEventId.LoadMemeLikes:
        var memes = (event as UserLikesMemesLoad).memes;
        var likes = await _userLikesRepository.getUserMemeLikesAsync(memes);

        yield likes != null && likes.any()
            ? UserLikesLoaded(UserLikesEventId.MemeLikesLoaded, likes)
            : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeLikeAdded:
        var meme = (event as MemeLikeStateChanged).meme;
        var success = await _userLikesRepository.likeMeme(meme, DateTime.now());

        yield success ? MemeLikeStateChanged(meme) : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeLikeRemoved:
        var meme = (event as MemeLikeStateChanged).meme;
        var success =
            await _userLikesRepository.removeMemeLike(meme, DateTime.now());

        yield success ? MemeLikeStateChanged(meme) : UserLikesErrorState();
        break;
      default:
        yield state;
    }
  }

  Future<IEnumerable<MemeCluster>> _mapMemeClustersToLikes(
      IEnumerable<MemeClusterEntity> clusterEntities) async {
    return await _userLikesRepository
        .getUserClusterLikesAsync(clusterEntities)
        .then((userClusterLikes) {
      return clusterEntities.join(
          userClusterLikes,
          (entity) => entity.id,
          (like) => (like as UserLikeEntity).id,
          (entity, like) => {"entity": entity, "like": like as UserLikeEntity});
    }).then((mappedClusters) async {
      var clusters = List<MemeCluster>();
      final clusterFutures = <Future<void>>[];

      //TODO run 1 query for all memes then map them back to the clusters
      mappedClusters.toList().forEach((mappedCluster) {
        var entity = mappedCluster["entity"] as MemeClusterEntity;
        var like = mappedCluster["like"] as UserLikeEntity;

        clusterFutures.add(_mapMemesToLikes(entity.memes)
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

  Future<IEnumerable<Meme>> _mapMemesToLikes(
          IEnumerable<MemeEntity> memes) async =>
      await _userLikesRepository.getUserMemeLikesAsync(memes).then(
          (userLikes) => memes.join(
              userLikes,
              (entity) => entity.id,
              (like) => (like as UserLikeEntity).id,
              (entity, like) => Meme.mapFromCopy(entity.type,
                  id: entity.id,
                  uri: entity.uri,
                  dateCreated: entity.dateCreated,
                  datePosted: entity.datePosted,
                  isLiked: (like as UserLikeEntity).isLiked,
                  author: entity.author)));
}
