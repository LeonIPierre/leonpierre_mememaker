// import 'package:equatable/equatable.dart';
// import 'package:flutter/widgets.dart';

// @immutable
// class UserLikeEntity extends Equatable {
//   final int id;
//   final String contentId;
//   final String path;
//   final bool isLiked;

//   UserLikeEntity(this.id, this.contentId, this.path, this.isLiked);

//   factory UserLikeEntity.fromMap(Map<String, dynamic> map) => UserLikeEntity(int.parse(map['id']), map['contentId'], map['path'], map['isLiked'] == 'true');
  
//   @override
//   List<Object> get props => [id, contentId, path, isLiked];
// }