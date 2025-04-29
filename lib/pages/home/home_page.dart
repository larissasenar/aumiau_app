import 'package:aumiau_app/pages/agendamento/agendamento_page.dart';
import 'package:aumiau_app/pages/perfil/perfil_page.dart';
import 'package:aumiau_app/pages/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = user?.displayName ?? "Usuário";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Bem-vindo, $nomeUsuario!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PerfilPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Agendamento'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AgendamentoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Relatório'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.vaccines),
              title: const Text('Carteira de Vacina'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo(a), $nomeUsuario!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
