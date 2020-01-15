import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/services/clusteredmemeservice.dart';

class ClusteredMemesBloc extends Bloc<MemeClusterEvent, MemeClusterState> {
  final ClusteredMemeService service = ClusteredMemeService();

  @override
  MemeClusterState get initialState => MemeClusterLoadingState();

  @override
  Stream<MemeClusterState> mapEventToState(MemeClusterEvent event) async* {
    final currentState = state;

    try {
      switch (event) {
        case MemeClusterEvent.Loading:
          yield MemeClusterLoadingState();
          return;
        case MemeClusterEvent.NewestMemes:
          var clusters = await service.byNewestAsync();

          if (currentState is MemeClusterIdealState)
            clusters = clusters.concat(currentState.clusters);

          yield clusters.any()
              ? MemeClusterIdealState(clusters)
              : MemeClusterEmptyState();
          return;
        case MemeClusterEvent.DateRange:
          final clusters =
              await service.byDateRangeAsync(DateTime.now(), DateTime.now());

          yield clusters.any()
              ? MemeClusterIdealState(clusters)
              : MemeClusterEmptyState();
          return;
        case MemeClusterEvent.Empty:
          yield MemeClusterEmptyState();
          return;
        default:
          yield state;
      }
    } catch (error) {
      yield MemeClusterErrorState("Failed to load state $currentState");
    }
  }
}
