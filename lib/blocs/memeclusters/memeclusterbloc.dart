import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/memeclustersservice.dart';

class MemeClusterBloc extends Bloc<MemeClusterEvent, MemeClusterState> {

  final MemeClustersService _clusterService;
  final FavoritesBloc _favoritesBloc;
  StreamSubscription _favoritesStream;
  
  MemeClusterBloc(this._clusterService, this._favoritesBloc) : super(MemeClusterLoadingState()) {
    _initialize();
  }

  @override
  Stream<MemeClusterState> mapEventToState(MemeClusterEvent event) async* {
    switch (event.id) {
      case MemeClusterEventId.LoadMemeClusters:
        yield* _mapMemeClusterLoadedState();
        break;
      case MemeClusterEventId.MemeClustersLoaded:
        var clusters = (event as MemeClustersLoadedEvent).clusters;

        yield clusters.any() 
          ? MemeClusterIdealState(clusters: clusters) : MemeClusterEmptyState();
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
        throw Exception("Cannot handle event ${event.id}");
    }
  }

  @override
  Future<void> close() {
    _favoritesStream?.cancel();
    return super.close();
  }

  void _initialize() {
    _favoritesStream = _favoritesBloc.listen((favState) {
      if (favState is FavoritedContentRequestedState<MemeCluster>) {
        add(MemeClustersLoadedEvent(favState.items));
      }
      else if(favState is FavoritedContentChangedState<MemeCluster> && this.state is MemeClusterIdealState) {
        var currentClusters = (this.state as MemeClusterIdealState).clusters;
        add(MemeClustersLoadedEvent(currentClusters.select((x) => x.id == favState.content.id ? favState.content : x)));
      }
      else if(favState is FavoritedContentChangedState<Meme> &&  this.state is MemeClusterIdealState) {
        var currentClusters = (this.state as MemeClusterIdealState).clusters;
        var updatedClusters = currentClusters.select((cluster) =>
          cluster.clone(memes: cluster.memes.select((x) => x.id == favState.content.id ? favState.content : x)));
          
        add(MemeClustersLoadedEvent(updatedClusters));
      }
    });
  }

  Stream<MemeClusterState> _mapMemeClusterLoadedState() async* {
    yield await _clusterService.byNewestAsync().then((entities) {
      var clusters = entities.select((x) => MemeCluster.fromEntity(x));
      _favoritesBloc.add(FavoritesByContentLoadEvent(FavoritesEventId.LoadFavoritedMemeClusters, clusters));
      return state;
    }).catchError((ex) {
      return MemeClusterErrorState(ex.toString());
    });
  }
}
