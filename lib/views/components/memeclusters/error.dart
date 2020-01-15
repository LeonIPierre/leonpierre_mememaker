import 'package:flutter/widgets.dart';

class MemesGroupedErrorViewComponent extends StatelessWidget {
  final String id;

  MemesGroupedErrorViewComponent({this.id});

  //TODO based on the error id return a meme that "matches"
  @override
  Widget build(BuildContext context) => Text(id ?? "You dun goofed");
}