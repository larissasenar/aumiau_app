import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  String _statusSelecionado = 'Todos';

  Future<List<Map<String, dynamic>>> _carregarHistorico() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('agendamentos')
        .orderBy('dataHora', descending: true)
        .get(const GetOptions(source: Source.server));

    final dados = snapshot.docs.map((doc) {
      final dataHora = doc['dataHora'] as Timestamp?;
      return {
        'id': doc.id,
        'dataHora': dataHora?.toDate(),
        'servico': doc['servico'],
        'status': doc['status'],
      };
    }).toList();

    if (_statusSelecionado != 'Todos') {
      return dados
          .where((item) => item['status'] == _statusSelecionado.toUpperCase())
          .toList();
    }

    return dados;
  }

  IconData _iconeDoServico(String servico) {
    switch (servico) {
      case 'Banho':
        return Icons.shower;
      case 'Tosa':
        return Icons.content_cut;
      case 'Consulta':
        return Icons.medical_services;
      case 'Vacina':
        return Icons.vaccines;
      default:
        return Icons.pets;
    }
  }

  Future<void> _atualizarStatus(String id, String novoStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('agendamentos')
        .doc(id)
        .update({'status': novoStatus});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Agendamentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _statusSelecionado,
              isExpanded: true,
              items: ['Todos', 'PENDENTE', 'CONCLUIDO', 'CANCELADO']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _statusSelecionado = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _carregarHistorico(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar histórico.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum agendamento encontrado.'));
                  }

                  final agendamentos = snapshot.data!;
                  return ListView.builder(
                    itemCount: agendamentos.length,
                    itemBuilder: (context, index) {
                      final agendamento = agendamentos[index];
                      final dataHora = agendamento['dataHora'] as DateTime?;
                      final dataFormatada = dataHora != null
                          ? '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} - ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}'
                          : 'Data desconhecida';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            _iconeDoServico(agendamento['servico']),
                            color: Colors.blue,
                          ),
                          title: Text('Serviço: ${agendamento['servico']}'),
                          subtitle: Text(
                            'Data e hora: $dataFormatada\nStatus: ${agendamento['status']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                tooltip: 'Marcar como concluído',
                                onPressed: () {
                                  _atualizarStatus(
                                      agendamento['id'], 'CONCLUIDO');
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                tooltip: 'Cancelar agendamento',
                                onPressed: () {
                                  _atualizarStatus(
                                      agendamento['id'], 'CANCELADO');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
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
