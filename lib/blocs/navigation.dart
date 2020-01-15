import 'package:leonpierre_mememaker/models/navigationItem.dart';
import 'package:rxdart/rxdart.dart';

class NavigationBloc {
  final BehaviorSubject<NavigationItemModel> navigation = BehaviorSubject<NavigationItemModel>
    .seeded(NavigationItemModel.home);
  
  Stream<NavigationItemModel> get pages => navigation.stream;

  void toPage(int index) {
    switch(index)
    {
      case 0:
        navigation.sink.add(NavigationItemModel.home);
        break;
      case 1:
        navigation.sink.add(NavigationItemModel.favorites);
        break;
      case 2:
        navigation.sink.add(NavigationItemModel.search);
        break;
    }
  }

  void dispose() {
    navigation?.close();
  }
}