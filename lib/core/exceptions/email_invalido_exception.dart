class EmailInvalidoException implements Exception {
  String message;
  EmailInvalidoException(this.message);

  @override
  String toString() => message;
}
