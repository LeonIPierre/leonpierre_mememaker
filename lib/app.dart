import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/blocs/appconfig.dart';
import 'package:leonpierre_mememaker/blocs/navigation.dart';
import 'package:leonpierre_mememaker/views/container.dart';

class App extends StatelessWidget {
  final AppModel appModel = AppModel(Map<String, String>());
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: appModel.config['title'],
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.greenAccent[300],
      ),
      home: ScreensContainer(NavigationBloc()..toPage(0))
      );
}
