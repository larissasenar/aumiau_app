import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl para formatação de datas

class CarteiraVacinaPage extends StatefulWidget {
  const CarteiraVacinaPage({super.key});

  @override
  State<CarteiraVacinaPage> createState() => _CarteiraVacinaPageState();
}

class _CarteiraVacinaPageState extends State<CarteiraVacinaPage> {
  final _formKey = GlobalKey<FormState>();
  final _vacinaController = TextEditingController();
  final _dataController = TextEditingController();
  final _proximaDoseController = TextEditingController();
  final _observacoesController = TextEditingController();
  bool _isLoadingAdicionar = false;

  Future<void> _adicionarVacina() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingAdicionar = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final vacina = {
          'nome': _vacinaController.text,
          'dataAplicacao': _dataController.text,
          'proximaDose': _proximaDoseController.text.isEmpty
              ? null
              : _proximaDoseController.text,
          'observacoes': _observacoesController.text,
          'timestamp': FieldValue
              .serverTimestamp(), // Adiciona um timestamp para ordenação
        };

        try {
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('vacinas')
              .add(vacina);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vacina adicionada com sucesso!')),
          );

          _vacinaController.clear();
          _dataController.clear();
          _proximaDoseController.clear();
          _observacoesController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao adicionar vacina.')),
          );
        }
      }

      setState(() {
        _isLoadingAdicionar = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _carregarVacinas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('vacinas')
          .orderBy('timestamp', descending: true) // Ordena por data de adição
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'nome': doc['nome'],
                'dataAplicacao': doc['dataAplicacao'],
                'proximaDose': doc['proximaDose'],
                'observacoes': doc['observacoes'],
              })
          .toList();
    }
    return [];
  }

  Future<void> _excluirVacina(String vacinaId) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('vacinas')
          .doc(vacinaId)
          .delete();
      setState(() {}); // Recarrega a lista após a exclusão
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vacina excluída com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir vacina.')),
      );
    }
  }

  String _formatarData(String? data) {
    if (data == null || data.isEmpty) {
      return 'Não especificada';
    }
    try {
      final parsedDate = DateFormat('yyyy-MM-dd')
          .parse(data); // Tente analisar como AAAA-MM-DD
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy')
            .parse(data); // Tente analisar como DD/MM/AAAA
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        return data; // Se não conseguir formatar, retorna a data original
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carteira de Vacinas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _vacinaController,
                        decoration: const InputDecoration(labelText: 'Vacina'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da vacina.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _dataController,
                        decoration: const InputDecoration(
                            labelText: 'Data de Aplicação (DD/MM/AAAA)'),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite a data de aplicação.';
                          }
                          try {
                            DateFormat('dd/MM/yyyy').parseStrict(value);
                          } catch (e) {
                            return 'Formato de data inválido (DD/MM/AAAA).';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _proximaDoseController,
                        decoration: const InputDecoration(
                            labelText: 'Próxima Dose (opcional, DD/MM/AAAA)'),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            try {
                              DateFormat('dd/MM/yyyy').parseStrict(value);
                            } catch (e) {
                              return 'Formato de data inválido (DD/MM/AAAA).';
                            }
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _observacoesController,
                        decoration: const InputDecoration(
                            labelText: 'Observações (opcional)'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            _isLoadingAdicionar ? null : _adicionarVacina,
                        child: _isLoadingAdicionar
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Adicionar Vacina'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Vacinas Cadastradas',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _carregarVacinas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar vacinas.'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma vacina cadastrada.'));
                }

                final vacinas = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vacinas.length,
                  itemBuilder: (context, index) {
                    final vacina = vacinas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(vacina['nome']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Aplicada em: ${_formatarData(vacina['dataAplicacao'])}'),
                            Text(
                              'Próxima Dose: ${_formatarData(vacina['proximaDose'])}',
                              style: TextStyle(
                                fontWeight: vacina['proximaDose'] != null &&
                                        vacina['proximaDose'].isNotEmpty
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: vacina['proximaDose'] != null &&
                                        vacina['proximaDose'].isNotEmpty
                                    ? Colors.blueAccent
                                    : Colors.grey[600],
                              ),
                            ),
                            if (vacina['observacoes'] != null &&
                                vacina['observacoes'].isNotEmpty)
                              Text('Observações: ${vacina['observacoes']}',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluirVacina(vacina['id']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
