import 'package:equatable/equatable.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:queries/collections.dart';

abstract class ShareState extends Equatable {
  final Meme _meme;
  const ShareState(this._meme);

  @override
  List<Object> get props => [_meme];
}

class ShareHiddenState extends ShareState {
  ShareHiddenState() : super(null);
}

class ShareIdealState extends ShareState {
  final IEnumerable<Uri> options;

  ShareIdealState(Meme meme, this.options) : super(meme);
  
  @override
  List<Object> get props => [options];
}
