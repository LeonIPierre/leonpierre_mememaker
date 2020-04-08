import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/bloc.dart';
import 'package:leonpierre_mememaker/blocs/memeclusters/memeclusterbloc.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/views/components/content.dart';
import 'package:leonpierre_mememaker/views/components/share.dart';
import 'package:queries/collections.dart';

class MemeClustersWidget extends StatefulWidget {
  MemeClustersWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemeClusterWidgetState();
}

class _MemeClusterWidgetState extends State<MemeClustersWidget> {
  final double scale = .85;
  final double viewportFraction = .9;
  FavoritesBloc _favoritesBloc;

  /*TODO when scrolling through memes you have to wait until the animation stops when scrolling
  before you can start scrolling up I believe its because it doesn't gain focus until the animation stops*/
  @override
  Widget build(BuildContext context) { 
    _favoritesBloc = BlocProvider.of<FavoritesBloc>(context);
    
    return StreamBuilder<IEnumerable<MemeCluster>>(
      stream: BlocProvider.of<MemeClusterBloc>(context).clusters.stream,
      initialData: BlocProvider.of<MemeClusterBloc>(context).clusters.stream.value,
      builder: (context, snapshot) {
        return Swiper(
            itemBuilder: (BuildContext context, int index) {
              var cluster = snapshot.data.elementAt(index);

              return Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(flex: 2, child: Text(cluster.description ?? "PlaceHolder Text")),
                    
                    IconButton(
                        icon: Icon(
                          cluster.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: cluster.isLiked ? Colors.red : Colors.redAccent,
                        ),
                        onPressed: () {
                          var event = cluster.isLiked
                              ? MemeClusterEventId.RemoveMemeClusterLike
                              : MemeClusterEventId.AddMemeClusterLike;

                          BlocProvider.of<MemeClusterBloc>(context)
                              .add(MemeClusterStateChangeEvent(event, cluster));
                        })
                  ]),
                  Expanded(
                      child: _buildMemeGroupContainer(cluster.memes), flex: 2)
                ],
              );
            },
            itemCount: snapshot.hasData ? snapshot.data.count() : 0,
            scale: scale,
            viewportFraction: viewportFraction);
      });
  }

  Widget _buildMemeGroupContainer(IEnumerable<Meme> memes) => Swiper(
      itemBuilder: (BuildContext context, int index) =>
          _buildMemeContainer(context, memes.elementAt(index)),
      itemCount: memes.count(),
      scale: scale,
      scrollDirection: Axis.vertical,
      pagination: new SwiperPagination());

  /// Build meme wrapper for allowing user to likes
  Widget _buildMemeContainer(BuildContext context, Meme meme) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: ContentWidget(meme),
            //onTap: ()  =>,
            onDoubleTap: () {
               _toggleMemeLike(meme);
              // BlocProvider.of<ShareBloc>(context)
              //   ..add(ShareOptionsLoadEvent(meme));
            },
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
            icon: Icon(
              meme.isLiked ? Icons.favorite : Icons.favorite_border,
              color: meme.isLiked ? Colors.red : Colors.redAccent,),
              onPressed: () => _toggleMemeLike(meme)),),
 
          ShareWidget(),
        ],
      );

  _toggleMemeLike(Meme meme) {
    var event = meme.isLiked ? FavoritesEventId.MemeRemoved : FavoritesEventId.MemeAdded;
    _favoritesBloc.add(FavoriteStateChangedEvent(event, meme));
  }
}
