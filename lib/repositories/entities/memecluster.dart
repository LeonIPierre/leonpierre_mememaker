import 'package:flutter/widgets.dart';
import 'package:leonpierre_mememaker/repositories/entities/meme.dart';
import 'package:queries/collections.dart';

import 'contentbase.dart';

@immutable
class MemeClusterEntity extends ContentBaseEntity {
  final String description;
  final IEnumerable<MemeEntity> memes;

  MemeClusterEntity(id, {this.description, this.memes}) : super(id);

  factory MemeClusterEntity.fromJson(Map<String, dynamic> json) {
    var memesJson = json['memes'] as List;

    return MemeClusterEntity(json['id'],
        description: json['description'],
        memes: Collection(memesJson.map((i) => MemeEntity.fromJson(i)).toList()));
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