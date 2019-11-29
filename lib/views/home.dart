import 'package:faker/faker.dart';
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
      body: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              //widget.model.memes.fo

              return buildContainer(context, widget.model.memesSubject.first.);
            },
            itemCount: 2,
            scale: .85,
            viewportFraction: .75
          );
      body: new StreamBuilder(
        stream: widget.model.memesSubject,
        builder: (BuildContext context, AsyncSnapshot<List<Meme>> snapshot) {

          
          return Swiper(
            itemBuilder: (BuildContext context, int index) {
              return buildContainer(context, snapshot.data.elementAt(index));
            },
            itemCount: snapshot.hasData ? snapshot.data.length : 0,
            scale: .85,
            viewportFraction: .75
          );
        }
      )

      // body: Swiper(
      //   //pager should show top memes for the viewed month
      //   pagination: new SwiperPagination(
      //               margin: new EdgeInsets.all(0.0),
      //               builder: new SwiperCustomPagination(builder:
      //                   (BuildContext context, SwiperPluginConfig config) {
      //                 return new ConstrainedBox(
      //                   child: new Row(
      //                     children: <Widget>[
      //                       new Text(
      //                         "Test123",
      //                         //"${titles[config.activeIndex]} ${config.activeIndex + 1}/${config.itemCount}",
      //                         style: TextStyle(fontSize: 20.0),
      //                       ),
      //                       new Expanded(
      //                         child: new Align(
      //                           alignment: Alignment.centerRight,
      //                           child: new DotSwiperPaginationBuilder(
      //                                   color: Colors.black12,
      //                                   activeColor: Colors.black,
      //                                   size: 10.0,
      //                                   activeSize: 20.0)
      //                               .build(context, config),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                   constraints: new BoxConstraints.expand(height: 50.0),
      //                 );
      //               })),
      //   //create custom control where you can hold it and select the month you want to go to?
      //   control: new SwiperControl(),
      // )
    );
  }

  Widget buildContainer(BuildContext context, Meme model)
  {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget,

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
    //assert(model != null);

    switch(model.runtimeType)
    {
      //case VideoMeme:
      case AudioMeme:
      case TextMeme:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        return new Text((model as TextMeme).text);
        break;
      case ImageMeme:
        return new Image.network("http://via.placeholder.com/400x800.png", fit: BoxFit.scaleDown);
        break;
      case GifMeme:
        return new Image.network("http://via.placeholder.com/400x800", fit: BoxFit.scaleDown);
        break;
      default:
        return new Text(model.runtimeType.toString());
        break;
    }
  }

  Widget buildEmpty()
  {
    return Text("You ain't got shit");
  }
}