import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RelatorioPage extends StatelessWidget {
  const RelatorioPage({super.key});

  Future<Map<String, int>> _gerarRelatorio() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, int> relatorio = {
      'Banho': 0,
      'Tosa': 0,
      'Consulta': 0,
      'Confirmados': 0,
      'Pendentes': 0,
      'Concluídos': 0,
    };

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('agendamentos')
          .get();

      for (var doc in snapshot.docs) {
        final servico = doc['servico'];
        final status = doc['status'];

        // Contar serviços
        if (relatorio.containsKey(servico)) {
          relatorio[servico] = relatorio[servico]! + 1;
        }

        // Contar status
        if (relatorio.containsKey(status)) {
          relatorio[status] = relatorio[status]! + 1;
        }
      }
    }

    return relatorio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório de Agendamentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: _gerarRelatorio(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar relatório.'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum dado encontrado.'));
            }

            final relatorio = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: const Text('Agendamentos por Serviço'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Banho: ${relatorio['Banho']}'),
                      Text('Tosa: ${relatorio['Tosa']}'),
                      Text('Consulta: ${relatorio['Consulta']}'),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Agendamentos por Status'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confirmados: ${relatorio['Confirmados']}'),
                      Text('Pendentes: ${relatorio['Pendentes']}'),
                      Text('Concluídos: ${relatorio['Concluídos']}'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
