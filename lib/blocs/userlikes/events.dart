import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

enum UserLikesEventId {
  LoadClusterAndMemeLikes,

  MemeClusterLikesLoaded,
  LoadMemeClusterLikes,

  MemeLikesLoaded,
  LoadMemeLikes,

  MemeClusterLikeAdded,
  MemeClusterLikeRemoved,

  MemeLikeAdded,
  MemeLikeRemoved
}

abstract class UserLikeEvent extends Equatable {
  final UserLikesEventId id;
  const UserLikeEvent(this.id);
}

class UserLikesLoaded extends UserLikeEvent {
  final IEnumerable<UserLikeEntity> userLikes;

  UserLikesLoaded(UserLikesEventId id, this.userLikes) : super(id);

  @override
  List<Object> get props => [id, userLikes];
}

class UserLikesMemeClusterLoad extends UserLikeEvent {
  final IEnumerable<MemeClusterEntity> clusters;

  UserLikesMemeClusterLoad(UserLikesEventId id, this.clusters) : super(id);

  @override
  List<Object> get props => [clusters];
}

class UserLikesMemesLoad extends UserLikeEvent {
  final IEnumerable<MemeEntity> memes;

  UserLikesMemesLoad(this.memes) : super(UserLikesEventId.LoadMemeLikes);

  @override
  List<Object> get props => [memes];
}

class MemeClusterLikeStateChangedEvent extends UserLikeEvent {
  final MemeCluster cluster;

  MemeClusterLikeStateChangedEvent(UserLikesEventId id, this.cluster)
      : super(id);

  @override
  List<Object> get props => [cluster];
}