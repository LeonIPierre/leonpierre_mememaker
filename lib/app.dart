import 'package:dev_libraries/blocs/ads/ads.dart';
import 'package:dev_libraries/blocs/configuration/configuration.dart';
import 'package:dev_libraries/blocs/navigation_cubit.dart';
import 'package:dev_libraries/repositories/assetbundlerepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:leonpierre_mememaker/views/appcontainer.dart';

import 'blocs/favorites/favoritesbloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (BuildContext context, ConfigurationState state) {
          if (state is ConfigurationUnitializedState || state is ConfigurationLoadingState)
            return Center(child: CircularProgressIndicator());
          else if (state is ConfigurationErrorState)
            return Center(child: Text(state.message));
          else if (state is ConfigurationInitializedState)
            return MultiBlocProvider(
                providers: [
                  BlocProvider<FavoritesBloc>(create: (BuildContext context)
                    => FavoritesBloc(FavoritesRepository())),
                  BlocProvider<AdBloc>(create: (BuildContext context) 
                    => AdBloc(state.configuration["googleAdMob:appId"],
                        configuration: state.configuration))
                ],
                child: MaterialApp(
                    title: state.configuration["title"],
                    theme: ThemeData(
                        backgroundColor: Colors.black,
                        primarySwatch: Colors.greenAccent[300]),
                    home: AppContainer(
                        BlocProvider.of<NavigationCubit>(context))));

          return Container();
        });
  }
}
