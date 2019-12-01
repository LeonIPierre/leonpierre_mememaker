import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';

class HomeView extends StatefulWidget {
  final MemesViewModel model; 
  HomeView({Key key, this.model}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: new StreamBuilder(
        stream: widget.model.memesSubject,
        //initialData: widget.model.memesSubject.value,
        builder: (BuildContext context, AsyncSnapshot<List<Meme>> snapshot) {          
          if(!snapshot.hasData)
            return buildEmpty();

          if(snapshot.hasError)
            return buildEmpty();
          
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
            //case ConnectionState.active:
              return Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    Meme item = snapshot.data.elementAt(index);
                    return buildContainer(context, item, buildSlide(item));
                  },
                  itemCount: snapshot.hasData ? snapshot.data.length : 0,
                  //pagination: new SwiperPagination(),
                  //control: new SwiperPlugin(),
                  scale: .85,
                  viewportFraction: .75
                );
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
          }
          return null;
        }
      )
    );
  }

  Widget buildContainer(BuildContext context, Meme model, Widget child)
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
  Widget buildSlide(Meme model)
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
        break;
    }
  }

  Widget buildEmpty()
  {
    return Text("You ain't got shit");
  }

  @override
  void initState() {
    super.initState();
    widget.model.getAll();
  }

  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }
}