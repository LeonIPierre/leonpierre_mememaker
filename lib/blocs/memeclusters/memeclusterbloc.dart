import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';

class MemeClusterBloc extends Bloc<MemeClusterEvent, MemeClusterState> {
  final MemeClusterRepository _clusterRepository;
  StreamSubscription _clustersStream;
  StreamSubscription _favoritesStream;
  FavoritesBloc _favoritesBloc;

  MemeClusterBloc(this._clusterRepository, this._favoritesBloc) {
    _favoritesStream = _favoritesBloc.listen((state) {
      if (state is MemeClusterAndMemesFavoritesLoadedState) {
        add(MemeClustersLoadedEvent(state.clusters));
      }
    });
  }

  @override
  MemeClusterState get initialState => MemeClusterLoadingState();

  @override
  Stream<MemeClusterState> mapEventToState(MemeClusterEvent event) async* {
    switch (event.id) {
      case MemeClusterEventId.LoadMemeClusters:
        _favoritesBloc.add(MemeClusterFavoritesLoad(
            FavoritesEventId.LoadFavoritedClustersAndMemes,
            await _clusterRepository.byNewestAsync()));
        break;
      case MemeClusterEventId.MemeClustersLoaded:
        var clusters = (event as MemeClustersLoadedEvent).clusters;

        //if already in the ideal state add to the current list if not create a new one

        yield clusters != null && clusters.any()
            ? MemeClusterIdealState(clusters)
            : MemeClusterEmptyState();
        break;
      case MemeClusterEventId.NewMemeAddedToCluster:
        //TODO when a new meme is added an your in the ideal state that cluster needs to be udpated
        //if (state is MemeClusterIdealState) yield state;

        break;
      case MemeClusterEventId.NoMemeClustersFound:
        yield MemeClusterEmptyState();
        break;
      case MemeClusterEventId.Error:
        yield MemeClusterErrorState("Failed to load state $state");
        break;
      default:
        yield state;
    }
  }

  @override
  Future<void> close() {
    _clustersStream?.cancel();
    _favoritesStream?.cancel();
    return super.close();
  }
}
