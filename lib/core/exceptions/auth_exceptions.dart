// Classe base genérica para exceções de autenticação
abstract class AuthException implements Exception {
  String get message;

  @override
  String toString() => message;
}

// Exceções específicas herdando de AuthException
class UsuarioNaoEncontradoException extends AuthException {
  @override
  String get message => 'Usuário não encontrado no sistema.';
}

class CredenciaisInvalidasException extends AuthException {
  @override
  String get message => 'Email ou senha inválidos.';
}

class ErroLoginException extends AuthException {
  @override
  String get message => 'Erro ao realizar login. Tente novamente.';
}

class EmailInvalidoException extends AuthException {
  @override
  String get message => 'Email inválido. Verifique e tente novamente.';
}

class EmailEmUsoException extends AuthException {
  @override
  String get message => 'Este email já está em uso. Escolha outro.';
}

class SenhaFracaException extends AuthException {
  @override
  String get message => 'A senha deve ter pelo menos 6 caracteres.';
}

class SenhaInvalidaException extends AuthException {
  @override
  String get message => 'Senha inválida.';
}

class SenhaDiferenteException extends AuthException {
  @override
  String get message => 'As senhas não coincidem.';
}

class SenhaNaoConfereException extends AuthException {
  @override
  String get message => 'A confirmação de senha está incorreta.';
}
