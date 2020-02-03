import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

    @override
  List<Object> get props => [];
}

class FavoritesEmptyState extends FavoritesState {}

class MemeClusterFavoritesLoadedState extends FavoritesState {
  final IEnumerable<UserLikeEntity> favorites;

  MemeClusterFavoritesLoadedState(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class MemeClusterAndMemesFavoritesLoadedState extends FavoritesState {
  final IEnumerable<MemeCluster> clusters;

  MemeClusterAndMemesFavoritesLoadedState(this.clusters);

  @override
  List<Object> get props => [clusters];
}

class FavoritesErrorState extends FavoritesState {}

class MemeClusterFavoritedStateChanged extends FavoritesState {
  final MemeCluster cluster;

  MemeClusterFavoritedStateChanged(this.cluster);

  @override
  List<Object> get props => [cluster];
}

class MemeFavoritedStateChanged extends FavoritesState {
  final Meme meme;
  MemeFavoritedStateChanged(this.meme);
  
  @override
  List<Object> get props => [meme];
}