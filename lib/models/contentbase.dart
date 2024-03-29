import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';

@immutable
class ContentBase extends Equatable {
  final String id;
  final String name;
  final String description;
  final Uri path;
  final String author;
  final bool isLiked;

  const ContentBase(this.id, {this.name, this.description, this.path, this.author, this.isLiked});

  factory ContentBase.fromEntity(ContentBaseEntity entity) => 
    ContentBase(entity.id, path: entity.path == null ? null : Uri.tryParse(entity.path),
      name: entity.name, description: entity.description, isLiked: entity.dateLiked != null, author: '');

  @override
  List<Object> get props => [id, path, author, isLiked];
}