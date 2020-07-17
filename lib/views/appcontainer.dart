import 'package:dev_libraries/bloc/app/app.dart';
import 'package:dev_libraries/dev_libraries.dart';
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
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';
import 'package:leonpierre_mememaker/views/screens/memeclusters.dart';

import 'components/ads.dart';
import 'screens/favorites.dart';

class AppContainer extends StatefulWidget {
  final NavigationBloc _navigationBloc;

  AppContainer(this._navigationBloc);

  createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  FavoritesBloc _favoritesBloc;
  AdBloc _adBloc;

  @override
  Widget build(BuildContext context) {
    _favoritesBloc = BlocProvider.of<FavoritesBloc>(context);
    _adBloc = BlocProvider.of<AdBloc>(context);
    var configuration = BlocProvider.of<AppBloc>(context).configuration;
    configuration["ad:width"] = MediaQuery.of(context).size.width.round();
    configuration["ad:height"] = (MediaQuery.of(context).size.height * .1).round();

   return Scaffold(
      appBar: AppBar(title: Text(configuration["title"])),
      body: StreamBuilder(
            stream: widget._navigationBloc.pages,
            initialData: widget._navigationBloc.navigation.value,
            builder: (BuildContext context, AsyncSnapshot<NavigationItemModel> snapshot) {
              return Column(
                children: <Widget>[
                   Expanded(child: _buildPage(snapshot.data.item), flex: 10),
                   Expanded(child: AdsWidget(_adBloc, configuration), flex: 1)
            ]);
        }),
      
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
            currentIndex: widget._navigationBloc.navigation.value.index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              widget._navigationBloc.toPage(index);
              //notify ui of state change
              setState(() {});
            });
      }));
  }
  
  Widget _buildPage(NavigationItem navigationItem) {
    switch (navigationItem) {
      case NavigationItem.HOME:
        return _buildHomePage();
      case NavigationItem.FAVORITES:
        return _buildFavoritesPage();
      case NavigationItem.SEARCH:
      default:
        return null;
    }
  }

  Widget _buildHomePage() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MemeClusterBloc>(
          create: (BuildContext context) => MemeClusterBloc(MemeClusterRepository(), _favoritesBloc)
          ..add(MemeClusterEvent(MemeClusterEventId.LoadMemeClusters))
          ),
          BlocProvider<ShareBloc>(create: (BuildContext context) => ShareBloc())
        ],
        child: MemeClustersPage()
      );
  }

  Widget _buildFavoritesPage() {
    return BlocProvider.value(
      value: _favoritesBloc..add(FavoritesLoadEvent(FavoritesEventId.FavoritesUnitialized)),
      child: FavoritesPage());
  }
}
