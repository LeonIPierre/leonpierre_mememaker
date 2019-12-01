import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/MockApiService.dart';
import 'package:rxdart/rxdart.dart';

class MemesViewModel {
  final BehaviorSubject<List<Meme>> memesSubject = BehaviorSubject<List<Meme>>();
  Stream<List<Meme>> get memes => memesSubject.stream;
  
  final MockApiService service = MockApiService();

  MemesViewModel() {
  }

  Future<List<Meme>> getAll() async {
    await Future.delayed(Duration(seconds: 2));
    List<Meme> memes = await service.getMemesAsync();
    memesSubject.sink.add(memes);

    return memes;
  }

  void dispose() {
    memesSubject.close();
  }
}

MemesViewModel memesInstance = MemesViewModel();