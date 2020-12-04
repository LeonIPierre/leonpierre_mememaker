import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:leonpierre_mememaker/services/memedownloadservice.dart';

class MemeDownloadRepository extends MemeDownloadService {
  final String _baseUrl;

  MemeDownloadRepository(this._baseUrl);

  @override
  Future<File> downloadAsync(String url) {
    // TODO: implement downloadAsync
    throw UnimplementedError();
  }

  @override
  Future<String> getContentUrlAsync(String url) {
    // TODO: implement getContentUrlAsync
    throw UnimplementedError();
  }

  @override
  Future<MemeEntity> getMemeByUrlAsync(String url) async => await http
          .post('$_baseUrl/meme',
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
              body: jsonEncode([url]))
          .then((response) {
        if (response.statusCode != 200) throw Exception("");

        return MemeEntity.fromJson(json.decode(response.body));
      });

  Future<http.Response> _getResponse(String url) async =>
      await http.get(url).timeout(Duration(minutes: 10));
}
