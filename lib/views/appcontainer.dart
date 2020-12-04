import 'package:dev_libraries/blocs/ads/ads.dart';
import 'package:dev_libraries/blocs/configuration/configuration.dart';
import 'package:dev_libraries/blocs/navigation_cubit.dart';
import 'package:dev_libraries/models/navigationitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/components/share/sharebloc.dart';
import 'package:leonpierre_mememaker/blocs/download/download_bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/repositories/memeclusterrepository.dart';
import 'package:leonpierre_mememaker/repositories/memedownloadrepository.dart';
import 'package:leonpierre_mememaker/views/screens/download.dart';
import 'package:leonpierre_mememaker/views/screens/memeclusters.dart';

import 'components/ads.dart';
import 'screens/favorites.dart';

class AppContainer extends StatefulWidget {
  final NavigationCubit _navigationBloc;

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
    
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (BuildContext context, ConfigurationState state) {
      if (state is ConfigurationUnitializedState)
        return Center(child: CircularProgressIndicator());
      else if (state is ConfigurationErrorState)
        return Center(child: Text(state.message));
      else if (state is ConfigurationInitializedState)
        return BlocBuilder<NavigationCubit, NavigationItemModel>(
            cubit: widget._navigationBloc,
            builder: (BuildContext context, NavigationItemModel pageModel) {
              state.configuration["ad:width"] = MediaQuery.of(context).size.width.round();
              state.configuration["ad:height"] = (MediaQuery.of(context).size.height * .1).round();

              return Scaffold(
                  appBar: AppBar(title: Text(state.configuration["title"])),
                  body: Column(children: <Widget>[
                    Expanded(child: _buildPage(pageModel), flex: 10),
                    Expanded(child: AdsWidget(_adBloc, state.configuration), flex: 1)
                  ]),

                  //TODO implement this animation https://pub.dev/packages/curved_navigation_bar
                  bottomNavigationBar: StreamBuilder(builder:
                      (BuildContext context, AsyncSnapshot<NavigationItem> snapshot) {
                    return BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.flare),
                            label: 'Home/What' 's hot'
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.download_rounded),
                            label: 'Download'
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.save),
                            label: 'Favorites'
                          ),
                        ],
                        currentIndex: pageModel.index,
                        selectedItemColor: Theme.of(context).primaryColor,
                        onTap: (index) {
                          widget._navigationBloc.toPage(index);
                          //notify ui of state change
                          setState(() {});
                        });
                  }));
            });

      return Container();
    });
  }

  Widget _buildPage(NavigationItemModel navigationItem) {
    switch (navigationItem.index) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildDownloadPage();
      case 2:
        return _buildFavoritesPage();
      default:
        return null;
    }
  }

  Widget _buildHomePage() {
    return MultiBlocProvider(providers: [
      BlocProvider<MemeClusterBloc>(
          create: (BuildContext context) =>
              MemeClusterBloc(MemeClusterRepository(), _favoritesBloc)
                ..add(MemeClusterEvent(MemeClusterEventId.LoadMemeClusters))),
      BlocProvider<ShareBloc>(create: (BuildContext context) => ShareBloc())
    ], child: MemeClustersPage());
  }

  Widget _buildDownloadPage() {
    return BlocProvider(create: (BuildContext context) => DownloadBloc(MemeDownloadRepository(), _favoritesBloc),
    child: DownloadPage());
  }

  Widget _buildFavoritesPage() {
    return BlocProvider.value(
        value: _favoritesBloc
          ..add(FavoritesLoadEvent(FavoritesEventId.FavoritesUnitialized)),
        child: FavoritesPage());
  }
}
