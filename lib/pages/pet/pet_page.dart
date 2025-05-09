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
  List<DocumentSnapshot> _pets = [];
  String?
      _selectedPetId; // Variável para armazenar o ID do pet selecionado para edição

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  // Carregar os pets cadastrados
  Future<void> _carregarPets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('uidDono', isEqualTo: user.uid)
          .get();

      setState(() {
        _pets = snapshot.docs;
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar os pets: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Função para salvar/editar pet
  Future<void> _salvarPet() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Usuário não autenticado.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final petData = {
        'nome': _nomeController.text.trim(),
        'raca': _racaController.text.trim(),
        'idade': int.tryParse(_idadeController.text.trim()) ?? 0,
        'observacao': _observacaoController.text.trim(),
        'uidDono': user.uid,
        'criadoEm': Timestamp.now(),
      };

      if (_selectedPetId == null) {
        // Cadastrar novo pet
        await FirebaseFirestore.instance.collection('pets').add(petData);
        _showSnackBar('Pet cadastrado com sucesso!');
      } else {
        // Editar pet existente
        await FirebaseFirestore.instance
            .collection('pets')
            .doc(_selectedPetId)
            .update(petData);
        _showSnackBar('Pet atualizado com sucesso!');
      }

      _formKey.currentState?.reset();
      _nomeController.clear();
      _racaController.clear();
      _idadeController.clear();
      _observacaoController.clear();

      _carregarPets(); // Atualizar a lista de pets após salvar
      _selectedPetId = null; // Resetar o ID do pet selecionado
    } catch (e) {
      _showSnackBar('Erro ao salvar pet: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Função para excluir pet
  Future<void> _excluirPet(String petId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este pet?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await FirebaseFirestore.instance.collection('pets').doc(petId).delete();
        _showSnackBar('Pet excluído com sucesso!');
        _carregarPets(); // Atualizar a lista após exclusão
      } catch (e) {
        _showSnackBar('Erro ao excluir pet: $e', isError: true);
      }
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
      appBar: AppBar(
        title: Text(_selectedPetId == null ? 'Cadastro de Pet' : 'Editar Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Formulário de cadastro ou edição
                  Card(
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
                            const Text('Informe os dados do pet',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                  labelText: 'Nome do pet',
                                  border: OutlineInputBorder()),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe o nome'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _racaController,
                              decoration: const InputDecoration(
                                  labelText: 'Raça',
                                  border: OutlineInputBorder()),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe a raça'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _idadeController,
                              decoration: const InputDecoration(
                                  labelText: 'Idade',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe a idade'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _observacaoController,
                              decoration: const InputDecoration(
                                  labelText: 'Observações',
                                  hintText: 'Ex: Gato persa, castrado, dócil',
                                  border: OutlineInputBorder()),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _salvarPet,
                              icon: const Icon(Icons.save),
                              label: Text(
                                  _selectedPetId == null ? 'Salvar' : 'Editar'),
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Listagem de pets cadastrados
                  const Text('Pets Cadastrados',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, index) {
                        final pet = _pets[index].data() as Map<String, dynamic>;
                        final petId = _pets[index].id;
                        return ListTile(
                          title: Text(pet['nome']),
                          subtitle:
                              Text('${pet['raca']} - ${pet['idade']} anos'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirPet(petId),
                          ),
                          onTap: () {
                            // Preencher os dados do pet para edição
                            _selectedPetId = petId;
                            _nomeController.text = pet['nome'];
                            _racaController.text = pet['raca'];
                            _idadeController.text = pet['idade'].toString();
                            _observacaoController.text = pet['observacao'];
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
