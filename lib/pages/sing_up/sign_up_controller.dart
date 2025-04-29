import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aumiau_app/core/exceptions/email_em_uso_exception.dart';
import 'package:aumiau_app/core/exceptions/email_invalido_exception.dart';
import 'package:aumiau_app/core/exceptions/senha_fraca_exception.dart';

class SignUpController {
  String? _nome = '';
  String? _email = '';
  String? _senha = '';
  String? _senhaConfirmada = '';

  bool _isLoading = false;

  final _firebaseAuth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('usuarios');

  String? validaSenhaRepetida(String? senhaRepetida) {
    if (senhaRepetida == null || senhaRepetida.isEmpty) {
      return 'Campo obrigatório';
    } else if (_senha != senhaRepetida) {
      return 'As senhas devem ser iguais';
    }
    return null;
  }

  Future<void> criaUsuario() async {
    try {
      if (_email == null ||
          _senha == null ||
          _email!.isEmpty ||
          _senha!.isEmpty) {
        throw Exception('Email ou senha não foram fornecidos.');
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _email!,
        password: _senha!,
      );

      await _userRef.doc(userCredential.user!.uid).set({
        'nome': _nome,
        'email': _email,
        'tipo': 'ADMIN',
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailEmUsoException('Email já está em uso');
        case 'invalid-email':
          throw EmailInvalidoException('Email inválido');
        case 'weak-password':
          throw SenhaFracaException('A senha deve ter pelo menos 6 caracteres');
        default:
          rethrow;
      }
    } catch (e) {
      print('Erro inesperado: $e');
      rethrow;
    }
  }

  void setNome(String nome) => _nome = nome;
  void setEmail(String email) => _email = email;
  void setSenha(String senha) => _senha = senha;
  void setSenhaConfirmada(String senhaConfirmada) =>
      _senhaConfirmada = senhaConfirmada;
  void setIsLoading(bool isLoading) => _isLoading = isLoading;

  bool get isLoading => _isLoading;
}
