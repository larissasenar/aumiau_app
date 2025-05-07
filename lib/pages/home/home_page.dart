import 'package:aumiau_app/pages/servico/servicos_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aumiau_app/pages/agendamento/agendamento_page.dart';
import 'package:aumiau_app/pages/carteira_vacina/carteira_vacina_page.dart';
import 'package:aumiau_app/pages/historico/historico_page.dart';
import 'package:aumiau_app/pages/perfil/perfil_page.dart';
import 'package:aumiau_app/pages/pet/pet_page.dart';
import 'package:aumiau_app/pages/relatorio/relatorio_page.dart';
import 'package:aumiau_app/pages/sign_in/sign_in_page.dart';

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
    if (mounted) {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = user?.displayName ?? "Usuário";

    return Scaffold(
      appBar: AppBar(
        title: const Text('AuMiau'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(nomeUsuario),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.pets, color: Theme.of(context).primaryColor),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            _drawerItem(Icons.person, 'Perfil', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PerfilPage()));
            }),
            _drawerItem(Icons.add, 'Cadastrar Pet', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CadastroPetPage()));
            }),
            _drawerItem(Icons.pets, 'Serviços', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ServicosPage()));
            }),
            _drawerItem(Icons.calendar_today, 'Agendamento', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AgendamentoPage()));
            }),
            _drawerItem(Icons.history, 'Histórico', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoricoPage()));
            }),
            _drawerItem(Icons.bar_chart, 'Relatório', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RelatorioPage()));
            }),
            _drawerItem(Icons.vaccines, 'Carteira de Vacina', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CarteiraVacinaPage()));
            }),
            const Divider(),
            _drawerItem(Icons.logout, 'Sair', () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SignInPage()));
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${getGreeting()}, $nomeUsuario!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Seja bem-vindo(a) de volta!',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 24),
            const Text('Acesso Rápido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _quickAccessTile(
                    context,
                    icon: Icons.pets,
                    label: 'Serviços',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ServicosPage())),
                  ),
                  _quickAccessTile(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Agendar',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AgendamentoPage())),
                  ),
                  _quickAccessTile(
                    context,
                    icon: Icons.vaccines,
                    label: 'Vacinas',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CarteiraVacinaPage())),
                  ),
                  _quickAccessTile(
                    context,
                    icon: Icons.add,
                    label: 'Novo Pet',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CadastroPetPage())),
                  ),
                  _quickAccessTile(
                    context,
                    icon: Icons.history,
                    label: 'Histórico',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoricoPage())),
                  ),
                  _quickAccessTile(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Relatório',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RelatorioPage())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessTile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Material(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
