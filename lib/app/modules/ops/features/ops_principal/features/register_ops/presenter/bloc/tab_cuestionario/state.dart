part of 'bloc.dart';

abstract class TabCuestionarioState extends Equatable {
  const TabCuestionarioState(this.model);

  final Model model;

  @override
  List<Object> get props => [model];
}

class Init extends TabCuestionarioState {
  const Init(Model model) : super(model);
}

class Loading extends TabCuestionarioState {
  const Loading(Model model) : super(model);
}

class Loaded extends TabCuestionarioState {
  const Loaded(Model model) : super(model);
}

class FailureGetIncidentesAccidentes extends TabCuestionarioState {
  const FailureGetIncidentesAccidentes({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final TabCuestionarioState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class Model extends Equatable {
  const Model({
    this.idSede = '',
    // this.loading = true,
    this.categories = const [],
    this.sections = const [],
    this.questions = const [],
  });

  final String idSede;
  // final bool loading;
  final List<ExpansionModel> categories;
  final List<ExpansionModel> sections;
  final List<ExpansionModel> questions;

  static Model empty() => Model();

  Model copyWith({
    String? idSede,
    // bool? loading,
    List<ExpansionModel>? categories,
    List<ExpansionModel>? sections,
    List<ExpansionModel>? questions,
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      // loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      sections: sections ?? this.sections,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object> get props => [
        categories,
        sections,
        questions,
      ];
}

class ExpansionModel {
  final int id;
  final int idReference;
  final String nombre;
  final String tag;
  bool isExpanded;

  ExpansionModel({
    required this.id,
    required this.idReference,
    required this.nombre,
    this.tag = '',
    this.isExpanded = false,
  });
}
