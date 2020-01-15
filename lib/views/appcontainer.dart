import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/clusteredmemesbloc.dart';
import 'package:leonpierre_mememaker/blocs/navigationviewmodel.dart';
import 'package:leonpierre_mememaker/models/navigationItemmodel.dart';
import 'package:leonpierre_mememaker/views/components/memeclusters/events.dart';
import 'package:leonpierre_mememaker/views/memeclusters.dart';

class AppContainer extends StatefulWidget {
  final NavigationViewModel navigationViewModel;

  AppContainer(this.navigationViewModel);

  createState() => _AppContainerAppState();
}

class _AppContainerAppState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: StreamBuilder(
          stream: widget.navigationViewModel.pages,
          initialData: widget.navigationViewModel.navigation.value,
          builder: (BuildContext context,
              AsyncSnapshot<NavigationItemModel> snapshot) {
            switch (snapshot.data.item) {
              case NavigationItem.HOME:
                return BlocProvider(
                  create: (context) => ClusteredMemesBloc()..add(MemeClusterEvent.NewestMemes),
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
            currentIndex: widget.navigationViewModel.navigation.value.index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              widget.navigationViewModel.toPage(index);
              //notify ui of state change
              setState(() {});
            });
      }));
}
