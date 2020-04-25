import 'package:bloc/bloc.dart';

class AppBloc extends Bloc<AppIntializedEvent, AppState> {
  Map<String, dynamic> configuration = Map<String, dynamic>();

  @override
  get initialState => AppUnitializedState();

  @override
  Stream<AppState> mapEventToState(AppIntializedEvent event) async* {
    configuration.putIfAbsent('system:title', () => "Test");
    configuration.putIfAbsent("androidApiKey", () => "android_ZDRkYjk5ZjYtOGJjYy00ZGM1LWFmY2UtYTAwOWY1NzMzZTA2");
    configuration.putIfAbsent("iosApiKey", () => "ios_NWYwZjQyOTQtNWYxMi00ZjQyLTk2ODctODMzNzY4Y2M5YzM1");
    configuration.putIfAbsent("appId", () => "ca-app-pub-9962567440326517~4869787060");

    configuration.putIfAbsent("adUnitId", () => "ca-app-pub-3940256099942544/6300978111");
    //configuration.putIfAbsent("adUnitId", () => "ca-app-pub-3940256099942544/4411468910");

    yield AppInitializedState();
  }
}

class AppState {}

class AppUnitializedState extends AppState{}

class AppInitializedState extends AppState {}

class AppIntializedEvent {}