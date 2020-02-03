import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final NavigationBloc navigation;

  ScreensContainer(this.navigation);

  createState() => _ScreensContainerState();
}

class _ScreensContainerState extends State<ScreensContainer> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: BlocProvider(
        create: (BuildContext context) => FavoritesBloc(FavoritesRepository()),
        child: StreamBuilder(
            stream: widget.navigation.pages,
            initialData: widget.navigation.navigation.value,
            builder: (BuildContext context,
                AsyncSnapshot<NavigationItemModel> snapshot) {
              switch (snapshot.data.item) {
                case NavigationItem.HOME:
                  return BlocProvider<MemeClusterBloc>(
                      create: (BuildContext context) => MemeClusterBloc(
                          MemeClusterRepository(),
                          BlocProvider.of<FavoritesBloc>(context))..add(MemeClusterEvent(
                            MemeClusterEventId.LoadMemeClusters)),
                      child: MemeClustersPage());
                case NavigationItem.FAVORITES:
                  return BlocProvider(
                      create: (context) => BlocProvider.of<FavoritesBloc>(context),
                      child: FavoritesPage());
                case NavigationItem.SEARCH:
                default:
                  return null;
              }
            }),
      ),

      // body: StreamBuilder(
      //     stream: widget.navigation.pages,
      //     initialData: widget.navigation.navigation.value,
      //     builder: (BuildContext context,
      //         AsyncSnapshot<NavigationItemModel> snapshot) {
      //       switch (snapshot.data.item) {
      //         case NavigationItem.HOME:
      //           return MultiBlocProvider(providers: [
      //             BlocProvider<UserLikesBloc>(
      //               create: (BuildContext context) => UserLikesBloc(UserLikesRepository()),
      //             ),
      //             BlocProvider<MemeClusterBloc>(
      //               create: (BuildContext context) =>  MemeClusterBloc(MemeClusterRepository(),
      //               BlocProvider.of<UserLikesBloc>(context))..add(MemeClusterEvent(MemeClusterEventId.LoadMemeClusters)),
      //             )
      //           ], child: MemeClustersPage());
      //         case NavigationItem.FAVORITES:
      //           return BlocProvider(
      //               create: (context) => FavoritesBloc()
      //                 ..add(FavoritesEvent(FavoritesEventId.LoadFavorites)),
      //               child: FavoritesPage());
      //         case NavigationItem.SEARCH:
      //         default:
      //           return null;
      //       }
      //     }),
      //https://pub.dev/packages/curved_navigation_bar
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
            currentIndex: widget.navigation.navigation.value.index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              widget.navigation.toPage(index);
              //notify ui of state change
              setState(() {});
            });
      }));
}
