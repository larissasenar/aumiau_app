import 'package:aumiau_app/core/theme.dart';
import 'package:aumiau_app/pages/home/home_page.dart';
import 'package:aumiau_app/pages/relatorio/relatorio_view_page.dart';
import 'package:aumiau_app/pages/sign_in/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Aumiau App',
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInPage(),
          '/home': (context) => const HomePage(),
          '/relatorio_detalhe': (context) {
            final tipo = ModalRoute.of(context)!.settings.arguments as String;
            return RelatorioViewPage(tipo: tipo);
          },
        },
      ),
    );
  }
}
