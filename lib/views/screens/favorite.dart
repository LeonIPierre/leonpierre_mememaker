import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoritesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Text("Test Favorite page")
  );
}