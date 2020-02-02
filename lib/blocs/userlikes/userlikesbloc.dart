import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/userlikes/events.dart';
import 'package:leonpierre_mememaker/blocs/userlikes/states.dart';
import 'package:leonpierre_mememaker/repositories/userlikesrepository.dart';

class UserLikesBloc extends Bloc<UserLikeEvent, UserLikeState> {
  final UserLikesRepository _userLikesRepository;

  UserLikesBloc(this._userLikesRepository);

  @override
  UserLikeState get initialState => UserLikesEmptyState();

  @override
  Stream<UserLikeState> mapEventToState(UserLikeEvent event) async* {
    switch (event.id) {
      case UserLikesEventId.LoadMemeClusterLikes:
        var clusters = (event as UserLikesMemeClusterLoad).clusters;
        var likes = await _userLikesRepository.getUserClusterLikesAsync(clusters);

        yield likes != null && likes.any()
          ? UserLikesMemeClusterLoadedState(likes) : UserLikesEmptyState();
        break;
      case UserLikesEventId.MemeClusterLikeAdded:
        var cluster = (event as MemeClusterLikeStateChanged).cluster;
        var success = await _userLikesRepository.likeCluster(cluster, DateTime.now());
        
        yield success ? MemeClusterLikeStateChanged(cluster) : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeClusterLikeRemoved:
        var cluster = (event as MemeClusterLikeStateChanged).cluster;
        var success = await _userLikesRepository.removeClusterLike(cluster, DateTime.now());

        yield success ? MemeClusterLikeStateChanged(cluster) : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeLikeAdded:
        var meme = (event as MemeLikeStateChanged).meme;
        var success = await _userLikesRepository.likeMeme(meme, DateTime.now());

        yield success ? MemeLikeStateChanged(meme) : UserLikesErrorState();
        break;
      case UserLikesEventId.MemeLikeRemoved:
        var meme = (event as MemeLikeStateChanged).meme;
        var success = await _userLikesRepository.removeMemeLike(meme, DateTime.now());

        yield success ? MemeLikeStateChanged(meme) : UserLikesErrorState();
        break;
      default:
        yield state;
    }
  }
}
