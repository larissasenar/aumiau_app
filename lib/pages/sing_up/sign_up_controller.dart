import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aumiau_app/core/exceptions/email_em_uso_exception.dart';
import 'package:aumiau_app/core/exceptions/email_invalido_exception.dart';
import 'package:aumiau_app/core/exceptions/senha_fraca_exception.dart';

class SignUpController {
  String? _nome;
  String? _email;
  String? _senha;
  String? _senhaConfirmada;
  bool _isLoading = false;

  final _firebaseAuth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('usuarios');

  bool get isLoading => _isLoading;

  void setNome(String nome) => _nome = nome;
  void setEmail(String email) => _email = email;
  void setSenha(String senha) => _senha = senha;
  void setSenhaConfirmada(String senhaConfirmada) =>
      _senhaConfirmada = senhaConfirmada;
  void setIsLoading(bool isLoading) => _isLoading = isLoading;

  String? validaSenhaRepetida(String? senhaRepetida) {
    if (senhaRepetida == null || senhaRepetida.isEmpty) {
      return 'Campo obrigatório';
    } else if (_senha != senhaRepetida) {
      return 'As senhas devem ser iguais';
    }
    return null;
  }

  Future<void> criaUsuario() async {
    if (_email == null || _senha == null || _nome == null) {
      throw Exception('Preencha todos os campos obrigatórios.');
    }

    if (_email!.isEmpty || _senha!.isEmpty || _nome!.isEmpty) {
      throw Exception('Preencha todos os campos corretamente.');
    }

    setIsLoading(true);

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _email!,
        password: _senha!,
      );

      final uid = userCredential.user!.uid;

      await _userRef.doc(uid).set({
        'nome': _nome,
        'email': _email,
        'tipo': _email == 'admin@aumiau.com' ? 'ADMIN' : 'USUARIO',
        'criado_em': FieldValue.serverTimestamp(),
      });

      await userCredential.user!.updateDisplayName(_nome);
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
    } finally {
      setIsLoading(false);
    }
  }
}
