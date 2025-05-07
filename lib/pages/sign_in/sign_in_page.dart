import 'package:aumiau_app/pages/sign_in/sign_in_controller.dart';
import 'package:aumiau_app/pages/sing_up/sign_up_page.dart';
import 'package:aumiau_app/widgets/app_loading.dart';
import 'package:aumiau_app/widgets/app_logo.dart';
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const AppLogo(),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (email) =>
                    email == null || email.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (email) => _controller.setEmail(email!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (senha) =>
                    senha == null || senha.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (senha) => _controller.setSenha(senha!),
              ),
              const SizedBox(height: 24),
              _controller.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: loginFunction,
                            child: const Text('Entrar'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const SignUpPage()));
                            },
                            child: const Text('Cadastrar'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
