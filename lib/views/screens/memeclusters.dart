import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/states.dart';
import 'package:leonpierre_mememaker/views/memeclusters/views.dart';
//import 'package:dev_libraries/bloc/adbloc.dart';
//import 'package:dev_libraries/bloc/events.dart';
//import 'package:dev_libraries/services/ads/adservice.dart';
//import 'package:dev_libraries/services/ads/admobservice.dart';

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
          {
            //var adBloc = AdBloc(AdMobService(null));
            //adBloc.add(AdLoadEvent(AdType.Banner));
            return MemeClustersWidget();
          }
          else if (state is MemeClusterLoadingState)
            return MemeClustersLoadingWidget();

          return null;
        },
      );
}