import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroPetPage extends StatefulWidget {
  const CadastroPetPage({super.key});

  @override
  State<CadastroPetPage> createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _observacaoController = TextEditingController();
  bool _isLoading = false;

  Future<void> _salvarPet() async {
    final formState = _formKey.currentState;
    // Verificação se o formulário está válido
    if (formState == null || !formState.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Usuário não autenticado.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Salvando os dados no Firestore
      await FirebaseFirestore.instance.collection('pets').add({
        'nome': _nomeController.text.trim(),
        'raca': _racaController.text.trim(),
        'idade': int.tryParse(_idadeController.text.trim()) ?? 0,
        'observacao': _observacaoController.text.trim(),
        'uidDono': user.uid,
        'criadoEm': Timestamp.now(),
      });

      // Limpando o formulário
      _formKey.currentState?.reset();
      _nomeController.clear();
      _racaController.clear();
      _idadeController.clear();
      _observacaoController.clear();

      _showSnackBar('Pet cadastrado com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao salvar pet: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Informe os dados do pet',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome do pet',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Informe o nome'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _racaController,
                            decoration: const InputDecoration(
                              labelText: 'Raça',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Informe a raça'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _idadeController,
                            decoration: const InputDecoration(
                              labelText: 'Idade',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Informe a idade'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _observacaoController,
                            decoration: const InputDecoration(
                              labelText: 'Observações',
                              hintText: 'Ex: Gato persa, castrado, dócil',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _salvarPet,
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
