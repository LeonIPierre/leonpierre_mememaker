import 'package:leonpierre_mememaker/models/mememodel.dart';

abstract class MemesService {
  Future<List<Meme>> getMemes({bool expression(Meme meme)});
}