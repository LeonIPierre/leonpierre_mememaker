import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';

class MemeClusterBloc extends Bloc<MemeClusterEvent, MemeClusterState> {
  BehaviorSubject<IEnumerable<MemeCluster>> clusters = BehaviorSubject<IEnumerable<MemeCluster>>();

  final MemeClusterRepository _clusterRepository;
  final FavoritesBloc _favoritesBloc;
  StreamSubscription _favoritesStream;
  
  MemeClusterBloc(this._clusterRepository, this._favoritesBloc) {
    initialize();
  }

  @override
  MemeClusterState get initialState => MemeClusterLoadingState();

  @override
  Stream<MemeClusterState> mapEventToState(MemeClusterEvent event) async* {
    switch (event.id) {
      case MemeClusterEventId.LoadMemeClusters:
        
        var entities = await _clusterRepository.byNewestAsync();
        var clusters = entities.select((x) => MemeCluster.fromEntity(x));
        _favoritesBloc.add(FavoritesByContentLoadEvent(FavoritesEventId.LoadFavoritedMemeClusters, clusters));
        break;
      case MemeClusterEventId.MemeClustersLoaded:
        var clusters = (event as MemeClustersLoadedEvent).clusters;

        if(clusters.any()) {
          this.clusters.sink.add(clusters);
          yield MemeClusterIdealState(clusters: clusters); 
        } else {
          yield MemeClusterEmptyState();
        }
        break;
      // case MemeClusterEventId.NewMemeAddedToCluster:
      //   //TODO when a new meme is added in the ideal state that cluster needs to be updated (if any)
      //   yield state;
      //   break;
      // case MemeClusterEventId.NoMemeClustersFound:
      //   yield state;
      //   break;
      case MemeClusterEventId.AddMemeClusterLike:
        if(state is MemeClusterIdealState) {
          var cluster = (event as MemeClusterStateChangeEvent).cluster;
          _favoritesBloc.add(FavoriteStateChangedEvent(FavoritesEventId.MemeClusterAdded, cluster));
        }
        break;
      case MemeClusterEventId.RemoveMemeClusterLike:
        if(state is MemeClusterIdealState) {
          var cluster = (event as MemeClusterStateChangeEvent).cluster;
          _favoritesBloc.add(FavoriteStateChangedEvent(FavoritesEventId.MemeClusterRemoved, cluster));
        }
        break;
      case MemeClusterEventId.Error:
        yield MemeClusterErrorState("Failed to load state $state");
        break;
      default:
        yield state;
    }
  }

  void initialize() {
    _favoritesStream = _favoritesBloc.listen((state) {
      if (state is FavoritedContentLoadedState<MemeCluster>) {
        add(MemeClustersLoadedEvent(state.items));
      }
      else if(this.state is MemeClusterIdealState && state is FavoritedContentChangedState<MemeCluster>) {
        var currentClusters = (this.state as MemeClusterIdealState).clusters;
        var test = currentClusters.select((x) => x == state.content ? state.content : x);
        add(MemeClustersLoadedEvent(test));
      }
    });
  }

  @override
  Future<void> close() {
    clusters?.close();
    _favoritesStream?.cancel();
    return super.close();
  }
}
