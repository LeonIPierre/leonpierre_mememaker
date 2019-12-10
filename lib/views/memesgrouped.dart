import 'package:flutter/material.dart';

import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/empty.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/error.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/ideal.dart';
import 'package:leonpierre_mememaker/viewcomponents/memesgroupedview/loading.dart';
import 'package:leonpierre_mememaker/viewmodels/memesviewmodel.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';

class MemesGroupedView extends StatelessWidget {
  final Function(Meme) filterExpression;
  MemesGroupedView({Key key, this.filterExpression}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MemesViewModel viewModel = ViewModelProvider.of<MemesViewModel>(context);
    viewModel.initialize(filterExpression: filterExpression);

    return Scaffold(
      body: new StreamBuilder(
          stream: viewModel.memes,
          builder: (BuildContext context, AsyncSnapshot<List<Meme>> snapshot) {
            if (snapshot.hasError) return MemesGroupedErrorViewComponent();

            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? MemesGroupedEmptyViewComponent()
                  : MemesGroupedViewComponent(
                      memes: viewModel.groupMemes(snapshot.data),
                      viewModel: viewModel);

            return MemesGroupedViewLoadingComponent();
          }),
    );
  }
}
