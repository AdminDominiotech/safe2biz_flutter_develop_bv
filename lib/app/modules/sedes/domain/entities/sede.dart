import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Sede extends Equatable {
  Sede({
    required this.id,
    required this.name,
    required this.code,
    required this.userId,
  });

  String id;
  String name;
  String code;
  String userId;

  @override
  List<Object> get props => [
        id,
        name,
        code,
        userId,
      ];
}
