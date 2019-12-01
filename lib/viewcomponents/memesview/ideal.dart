import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';

class MemesViewComponent {
  static Widget build(List<Meme> items) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
          Meme item = items.elementAt(index);
          return buildSlideContainer(context, item, buildSlide(item));
        },
        itemCount: items.length,
        scale: .85,
        viewportFraction: .75
      );
  }

  static Widget buildSlideContainer(BuildContext context, Meme model, Widget child)
  {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      
      child: child,

      onTap: () {
        //favorite the meme...?
        final snackBar = SnackBar(content: Text("Share...?"));
        Scaffold.of(context).showSnackBar(snackBar);
      },

      onDoubleTap: () {
        //open the share dialog
        final snackBar = SnackBar(content: Text("Favorite"));
        Scaffold.of(context).showSnackBar(snackBar);
      },

      onVerticalDragDown: (DragDownDetails details) {
        final snackBar = SnackBar(content: Text(details.localPosition.toString()));
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
  }
  
  static Widget buildSlide(Meme model)
  {
    assert(model != null);

    switch(model.runtimeType)
    {
      case AudioMeme:
      case TextMeme:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        return Text((model as TextMeme).text);
      case ImageMeme:
      case GifMeme:
      case VideoMeme:
        return Image.network(model.uri.toString(), fit: BoxFit.scaleDown);
      default:
        throw Exception("Illegal type exception");
    }
  }
}