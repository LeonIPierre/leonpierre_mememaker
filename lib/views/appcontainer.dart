import 'package:dev_libraries/dev_libraries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/appbloc.dart';
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
  final NavigationBloc navigationBloc;
  final AppBloc _appBloc;
  final FavoritesBloc _favoritesBloc;
  final AdBloc _adBloc;

  AppContainer(this.navigationBloc, this._appBloc, this._favoritesBloc, this._adBloc);

  createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text(widget._appBloc.configuration["system:title"])),
      body: BlocProvider.value(
        value: widget._favoritesBloc,
        child: StreamBuilder(
            stream: widget.navigationBloc.pages,
            initialData: widget.navigationBloc.navigation.value,
            builder: (BuildContext context, AsyncSnapshot<NavigationItemModel> snapshot) {
              return Column(
                children: <Widget>[
                   Expanded(child: _buildPage(snapshot.data.item), flex: 10),
                   Expanded(flex: 1,
                     child: AdsWidget(widget._adBloc, widget._appBloc),
                    ),
                ],
              );
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
          create: (BuildContext context) => MemeClusterBloc(MemeClusterRepository(), widget._favoritesBloc)
          ..add(MemeClusterEvent(MemeClusterEventId.LoadMemeClusters))
          ),
          BlocProvider<ShareBloc>(create: (BuildContext context) => ShareBloc())
        ],
        child: MemeClustersPage()
      );
  }

  Widget _buildFavoritesPage() {
    return BlocProvider.value(
      value: widget._favoritesBloc..add(FavoritesLoadEvent(FavoritesEventId.FavoritesUnitialized)),
      child: FavoritesPage());
  }
}
