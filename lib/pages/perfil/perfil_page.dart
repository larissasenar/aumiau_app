import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      final data = doc.data();

      if (data != null) {
        _nomeController.text = data['nome'] ?? '';
        _emailController.text = user.email ?? '';
      }
      setState(() {});
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    final novoNome = _nomeController.text;
    final novaSenha = _senhaController.text;

    try {
      if (user != null) {
        if (novaSenha.isNotEmpty && novaSenha.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('A senha deve ter ao menos 6 caracteres.')),
          );
          setState(() => _isLoading = false);
          return;
        }

        await user.updateDisplayName(novoNome);

        if (novaSenha.isNotEmpty) {
          await user.updatePassword(novaSenha);
        }

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .update({
          'nome': novoNome,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.of(context).pop(); // Volta para a tela anterior
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Erro ao atualizar perfil. Verifique se está logado novamente.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o nome'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Nova Senha (opcional)',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
