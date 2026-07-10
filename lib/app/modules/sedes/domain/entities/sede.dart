import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Sede extends Equatable {
  Sede({
    required this.id,
    required this.name,
    required this.code,
    required this.userId,
    required this.fb_uea_base_id
  });

  String id;
  String name;
  String code;
  String userId;
  String fb_uea_base_id;

  @override
  List<Object> get props => [
        id,
        name,
        code,
        userId,
    fb_uea_base_id
      ];
}


