enum NavigationItem { HOME, FAVORITES, SEARCH, LOADING }

class NavigationItemModel {

  static NavigationItemModel home = NavigationItemModel(0, NavigationItem.HOME);
  static NavigationItemModel favorites = NavigationItemModel(1, NavigationItem.FAVORITES);
  static NavigationItemModel search = NavigationItemModel(2, NavigationItem.SEARCH);

  int _index;
  int get index => _index;

  NavigationItem _item;
  NavigationItem get item => _item;

  NavigationItemModel(this._index, this._item);
}