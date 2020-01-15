import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:queries/collections.dart';

abstract class MemeClusterState extends Equatable {
  const MemeClusterState();

  @override
  List<Object> get props => [];
}

class MemeClusterEmptyState extends MemeClusterState {}

class MemeClusterIdealState extends MemeClusterState {
  final IEnumerable<MemeCluster> clusters;

  const MemeClusterIdealState(this.clusters);
}

class MemeClusterErrorState extends MemeClusterState {
  final String message;

  const MemeClusterErrorState(this.message);
}

class MemeClusterLoadingState extends MemeClusterState {}
