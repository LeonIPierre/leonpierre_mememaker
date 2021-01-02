import 'package:dev_libraries/blocs/ads/adbloc.dart';
import 'package:dev_libraries/blocs/authentication/authenticationbloc.dart';
import 'package:dev_libraries/blocs/configuration/configuration.dart';
import 'package:dev_libraries/blocs/navigation_cubit.dart';
import 'package:dev_libraries/dev_libraries.dart';
import 'package:dev_libraries/repositories/sharedpreferencesrepository.dart';
import 'package:dev_libraries/services/logging/appspectorservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:leonpierre_mememaker/views/appcontainer.dart';

import 'blocs/favorites/favoritesbloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigurationBloc, ConfigurationState>(
        listener: (BuildContext context, ConfigurationState state) {
      if (state is ConfigurationInitializedState) {
        var loggingService;

        if (state.configuration["appSpector:androidApiKey"] != null)
          loggingService = AppSpectorService(
              androidKey: state.configuration["appSpector:androidApiKey"]);

        Bloc.observer = Bloc.observer ??
            DefaultBlocObserver(loggingService: loggingService);
      }
    }, child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
            builder: (BuildContext context, ConfigurationState state) {
      if (state is ConfigurationUnitializedState ||
          state is ConfigurationLoadingState)
        return Center(child: CircularProgressIndicator());
      else if (state is ConfigurationErrorState)
        return Center(child: Text(state.message));
      else if (state is ConfigurationInitializedState) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<FavoritesBloc>(
                  create: (BuildContext context) =>
                      FavoritesBloc(FavoritesRepository())),
              BlocProvider<AdBloc>(
                  create: (BuildContext context) => AdBloc(
                      state.configuration["googleAdMob:appId"],
                      configuration: state.configuration))
            ],
            child: MaterialApp(
                title: state.configuration["title"],
                theme: ThemeData(
                    backgroundColor: Colors.black,
                    primarySwatch: Colors.greenAccent[300]),
                home: AppContainer(BlocProvider.of<NavigationCubit>(context))));
      }

      return Container();
    }));
  }

  _initializeUser(ConfigurationBloc configurationBloc, AuthenticationBloc authenticationBloc) {
    //check the internal storage for first time flag
    var isFirstTime = false;
    //storage.userAccessToken 

    //if so sign them in anonomously (create)
    if(isFirstTime) {
      authenticationBloc.add(CreateNewUserEvent());
      configurationBloc.add(ConfigurationChangedEvent(SharedPreferencesRepository, "userId", ""));
      //show onboarding...?
    }
  }
}
