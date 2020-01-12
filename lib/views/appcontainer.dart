import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/models/navigationItemmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/clusteredmemesviewmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/navigationviewmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';
import 'package:leonpierre_mememaker/views/favorite.dart';
import 'package:leonpierre_mememaker/views/memesgrouped.dart';

class AppContainer extends StatefulWidget {
  final NavigationViewModel navigationViewModel;

  AppContainer(this.navigationViewModel);

  createState() => AppContainerAppState();
}

class AppContainerAppState extends State<AppContainer> {
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
                return ViewModelProvider<ClusteredMemesViewModel>(
                    viewModel: ClusteredMemesViewModel(),
                    view: MemesGroupedView());
              case NavigationItem.FAVORITES:
                return ViewModelProvider<MemesViewModel>(
                    viewModel: MemesViewModel(), view: FavoriteView());
              case NavigationItem.SEARCH:
              default:
                return null;
            }
          }),
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
