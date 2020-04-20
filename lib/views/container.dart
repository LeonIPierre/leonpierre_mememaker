import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/components/share/sharebloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/blocs/navigation.dart';
import 'package:leonpierre_mememaker/models/navigationItem.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';
import 'package:leonpierre_mememaker/views/screens/memeclusters.dart';

import 'screens/favorites.dart';

class ScreensContainer extends StatefulWidget {
  final NavigationBloc navigationBloc;

  ScreensContainer(this.navigationBloc);

  createState() => _ScreensContainerState();
}

class _ScreensContainerState extends State<ScreensContainer> {
  final _favoritesBloc = FavoritesBloc(FavoritesRepository());
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: BlocProvider.value(
        value: _favoritesBloc,
        child: StreamBuilder(
            stream: widget.navigationBloc.pages,
            initialData: widget.navigationBloc.navigation.value,
            builder: (BuildContext context, AsyncSnapshot<NavigationItemModel> snapshot) {
              switch (snapshot.data.item) {
                case NavigationItem.HOME:
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<MemeClusterBloc>(
                        create: (BuildContext context) => MemeClusterBloc(
                          MemeClusterRepository(), _favoritesBloc)
                          ..add(MemeClusterEvent(MemeClusterEventId.LoadMemeClusters))
                      ),
                      BlocProvider<ShareBloc>(create: (BuildContext context) => ShareBloc())
                    ],

                    child: MemeClustersPage()
                  );
                case NavigationItem.FAVORITES:
                  return BlocProvider.value(
                      value: _favoritesBloc..add(FavoritesLoadEvent(FavoritesEventId.FavoritesUnitialized)),
                      child: FavoritesPage());
                case NavigationItem.SEARCH:
                default:
                  return null;
              }
            }),
      ),

      //TODO implement this animation https://pub.dev/packages/curved_navigation_bar
      bottomNavigationBar: StreamBuilder(builder:
          (BuildContext context, AsyncSnapshot<NavigationItem> snapshot) {
        return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.flare),
                title: Text('Home/What' 's hot'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                title: Text('Favorites'),
              ),
            ],
            currentIndex: widget.navigationBloc.navigation.value.index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              widget.navigationBloc.toPage(index);
              //notify ui of state change
              setState(() {});
            });
      }));

  @override
  void dispose() {
    _favoritesBloc.close();
    super.dispose();
  }
}
