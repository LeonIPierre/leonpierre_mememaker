import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonpierre_mememaker/viewmodels/appmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';
import 'package:leonpierre_mememaker/views/home.dart';

class App extends StatelessWidget {
  final AppModel appModel = AppModel(Map<String,String>());
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: appModel.config['title'],
      theme: ThemeData(
        backgroundColor: Colors.black,
        primaryColor:  Colors.greenAccent[300],
        primarySwatch: Colors.greenAccent[300],
      ),
      //home: FocusView(model: new FocusViewModel())
      home: HomeView(model: MemesViewModel()),
      //showPerformanceOverlay: true,
    );
  }
}