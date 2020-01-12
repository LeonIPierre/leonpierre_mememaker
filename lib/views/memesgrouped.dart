import 'package:flutter/material.dart';
import 'package:leonpierre_mememaker/models/memeclustermodel.dart';


import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/empty.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/error.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/ideal.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/loading.dart';
import 'package:leonpierre_mememaker/viewmodels/clusteredmemesviewmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';
import 'package:queries/collections.dart';

class MemesGroupedView extends StatelessWidget {
  MemesGroupedView({Key key}) : super(key: key) {
    
  }

  @override
  Widget build(BuildContext context) {
    ClusteredMemesViewModel viewModel =
        ViewModelProvider.of<ClusteredMemesViewModel>(context);
    viewModel.getClusters(DateTime.now(), DateTime.now());

    return StreamBuilder(
        stream: viewModel.clusters,
        builder:
            (BuildContext context, AsyncSnapshot<List<MemeCluster>> snapshot) {
          if (snapshot.hasError) return MemesGroupedErrorViewComponent();

          if (snapshot.hasData)
            return snapshot.data.length == 0
                ? MemesGroupedEmptyViewComponent()
                : MemesGroupedViewComponent(
                    clusters: Collection(snapshot.data));

          return MemesGroupedViewLoadingComponent();
        });
  }
}
