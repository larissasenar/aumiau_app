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

  Future<UsuarioModel> fazLogin() async {
    final userFireAuth = await _firebaseAuth.signInWithEmailAndPassword(
      email: _email,
      password: _senha,
    );

    final uid = userFireAuth.user!.uid;
    final userFirestore = await _userRef.doc(uid).get();

    if (!userFirestore.exists || userFirestore.data() == null) {
      throw Exception('Usuário não encontrado no Firestore');
    }

    final user = UsuarioModel.fromJson(uid, userFirestore.data()!);
    return user;
  }
}
