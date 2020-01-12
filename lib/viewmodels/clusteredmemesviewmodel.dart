import 'dart:collection';

import 'package:leonpierre_mememaker/models/memeclustermodel.dart';
import 'package:leonpierre_mememaker/services/clusteredmemeservice.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';
import 'package:rxdart/rxdart.dart';

class ClusteredMemesViewModel extends ViewModelBase {
  PublishSubject<List<MemeCluster>> _clustersSubject = PublishSubject<List<MemeCluster>>();
  Stream<List<MemeCluster>> get clusters => _clustersSubject.stream;

  final ClusteredMemeService service = ClusteredMemeService();

  List<MemeCluster> _allClusters = List<MemeCluster>();

  void getCluster(String clusterId) async {
    _onMemesAdded(List.unmodifiable([await service.byId(clusterId)]));
  }

  void getClusters(DateTime start, DateTime end) async {
    var results = await service.byDateRange(start, end);
    _onMemesAdded(List.unmodifiable(results.toList()));
  }

  void _onMemesAdded(List<MemeCluster> memes) {
    _allClusters.addAll(memes);
    _clustersSubject.sink.add(UnmodifiableListView<MemeCluster>(_allClusters));
  }

  void dispose() {
    _clustersSubject.close();
  }
}