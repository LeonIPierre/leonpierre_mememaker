import 'package:bloc/bloc.dart';
import 'package:flat/flat.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AppBloc extends Bloc<AppIntializedEvent, AppState> {
  Map<String, dynamic> configuration = Map<String, dynamic>();

  @override
  get initialState => AppUnitializedState();

  @override
  Stream<AppState> mapEventToState(AppIntializedEvent event) async* {
    String content = await rootBundle.loadString("assets/config.json");
    configuration = flatten(json.decode(content), delimiter: ":");

    yield AppInitializedState();
  }
}

class AppState {}

class AppUnitializedState extends AppState{}

class AppInitializedState extends AppState {}

class AppIntializedEvent {}