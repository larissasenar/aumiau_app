import 'package:aumiau_app/core/exceptions/auth_exceptions.dart';
import 'package:aumiau_app/core/models/usuario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController {
  String _email = '';
  String _senha = '';
  bool _isLoading = false;

  final _firebaseAuth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('usuarios');

  void setEmail(String email) => _email = email;
  void setSenha(String senha) => _senha = senha;
  void setIsLoading(bool isLoading) => _isLoading = isLoading;

  bool get isLoading => _isLoading;

  Future<UsuarioModel> fazLogin() async {
    setIsLoading(true);

    try {
      final userFireAuth = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email,
        password: _senha,
      );

      final uid = userFireAuth.user!.uid;
      final userFirestore = await _userRef.doc(uid).get();

      if (!userFirestore.exists || userFirestore.data() == null) {
        throw EmailNaoEncontradoException();
      }

      final user = UsuarioModel.fromJson(uid, userFirestore.data()!);

      //para permitir o login do ADMIN
      // if (user.tipo == 'ADMIN') {
      //   throw AcessoNegadoException();
      // }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw EmailNaoEncontradoException();
        case 'wrong-password':
          throw SenhaInvalidaException();
        case 'invalid-email':
          throw EmailInvalidoException();
        case 'user-disabled':
          throw ErroLoginException('Usuário desativado. Contate o suporte.');
        case 'network-request-failed':
          throw ErroLoginException(
              'Erro de conexão. Verifique sua rede e tente novamente.');
        default:
          throw ErroLoginException('Erro desconhecido durante o login.');
      }
    } catch (e) {
      if (e is AcessoNegadoException) {
        throw ErroLoginException(
            'Acesso negado: usuário administrador não pode logar no sistema.');
      } else if (e is AuthException) {
        rethrow;
      } else {
        throw ErroLoginException(
            'Erro inesperado. Tente novamente mais tarde.');
      }
    } finally {
      setIsLoading(false);
    }
  }
}
