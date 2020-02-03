import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:queries/collections.dart';

enum MemeClusterEventId {
  //Ideal
  MemeClustersLoaded,

  //Loading
  LoadMemeClusters,

  //Empty
  NoMemeClustersFound,

  //Error
  Error,

  //Partial
  NoNewMemeClustersFound,
  NewMemeAddedToCluster,
  MemeClustersFilteredByDateRange,
  MemeClustersFilteredByPopularity,
  MemeClusterLikeAdded,
  MemeClusterLikeRemoved
}

class MemeClusterEvent {
  final MemeClusterEventId id;
  MemeClusterEvent(this.id);
}

class MemeClustersLoadedEvent extends MemeClusterEvent {
  IEnumerable<MemeCluster> clusters;

  MemeClustersLoadedEvent(this.clusters) : super(MemeClusterEventId.MemeClustersLoaded);
}

class MemeClusterStateChangeEvent extends MemeClusterEvent {
  final MemeCluster cluster;
  MemeClusterStateChangeEvent(MemeClusterEventId id, this.cluster) : super(id);
}

class MemeClusterDateFilterEvent extends MemeClusterEvent {
  DateTime start;
  DateTime end;

  MemeClusterDateFilterEvent() : super(MemeClusterEventId.MemeClustersFilteredByDateRange); 
}