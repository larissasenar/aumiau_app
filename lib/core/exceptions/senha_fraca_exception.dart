class SenhaFracaException implements Exception {
  final String mensagem;

  SenhaFracaException([this.mensagem = 'Senha fraca']);

  @override
  String toString() => mensagem;
}
