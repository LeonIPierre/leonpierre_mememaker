import 'package:flutter/material.dart';

abstract class ViewModelBase {
  void dispose();
}

class ViewModelProvider<T extends ViewModelBase> extends StatefulWidget {
  ViewModelProvider({
    Key key,
    @required this.view,
    @required this.viewModel,
  }): super(key: key);

  final T viewModel;
  final Widget view;

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();

  static T of<T extends ViewModelBase>(BuildContext context){
    final type = _typeOf<ViewModelProvider<T>>();
    ViewModelProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.viewModel;
  }

  static Type _typeOf<T>() => T;
}

class _ViewModelProviderState<T> extends State<ViewModelProvider<ViewModelBase>>{
  @override
  void dispose(){
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.view;
}