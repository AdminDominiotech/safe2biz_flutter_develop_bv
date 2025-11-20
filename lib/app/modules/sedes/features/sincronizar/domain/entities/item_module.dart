import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class ItemModule extends Equatable {
  ItemModule({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
