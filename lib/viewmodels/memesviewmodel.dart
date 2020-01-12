import 'dart:async';
import 'dart:collection';

import 'package:leonpierre_mememaker/models/memeclustermodel.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/MockApiService.dart';
import 'package:leonpierre_mememaker/services/clusteredmemeservice.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';
import 'package:rxdart/rxdart.dart';

class MemesViewModel extends ViewModelBase {
  PublishSubject<List<Meme>> _memesSubject = PublishSubject<List<Meme>>();
  Stream<List<Meme>> get memes => _memesSubject.stream;

  final MockApiService service = MockApiService();

  List<Meme> _allMemes = List<Meme>();
  Timer _timer;

  void initialize({bool filterExpression(Meme meme)}) async {
    _onMemesAdded(await service.getMemesAsync(expression: filterExpression));
  }

  void _onMemesAdded(List<Meme> memes) {
    _allMemes.addAll(memes);
    _memesSubject.sink.add(UnmodifiableListView<Meme>(_allMemes));
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {});
    //Stream.periodic()
  }

  void dispose() {
    _timer?.cancel();
    _memesSubject.close();
  }
}
