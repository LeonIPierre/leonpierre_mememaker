import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/viewmodels/appmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/navigationviewmodel.dart';
import 'package:leonpierre_mememaker/views/appcontainer.dart';

class App extends StatelessWidget {
  final AppModel appModel = AppModel(Map<String, String>());
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: appModel.config['title'],
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.greenAccent[300],
      ),
      home: AppContainer(NavigationViewModel())
      );
}
