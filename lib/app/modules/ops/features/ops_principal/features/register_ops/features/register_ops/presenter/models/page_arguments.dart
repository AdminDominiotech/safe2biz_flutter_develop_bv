class RegisterOpsPageArgs {
  const RegisterOpsPageArgs({
    required this.title,
    required this.subTitle,
    required this.subTitleQuestion,
    required this.opsRegistroGeneralesId,
    required this.idResultadoOps,
    required this.idVerificacion,
    required this.opsListaVerifPreguntaId,
    required this.opsListaVerifSeccionId,
    required this.opsListaVerifCategoriaId,
  });

  final String title;
  final String subTitle;
  final String subTitleQuestion;
  final String opsRegistroGeneralesId;
  final String idResultadoOps;
  final String idVerificacion;
  final String opsListaVerifPreguntaId;
  final String opsListaVerifSeccionId;
  final String opsListaVerifCategoriaId;
}
