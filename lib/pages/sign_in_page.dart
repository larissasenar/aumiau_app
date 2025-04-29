import 'package:aumiau_app/pages/sing_up/sign_up_page.dart';
import 'package:aumiau_app/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _senha;

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
                onSaved: (email) => _email = email,
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
                onSaved: (senha) => _senha = senha,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      print(_email);
                      print(_senha);
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
