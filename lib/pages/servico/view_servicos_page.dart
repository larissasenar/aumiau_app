import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicosDisponiveisPage extends StatefulWidget {
  const ServicosDisponiveisPage({super.key});

  @override
  State<ServicosDisponiveisPage> createState() => _ServicosDisponiveisPageState();
}

class _ServicosDisponiveisPageState extends State<ServicosDisponiveisPage> {
  List<Map<String, dynamic>> _servicos = [];

  Future<void> _carregarServicos() async {
    final snapshot = await FirebaseFirestore.instance.collection('servicos').get();
    setState(() {
      _servicos = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'nome': doc['nome'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serviços Disponíveis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _servicos.length,
          itemBuilder: (context, index) {
            final servico = _servicos[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(servico['nome']),
              ),
            );
          },
        ),
      ),
    );
  }
}
