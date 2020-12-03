import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/memeclustersservice.dart';

class MemesViewComponent extends StatefulWidget {
  final MemeClustersService service;
  MemesViewComponent({Key key, this.service}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemesViewComponentState();
}

class _MemesViewComponentState extends State<MemesViewComponent> {
  @override
  Widget build(BuildContext context) => new StreamBuilder(
        stream: null,
        initialData: null,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<Meme>>> snapshot) {
          if (snapshot.hasError) return null;

          if (snapshot.hasData)
            return snapshot.data.length == 0
                ? null
                : Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      MapEntry<String, List<Meme>> memes =
                          snapshot.data.entries.elementAt(index);
                      return _buildMemeGroupContainer(memes.value);
                    },
                    itemCount: snapshot.data.length,
                    scale: .85,
                    viewportFraction: .75);

          return CircularProgressIndicator();
        },
      );
  
  /// Build memes by a group
  Widget _buildMemeGroupContainer(List<Meme> memes) => Swiper(
      itemBuilder: (BuildContext context, int index) =>
          _buildMemeContainer(memes.elementAt(index)),
      itemCount: memes.length,
      scale: .85,
      scrollDirection: Axis.vertical);

  /// Build meme wrapper for allowing user to likes
  Widget _buildMemeContainer(Meme meme) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: _buildMeme(meme),
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
        return Image.network(meme.path.toString(), fit: BoxFit.scaleDown);
      default:
        throw Exception("Illegal type exception");
    }
  }
}