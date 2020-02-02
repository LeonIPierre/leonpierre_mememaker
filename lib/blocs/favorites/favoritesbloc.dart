import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  @override
  FavoritesState get initialState => FavoritesLoadingState();

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}