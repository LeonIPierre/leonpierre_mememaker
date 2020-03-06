import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';

class ContentWidget extends StatelessWidget {
  final ContentBase meme;

  ContentWidget(this.meme);

  @override
  Widget build(BuildContext context) {
    

    return _buildMeme(meme);
  }

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
          meme.path.toString(),
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