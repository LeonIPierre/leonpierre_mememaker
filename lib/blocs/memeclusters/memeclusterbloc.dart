import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';
import 'package:leonpierre_mememaker/repositories/userlikesrepository.dart';
import 'package:queries/collections.dart';

class MemeClusterBloc extends Bloc<MemeClusterEvent, MemeClusterState> {
  final MemeClusterRepository _clusterRepository;
  final UserLikesRepository _userLikesRepository;
  StreamSubscription _clustersStream;

  MemeClusterBloc(this._clusterRepository, this._userLikesRepository);

  @override
  MemeClusterState get initialState => MemeClusterLoadingState();

  @override
  Stream<MemeClusterState> mapEventToState(MemeClusterEvent event) async* {
    switch (event.id) {
      case MemeClusterEventId.LoadMemeClusters:
        yield* _mapMemeClustersToLikes(_clusterRepository.byNewestAsync());
        return;
      case MemeClusterEventId.MemeClustersLoaded:
        var clusters = (event as MemeClustersLoadedEvent).clusters;

        //if already in the ideal state add to the current list if not create a new one

        yield clusters != null && clusters.any()
            ? MemeClusterIdealState(clusters)
            : MemeClusterEmptyState();
        return;
      case MemeClusterEventId.NewMemeAddedToCluster:
        //TODO when a new meme is added an your in the ideal state that cluster needs to be udpated
        if (state is MemeClusterIdealState) yield state;

        return;
      case MemeClusterEventId.NoMemeClustersFound:
        yield MemeClusterEmptyState();
        return;
      case MemeClusterEventId.Error:
        yield MemeClusterErrorState("Failed to load state $state");
        return;
      default:
        yield state;
    }
  }

  Stream<MemeClusterState> _mapMemeClustersToLikes(
      Future<IEnumerable<MemeClusterEntity>> clusterRepository) async* {

    var results = clusterRepository.then((clusterEntities) async {
      IEnumerable<UserLikeEntity> userClusterLikes =
          await _userLikesRepository.getUserClusterLikesAsync(clusterEntities);

      return clusterEntities.join(
          userClusterLikes,
          (c) => c.id,
          (l) => (l as UserLikeEntity).id,
          (entity, like) => {"entity": entity, "like": like as UserLikeEntity});
    }).then((mappedClusters) {
      var clusters = List<MemeCluster>();

      //TODO run 1 query for all memes then map them back to the clusters
      //https://stackoverflow.com/questions/56600754/whencomplete-method-not-working-as-expected-flutter-async
      mappedClusters.toList().forEach((mappedCluster) async {
        var entity = mappedCluster["entity"] as MemeClusterEntity;
        var like = mappedCluster["like"] as UserLikeEntity;

        await _mapMemesToLikes(entity.memes).then((memes) => MemeCluster(entity.id,
              memes: memes,
              description: entity.description,
              isLiked: like.isLiked)
        ).then((cluster) => clusters.add(cluster));
      });

      return Collection(clusters);
    }).catchError((error) {
      add(MemeClusterEvent(MemeClusterEventId.Error));
    });

    _clustersStream?.cancel();
    _clustersStream = Stream.fromFuture(results)
        .listen((clusters) => add(MemeClustersLoadedEvent(clusters)));
  }

  Future<IEnumerable<Meme>> _mapMemesToLikes(
          IEnumerable<MemeEntity> memes) async =>
      await _userLikesRepository
          .getUserMemeLikesAsync(memes)
          .then((userLikes) => memes.join(
              userLikes,
              (entity) => entity.id,
              (like) => (like as UserLikeEntity).id,
              (entity, like) => Meme.mapFromCopy(entity.type,
                  id: entity.id,
                  uri: entity.uri,
                  dateCreated: entity.dateCreated,
                  datePosted: entity.datePosted,
                  isLiked: (like as UserLikeEntity).isLiked,
                  author: entity.author)))
          .catchError((error) {
        add(MemeClusterEvent(MemeClusterEventId.Error));
      });

  @override
  Future<void> close() {
    _clustersStream?.cancel();
    return super.close();
  }
}
