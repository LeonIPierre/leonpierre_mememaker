import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/states.dart';
import 'package:leonpierre_mememaker/views/favorites/empty.dart';
import 'package:leonpierre_mememaker/views/favorites/ideal.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (BuildContext context, FavoritesState state) {
        if (state is FavoritedContentLoadedState) {
          return FavoritesIdealWidget();
        } else if (state is FavoritesEmptyState) {
          return FavoritesEmptyWidget();
        }

        return Container();
      });
}
