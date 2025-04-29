import 'package:aumiau_app/core/models/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroPetPage extends StatefulWidget {
  const CadastroPetPage({super.key});

  @override
  _CadastroPetPageState createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();

  bool _isLoading = false;

  Future<void> _cadastrarPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final nome = _nomeController.text;
    final tipo = _tipoController.text;
    final idade = int.parse(_idadeController.text);
    final peso = double.parse(_pesoController.text);

    final pet = PetModel(
      nome: nome,
      tipo: tipo,
      idade: idade,
      peso: peso,
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final petRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('pets');

        await petRef.add(pet.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet cadastrado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao cadastrar o pet. Tente novamente.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pet')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Pet',
                        prefixIcon: Icon(Icons.pets),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o nome do pet'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tipoController,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Pet (Cachorro, Gato, etc.)',
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o tipo do pet'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _idadeController,
                      decoration: const InputDecoration(
                        labelText: 'Idade (em anos)',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe a idade do pet'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pesoController,
                      decoration: const InputDecoration(
                        labelText: 'Peso (em kg)',
                        prefixIcon: Icon(Icons.scale),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o peso do pet'
                          : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _cadastrarPet,
                      child: const Text('Cadastrar Pet'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
