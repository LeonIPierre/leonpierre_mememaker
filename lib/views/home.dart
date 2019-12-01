import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesview/empty.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesview/error.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesview/ideal.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesview/loading.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';

class HomeView extends StatefulWidget {
  final MemesViewModel model; 
  HomeView({Key key, this.model}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),

      body: new StreamBuilder(
        stream: widget.model.memesSubject,
        initialData: widget.model.memesSubject.value,
        builder: (BuildContext context, AsyncSnapshot<List<Meme>> snapshot) {          
          if(snapshot.hasError)
            return MemesErrorViewComponent.build();

          if(snapshot.hasData)
            return snapshot.data.length == 0 ?
              MemesEmptyViewComponent.build(snapshot.data) : MemesViewComponent.build(snapshot.data);

          return MemeViewLoadingComponent.build();
        }
      )
  );

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