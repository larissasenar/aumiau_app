import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RelatorioViewPage extends StatefulWidget {
  final String tipo;

  const RelatorioViewPage({super.key, required this.tipo});

  @override
  _RelatorioViewPageState createState() => _RelatorioViewPageState();
}

class _RelatorioViewPageState extends State<RelatorioViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes de ${widget.tipo}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _buscarDadosDetalhados(widget.tipo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final dados = snapshot.data ?? [];

          if (dados.isEmpty) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }

          return ListView.builder(
            itemCount: dados.length,
            itemBuilder: (context, index) {
              final item = dados[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(item['nome'] ?? 'Sem nome'),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _exibirDados(item),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _buscarDadosDetalhados(String tipo) async {
    final user = FirebaseAuth.instance.currentUser!;
    final isAdmin = user.email == 'admin@aumiau.com';
    final firestore = FirebaseFirestore.instance;
    final List<Map<String, dynamic>> resultados = [];

    if (isAdmin) {
      final usuarios = await firestore.collection('usuarios').get();

      for (var usuario in usuarios.docs) {
        final uid = usuario.id;

        final subcolecao = await firestore
            .collection('usuarios')
            .doc(uid)
            .collection(tipo)
            .get();

        for (var doc in subcolecao.docs) {
          resultados.add(doc.data());
        }
      }
    } else {
      final subcolecao = await firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection(tipo)
          .get();

      for (var doc in subcolecao.docs) {
        resultados.add(doc.data());
      }
    }

    return resultados;
  }

  List<Widget> _exibirDados(Map<String, dynamic> item) {
    List<Widget> widgets = [];

    item.forEach((key, value) {
      widgets.add(
        Text(
          '$key: $value',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      );
    });

    return widgets;
  }
}
