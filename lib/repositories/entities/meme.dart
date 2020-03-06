import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';

@immutable
class MemeEntity extends ContentBaseEntity {
  final String author;
  final DateTime dateCreated;
  final DateTime datePosted;
  final String type;

  MemeEntity(String id, String path, this.type,
      {this.dateCreated, this.datePosted, this.author}) : super(id, path: path);

  factory MemeEntity.fromJson(Map<String, dynamic> json) =>
      MemeEntity(json['id'], json['url'], json['type'],
          dateCreated: DateTime.parse(json['dateCreated']),
          datePosted: DateTime.parse(json['datePosted']),
          author: json['author']);

  @override
  List<Object> get props => [id, type, path, dateCreated, datePosted];
}