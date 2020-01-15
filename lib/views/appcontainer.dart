import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/blocs/navigation.dart';
import 'package:leonpierre_mememaker/models/navigationItem.dart';
import 'package:leonpierre_mememaker/services/memeclusterservice.dart';
import 'package:leonpierre_mememaker/views/memeclusters/views.dart';

class AppContainer extends StatefulWidget {
  final NavigationBloc navigation;

  AppContainer(this.navigation);

  createState() => _AppContainerAppState();
}

class _AppContainerAppState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: StreamBuilder(
          stream: widget.navigation.pages,
          initialData: widget.navigation.navigation.value,
          builder: (BuildContext context,
              AsyncSnapshot<NavigationItemModel> snapshot) {
            switch (snapshot.data.item) {
              case NavigationItem.HOME:
                return BlocProvider(
                  create: (context) => MemeClusterBloc(MemeClusterService())
                    ..add(MemeClusterEvent.NewestMemes),
                  child: MemeClustersView(),
                );
              case NavigationItem.SEARCH:
              default:
                return null;
            }
          }),
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
