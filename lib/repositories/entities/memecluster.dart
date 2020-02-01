import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:queries/collections.dart';

@immutable
class MemeClusterEntity extends Equatable {
  final String id;

  final String description;

  final IEnumerable<MemeEntity> memes;

  const MemeClusterEntity({this.id, this.description, this.memes});

  factory MemeClusterEntity.fromJson(Map<String, dynamic> json) {
    var memesJson = json['memes'] as List;

    return MemeClusterEntity(
        id: json['id'],
        description: json['description'],
        memes:
            Collection(memesJson.map((i) => MemeEntity.fromJson(i)).toList()));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'memes': memes,
    };
  }

  @override
  List<Object> get props => [id, memes];
}