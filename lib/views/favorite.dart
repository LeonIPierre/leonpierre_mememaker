import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoriteView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Text("Test Favorite page")
  );
}