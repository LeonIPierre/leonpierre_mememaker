import 'package:bloc/bloc.dart';
import 'package:dev_libraries/bloc/blocmanager.dart';
import 'package:dev_libraries/services/logging/appspectorservice.dart';
import 'package:flat/flat.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class AppBloc extends Bloc<AppIntializedEvent, AppState> {
  Map<String, dynamic> configuration = Map<String, dynamic>();
  @override
  get initialState => AppUnitializedState();

  @override
  Stream<AppState> mapEventToState(AppIntializedEvent event) async* {
    //yield a loading state i.e a splash screen?
    yield await rootBundle.loadString("assets/config.json")
      .then((content) {
        configuration = flatten(json.decode(content), delimiter: ":");
        BlocSupervisor.delegate = BlocManager(loggingService: 
          AppSpectorService(androidKey: configuration["appSpector:androidApiKey"]));
        return AppInitializedState();
      });
  }
}

class AppState {}

class AppUnitializedState extends AppState{}

class AppInitializedState extends AppState {

  AppInitializedState();
}

class AppIntializedEvent {}