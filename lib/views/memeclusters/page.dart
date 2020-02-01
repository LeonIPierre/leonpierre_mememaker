import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/states.dart';
import 'package:leonpierre_mememaker/views/memeclusters/views.dart';

class MemeClustersWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemeClusterWidgetState();
}

class _MemeClusterWidgetState extends State<MemeClustersWidget> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MemeClusterBloc, MemeClusterState>(
        builder: (BuildContext context, MemeClusterState state) {
          if (state is MemeClusterEmptyState)
            return MemesGroupedEmptyViewComponent();
          else if (state is MemeClusterErrorState)
            return MemesGroupedErrorViewComponent(id: state.message);
          else if (state is MemeClusterIdealState)
            return MemesGroupedViewComponent(clusters: state.clusters);
          else if (state is MemeClusterLoadingState)
            return MemesGroupedViewLoadingComponent();

          return null;
        },
      );
}