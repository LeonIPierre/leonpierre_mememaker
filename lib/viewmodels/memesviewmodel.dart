import 'dart:collection';
import 'package:faker/faker.dart';

import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:rxdart/rxdart.dart';

class MemesViewModel {
  final BehaviorSubject<List<Meme>> memesSubject = BehaviorSubject<List<Meme>>();
  Stream<List<Meme>> get memes => memesSubject.stream;


  MemesViewModel() {
    var memes = [
      VideoMeme("", Uri()),
      GifMeme("", Uri()),
      //AudioMeme("", Uri()),

      //AudioMeme("", Uri()),
      ImageMeme("", Uri(path: "http://via.placeholder.com/400x800?text=Meme1"), "This is a placeholder"),
      ImageMeme("", Uri(path: "http://via.placeholder.com/400x800?text=Meme2"), "This is a placeholder 2"),
      TextMeme("", Uri(), Faker().lorem.word()),
      TextMeme("", Uri(), Faker().lorem.word()),
      TextMeme("", Uri(), Faker().lorem.word()),
      TextMeme("", Uri(), Faker().lorem.word()),
    ];

    memesSubject.add(UnmodifiableListView<Meme>(memes));
  }

  void dispose() {
    memesSubject.close();
  }
}