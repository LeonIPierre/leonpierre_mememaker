import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/repositories/entities/memecluster.dart';
import 'package:leonpierre_mememaker/repositories/entities/userlike.dart';
import 'package:queries/collections.dart';

enum UserLikesEventId
{
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

  UserLikesMemeClusterLoad(this.clusters) : super(UserLikesEventId.LoadMemeClusterLikes);

  @override
  List<Object> get props => [clusters];

}