import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/appbloc.dart';
import 'package:leonpierre_mememaker/blocs/navigation.dart';
import 'package:leonpierre_mememaker/repositories/favoritesrepository.dart';
import 'package:leonpierre_mememaker/views/appcontainer.dart';

import 'blocs/favorites/favoritesbloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    return MaterialApp(
      title: appBloc.configuration["system:title"],
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.greenAccent[300],
      ),
      home: AppContainer(NavigationBloc()..toPage(0), appBloc, FavoritesBloc(FavoritesRepository()))
      );
  }
}