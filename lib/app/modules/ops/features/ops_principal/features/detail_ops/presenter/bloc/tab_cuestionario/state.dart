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
    this.categories = const [],
    this.sections = const [],
    this.questions = const [],
    this.results = const [],         // ← nueva lista de resultados
  });

  final String idSede;
  final List<ExpansionModel> categories;
  final List<ExpansionModel> sections;
  final List<ExpansionModel> questions;
  final List<ResultadoOps> results; // ← aquí

  static Model empty() => const Model();

  Model copyWith({
    String? idSede,
    List<ExpansionModel>? categories,
    List<ExpansionModel>? sections,
    List<ExpansionModel>? questions,
    List<ResultadoOps>? results,    // ← y aquí
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      categories: categories ?? this.categories,
      sections: sections ?? this.sections,
      questions: questions ?? this.questions,
      results: results ?? this.results,  // ← y aquí
    );
  }

  @override
  List<Object?> get props => [
    idSede,
    categories,
    sections,
    questions,
    results,    // ← añadir aquí
  ];
}




class ExpansionModel {
  ExpansionModel({
    required this.id,
    required this.idReference,
    required this.nombre,
    this.tag = '',
    this.isExpanded = false,
  });

  final int id;
  final int idReference;
  final String nombre;
  final String tag;
  bool isExpanded;
}
