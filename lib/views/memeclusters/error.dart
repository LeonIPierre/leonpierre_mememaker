import 'package:flutter/widgets.dart';

class MemeClustersErrorWidget extends StatelessWidget {
  final String id;

  MemeClustersErrorWidget({this.id});

  //TODO based on the error id return a meme that "matches"
  @override
  Widget build(BuildContext context) => Text(id ?? "You dun goofed");
}