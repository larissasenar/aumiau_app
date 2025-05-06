import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _servicos = [];

  Future<void> _carregarServicos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('servicos').get();
    setState(() {
      _servicos = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'nome': doc['nome'],
        };
      }).toList();
    });
  }

  Future<void> _adicionarServico() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() => _isLoading = true);

    try {
      final nomeServico = _nomeController.text.trim();

      await FirebaseFirestore.instance.collection('servicos').add({
        'nome': nomeServico,
        'criadoEm': Timestamp.now(),
      });

      _nomeController.clear();
      _showSnackBar('Serviço cadastrado com sucesso!');
      _carregarServicos();
    } catch (e) {
      _showSnackBar('Erro ao salvar serviço: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletarServico(String id) async {
    try {
      await FirebaseFirestore.instance.collection('servicos').doc(id).delete();
      _showSnackBar('Serviço excluído com sucesso!');
      _carregarServicos();
    } catch (e) {
      _showSnackBar('Erro ao excluir serviço: $e', isError: true);
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
  void initState() {
    super.initState();
    _carregarServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Serviços')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                              const Text(
                                'Adicionar Novo Serviço',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome do serviço',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Informe o nome do serviço'
                                        : null,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _adicionarServico,
                                icon: const Icon(Icons.save),
                                label: const Text('Salvar'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Serviços Cadastrados',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _servicos.length,
                      itemBuilder: (context, index) {
                        final servico = _servicos[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(servico['nome']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletarServico(servico['id']),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
