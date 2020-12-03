import 'package:equatable/equatable.dart';

class ContentBaseEntity extends Equatable {
  final String id;
  final String name; 
  final String description;
  final String path;
  final DateTime dateLiked;

  const ContentBaseEntity(this.id, { this.name, this.description, this.path, this.dateLiked });

  factory ContentBaseEntity.fromJson(Map<String, dynamic> json) {
    return ContentBaseEntity(json['id'], path: json['path'], name: json['name'], description: json['description'],
    dateLiked: json['dateLiked'] == null ? null : DateTime.parse(json['dateLiked']));
  }
  
  @override
  List<Object> get props => [id, path, dateLiked];
}