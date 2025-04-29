import 'package:aumiau_app/pages/sign_in/sign_in_controller.dart';
import 'package:aumiau_app/pages/sing_up/sign_up_page.dart';
import 'package:aumiau_app/widgets/app_logo.dart';
import 'package:aumiau_app/widgets/toasts/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:aumiau_app/core/exceptions/auth_exceptions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    size: 24,
                  ),
                ),
                validator: (email) =>
                    email == null || email.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (email) => _controller.setEmail(email!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 24,
                  ),
                ),
                obscureText: true,
                validator: (senha) =>
                    senha == null || senha.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (senha) => _controller.setSenha(senha!),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      try {
                        final user = await _controller.fazLogin();
                        print(user.email);
                        // navegar para a próxima tela
                        Navigator.of(context).pushNamed('/home');
                      } on AuthException catch (e) {
                        print('Erro ao fazer login: ${e.message}');
                        Toasts.showErrorToast(e.message);
                      }
                    }
                  },
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
