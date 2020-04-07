import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/views/components/content.dart';

class FavoritesIdealWidget extends StatefulWidget {
  FavoritesIdealWidget();

  @override
  State<StatefulWidget> createState() => _FavoritesIdealWidgetState();
}

class _FavoritesIdealWidgetState extends State<FavoritesIdealWidget> {
  
  @override
  Widget build(BuildContext context) {
    final FavoritesBloc bloc = BlocProvider.of<FavoritesBloc>(context);

    return StreamBuilder(
        stream: bloc.memeFavorites,
        initialData: bloc.memeFavorites.value,
        builder: (BuildContext context, AsyncSnapshot<Set<ContentBase>> snapshot) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ContentWidget(snapshot.data.elementAt(index));
              });
        });
  }
}
