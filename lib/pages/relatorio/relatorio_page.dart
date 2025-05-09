import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  int totalAgendamentos = 0;
  int totalVacinas = 0;
  int totalPets = 0;
  int totalUsuarios = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final isAdmin = user.email == 'admin@aumiau.com';

    try {
      if (isAdmin) {
        final usuariosSnapshot =
            await FirebaseFirestore.instance.collection('usuarios').get();

        int agendamentosCount = 0;
        int vacinasCount = 0;

        for (var doc in usuariosSnapshot.docs) {
          final uid = doc.id;

          final agendamentos = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .collection('agendamentos')
              .get();
          agendamentosCount += agendamentos.docs.length;

          final vacinas = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .collection('vacinas')
              .get();
          vacinasCount += vacinas.docs.length;
        }

        final petsSnapshot =
            await FirebaseFirestore.instance.collection('pets').get();

        setState(() {
          totalAgendamentos = agendamentosCount;
          totalVacinas = vacinasCount;
          totalPets = petsSnapshot.docs.length;
          totalUsuarios = usuariosSnapshot.docs.length;
          isLoading = false;
        });
      } else {
        // Usuário normal vê apenas os próprios dados
        final agendamentosSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('agendamentos')
            .get();

        final vacinasSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('vacinas')
            .get();

        final petsSnapshot = await FirebaseFirestore.instance
            .collection('pets')
            .where('uidDono', isEqualTo: user.uid)
            .get();

        setState(() {
          totalAgendamentos = agendamentosSnapshot.docs.length;
          totalVacinas = vacinasSnapshot.docs.length;
          totalPets = petsSnapshot.docs.length;
          totalUsuarios = 1;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Erro ao carregar dados: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Geral')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildRelatorioCard(
                      'Agendamentos', totalAgendamentos, Icons.calendar_today),
                  _buildRelatorioCard('Vacinas', totalVacinas, Icons.vaccines),
                  _buildRelatorioCard('Pets', totalPets, Icons.pets),
                  _buildRelatorioCard('Usuários', totalUsuarios, Icons.person),
                ],
              ),
            ),
    );
  }

  Widget _buildRelatorioCard(String title, int total, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text('$total', style: const TextStyle(fontSize: 18)),
        onTap: () {
          Navigator.pushNamed(context, '/relatorio_detalhe',
              arguments: title.toLowerCase());
        },
      ),
    );
  }
}
