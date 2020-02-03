import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/blocs/favorites/events.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/models/memecluster.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:queries/collections.dart';

/// View that groups memes by cluster
class MemeClustersWidget extends StatelessWidget {
  final double scale = .85;
  final double viewportFraction = .8;

  final IEnumerable<MemeCluster> clusters;
  MemeClustersWidget({Key key, this.clusters}) : super(key: key);

  /*TODO when scrolling through memes you have to wait until the animation stops when scrolling
  before you can start scrolling up I believe its because it doesn't gain focus until the animation stops*/
  @override
  Widget build(BuildContext context) => Swiper(
      itemBuilder: (BuildContext context, int index) {
        var cluster = clusters.elementAt(index);

        return Column(
          children: <Widget>[
            Row(children: <Widget>[
                Text(cluster.description ?? "PlaceHolder Text"),
                IconButton(
                    icon: Icon(
                      cluster.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: cluster.isLiked ? Colors.red : Colors.redAccent,
                    ),
                    onPressed: () {
                      var event = cluster.isLiked
                          ? FavoritesEventId.MemeClusterRemoved
                          : FavoritesEventId.MemeClusterAdded;
                      BlocProvider.of<FavoritesBloc>(context)
                          .add(MemeClusterFavoriteStateChangedEvent(event, cluster));
                    })
              ]),
            Expanded(child: _buildMemeGroupContainer(cluster.memes), flex: 2)
          ],
        );
      },
      itemCount: clusters.count(),
      scale: scale,
      viewportFraction: viewportFraction);

  Widget _buildMemeGroupContainer(IEnumerable<Meme> memes) => Swiper(
      itemBuilder: (BuildContext context, int index) =>
          _buildMemeContainer(memes.elementAt(index)),
      itemCount: memes.count(),
      scale: scale,
      scrollDirection: Axis.vertical,
      pagination: new SwiperPagination());

  /// Build meme wrapper for allowing user to likes
  Widget _buildMemeContainer(Meme meme) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: _buildMeme(meme),
        //double tap
        onDoubleTap: () {},
      );

  Widget _buildMeme(Meme meme) {
    assert(meme != null);

    switch (meme.runtimeType) {
      case AudioMeme:
      case TextMeme:
        return Text((meme as TextMeme).text);
      case ImageMeme:
      case GifMeme:
      case VideoMeme:
        return Image.network(
          meme.uri.toString(),
          fit: BoxFit.contain,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        );
      default:
        throw Exception("Illegal type exception");
    }
  }
}
