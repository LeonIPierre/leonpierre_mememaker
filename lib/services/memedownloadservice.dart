
import 'dart:io';

import 'package:leonpierre_mememaker/models/mememodel.dart';

abstract class MemeDownloadService {
  Future<Meme> getMemeByUrlAysnc(String url);

  Future<String> getContentUrlAsync(String url);

  Future<File> downloadAsync(String url);
}