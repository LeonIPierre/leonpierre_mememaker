import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class MemeEntity extends Equatable{
  final String author;
  final DateTime dateCreated;
  final DateTime datePosted;
  final String id;
  final Uri uri;
  final String type;

  MemeEntity(this.id, this.uri, this.type, this.dateCreated, this.datePosted,
      this.author);

  factory MemeEntity.fromJson(Map<String, dynamic> json) => new MemeEntity(
      json['id'],
      Uri.parse(json['url']),
      json['type'],
      DateTime.parse(json['dateCreated']),
      DateTime.parse(json['datePosted']),
      json['author']);

  @override
  List<Object> get props => [id, type, uri, dateCreated, datePosted];
}
