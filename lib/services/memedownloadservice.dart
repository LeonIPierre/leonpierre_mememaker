import 'dart:io';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';

abstract class MemeDownloadService {
  Future<MemeEntity> getMemeByUrlAsync(String url);

  Future<String> getContentUrlAsync(String url);

  Future<File> downloadAsync(String url);
}