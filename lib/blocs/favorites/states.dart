import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:queries/collections.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesEmptyState extends FavoritesState {}

class FavoritesErrorState extends FavoritesState {}

class FavoritedContentLoadedState<T extends ContentBase> extends FavoritesState {
  final IEnumerable<T> items;
  final bool hasReachedMax;

  FavoritedContentLoadedState(this.items, {this.hasReachedMax});
}

class FavoritedContentLoadedByDateRangeState<T extends ContentBase> extends FavoritedContentLoadedState<T> {
  final DateTime start;
  final DateTime end;

  FavoritedContentLoadedByDateRangeState(IEnumerable<T> items, this.start, this.end, {bool hasReachedMax}) : super(items, hasReachedMax: hasReachedMax);
}

class FavoritedContentChangedState<T extends ContentBase> extends FavoritesState {
  final T content;

  FavoritedContentChangedState(this.content);
}