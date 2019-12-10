import 'dart:async';

import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/MockApiService.dart';
import 'package:leonpierre_mememaker/viewmodels/viewmodelprovider.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';

class MemesViewModel extends ViewModelBase {
  PublishSubject<List<Meme>> _memesSubject = PublishSubject<List<Meme>>();
  Stream<List<Meme>> get memes => _memesSubject.stream;

  BehaviorSubject<int> _indexSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get currentIndex => _indexSubject.stream;
  void setCurrentIndex(int index) => _indexSubject.sink.add(index);

  final MockApiService service = MockApiService();

  Timer _timer;
  List<Meme> _allMemes = List<Meme>();

  MemesViewModel(){
    //memesSubject.listen(_onMemesAdded);
  }

  void initialize({bool filterExpression(Meme meme)}) async {
    //have a service that pulls down data every x seconds and when the user does some action..?
    // _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      
    // });
    _onMemesAdded(await service.getMemesAsync(expression: filterExpression));
  }

  Map<String, List<Meme>> groupMemes(List<Meme> memes) {
    //return group(memes, by:(meme) => meme);
    return {"Test12345": memes};

    //return Collection(memes).groupBy((meme) => meme.id)
    //.select((m) => MapEntry(m.key, m.toList()))
    //.;
  }

  void _onMemesAdded(List<Meme> memes) {
    _allMemes.addAll(memes);
    _memesSubject.sink.add(_allMemes);
  }

  void dispose() {
    _timer?.cancel();
    _indexSubject.close();
    _memesSubject.close();
  }
}
