import 'package:flutter_test/flutter_test.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';

void main() {
    group('MemeClusterBloc', () {
      MemeClusterBloc clusterBloc;
      FavoritesBloc favoritesBloc;

      MemeClusterRepository clusterRepository;

      setUp(() {
        
        clusterBloc = MemeClusterBloc(clusterRepository, favoritesBloc);
      });
    });
}