import 'package:dev_libraries/bloc/adbloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/appbloc.dart';
import 'package:leonpierre_mememaker/blocs/navigation.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:leonpierre_mememaker/views/appcontainer.dart';

import 'blocs/favorites/favoritesbloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesBloc>(create: (BuildContext context) => FavoritesBloc(FavoritesRepository())),
        BlocProvider<AdBloc>(create: (BuildContext context) {
          var configuration = BlocProvider.of<AppBloc>(context).configuration;
          return AdBloc(configuration["googleAdMob:appId"]);
        })
      ],
      child: BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        if(state is AppUnitializedState)
          return CircularProgressIndicator();
        else if(state is AppInitializedState)
          return MaterialApp(
            title: BlocProvider.of<AppBloc>(context).configuration["title"],
            theme: ThemeData(backgroundColor: Colors.black,
            primarySwatch: Colors.greenAccent[300]),
            home: AppContainer(NavigationBloc()..toPage(0))
            );

        return Container();
      }));
  }
}