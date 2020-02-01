import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class UserLikeEntity extends Equatable {
  final String id;
  final bool isLiked;

  UserLikeEntity(this.id, this.isLiked);

  factory UserLikeEntity.fromMap(Map<String, dynamic> map) {
    return UserLikeEntity(map['id'], map['isLiked'] == 'true');
  }

  @override
  List<Object> get props => [id, isLiked];
}