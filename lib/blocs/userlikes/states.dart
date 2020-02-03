import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

abstract class UserLikeState extends Equatable {
  const UserLikeState();

    @override
  List<Object> get props => [];
}

class UserLikesEmptyState extends UserLikeState {}

class UserLikesMemeClusterLoadedState extends UserLikeState {
  final IEnumerable<UserLikeEntity> likes;

  UserLikesMemeClusterLoadedState(this.likes);

  @override
  List<Object> get props => [likes];
}

class UserLikesMemeClusterAndMemesLoadedState extends UserLikeState {
  final IEnumerable<MemeCluster> clusters;

  UserLikesMemeClusterAndMemesLoadedState(this.clusters);

  @override
  List<Object> get props => [clusters];
}

class UserLikesErrorState extends UserLikeState {}

class MemeClusterLikeStateChanged extends UserLikeState {
  final MemeCluster cluster;

  MemeClusterLikeStateChanged(this.cluster);

  @override
  List<Object> get props => [cluster];
}

class MemeLikeStateChanged extends UserLikeState {
  final Meme meme;
  MemeLikeStateChanged(this.meme);
  
  @override
  List<Object> get props => [meme];
}