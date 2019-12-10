import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';

class MemesGroupedViewComponent extends StatelessWidget {
  final MemesViewModel viewModel;
  final Map<String, List<Meme>> memes;
  MemesGroupedViewComponent({Key key, this.viewModel, this.memes}) : super(key: key);

  final double scale = .85;
  final double viewportFraction = .75;

  @override
  Widget build(BuildContext context) => Swiper(
      itemBuilder: (BuildContext context, int index) => _buildMemeGroupContainer(memes.entries.elementAt(index).value),
      itemCount: memes.length,
      scale: scale,
      viewportFraction: viewportFraction);

  Widget _buildMemeGroupContainer(List<Meme> memes) => Swiper(
      itemBuilder: (BuildContext context, int index) =>
          _buildMemeContainer(memes.elementAt(index)),
      itemCount: memes.length,
      scale: scale,
      scrollDirection: Axis.vertical,
      pagination: new SwiperPagination());

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
        return Image.network(
          meme.uri.toString(),
          fit: BoxFit.scaleDown,
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