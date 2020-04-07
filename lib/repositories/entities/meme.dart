import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';

@immutable
class MemeEntity extends ContentBaseEntity {
  final String author;
  final DateTime dateCreated;
  final DateTime datePosted;
  final String type;

  MemeEntity(String id, String path, this.type,
      {this.dateCreated, this.datePosted, this.author, DateTime dateLiked}) 
      : super(id, path: path, dateLiked: dateLiked);
      
  factory MemeEntity.fromJson(Map<String, dynamic> json) =>
      MemeEntity(json['id'], json['url'], json['type'],
          dateLiked: json['dateLiked'] == null ? null : DateTime.parse(json['dateLiked']),
          dateCreated: json['dateCreated'] == null ? null : DateTime.parse(json['dateCreated']),
          datePosted: json['datePosted'] == null ? null : DateTime.parse(json['datePosted']),
          author: json['author']);

  @override
  List<Object> get props => [id, type, path, dateCreated, datePosted];
}