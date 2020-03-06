import 'package:equatable/equatable.dart';

class ContentBaseEntity extends Equatable {
  final String id;
  final String path;
  final DateTime dateLiked;

  ContentBaseEntity(this.id, { this.path, this.dateLiked });

  factory ContentBaseEntity.fromJson(Map<String, dynamic> json) {
    return ContentBaseEntity(json['id'], path: json['path'], dateLiked: json['dateCreated'] == null ? null : DateTime.parse(json['dateCreated']));
  }
  
  @override
  List<Object> get props => [id, path, dateLiked];
}