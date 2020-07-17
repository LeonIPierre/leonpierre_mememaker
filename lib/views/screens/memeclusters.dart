import 'package:dev_libraries/dev_libraries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/states.dart';
import 'package:leonpierre_mememaker/views/memeclusters/views.dart';

class MemeClustersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemeClusterWidgetState();
}

class _MemeClusterWidgetState extends State<MemeClustersPage> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MemeClusterBloc, MemeClusterState>(
        builder: (BuildContext context, MemeClusterState state) {
            
          if (state is MemeClusterEmptyState)
            return MemeClustersEmptyWidget();
          else if (state is MemeClusterErrorState)
            return MemeClustersErrorWidget(id: state.message);
          else if (state is MemeClusterIdealState)
            return MemeClustersWidget(BlocProvider.of<MemeClusterBloc>(context), 
              BlocProvider.of<FavoritesBloc>(context), BlocProvider.of<AdBloc>(context));
          else if (state is MemeClusterLoadingState)
            return MemeClustersLoadingWidget();

          return null;
        },
      );
}