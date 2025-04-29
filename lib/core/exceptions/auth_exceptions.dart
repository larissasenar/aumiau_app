// Classe base genérica para exceções de autenticação
abstract class AuthException implements Exception {
  String get message;

  @override
  String toString() => message;
}

// Exceções específicas herdando de AuthException

class AcessoNegadoException extends AuthException {
  @override
  String get message =>
      'Acesso negado: usuário administrador não pode logar no sistema.';
}

class EmailNaoEncontradoException extends AuthException {
  @override
  final String message;
  EmailNaoEncontradoException([this.message = 'Email não encontrado']);
}

class CredenciaisInvalidasException extends AuthException {
  @override
  String get message => 'Email ou senha inválidos.';
}

class ErroLoginException extends AuthException {
  ErroLoginException(String s);

  @override
  String get message =>
      'Erro ao realizar login. Verifique suas credenciais e tente novamente.';
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

class GoogleAuthException extends AuthException {
  @override
  String get message => 'Erro ao autenticar com o Google. Tente novamente.';
}
