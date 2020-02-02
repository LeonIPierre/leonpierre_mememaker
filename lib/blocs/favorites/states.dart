import 'package:equatable/equatable.dart';

abstract class State extends Equatable {
  const State();
}

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesIdealState extends FavoritesState {

}

class FavoritesLoadingState extends FavoritesState {}