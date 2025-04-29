import 'package:aumiau_app/pages/sing_up/sign_up_controller.dart';
import 'package:aumiau_app/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignUpController(); //toda a lógica do controller vai aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 24,
                    ),
                  ),
                  validator: (nome) =>
                      nome == null || nome.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (nome) => _controller.setNome,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      size: 24,
                    ),
                  ),
                  validator: (email) => email == null || email.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                  onSaved: (email) => _controller.setEmail,
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
                  onChanged: _controller.setSenha,
                  validator: (senha) => senha == null || senha.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                  onSaved: (senha) => _controller.setSenha,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Repita a Senha',
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 24,
                    ),
                  ),
                  obscureText: true,
                  validator: (senhaRepetida) => _controller.validaSenhaRepetida(
                    senhaRepetida,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form != null && form.validate()) {
                        form.save();
                        await _controller.criaUsuario();
                      }
                    },
                    child: const Text('Confirmar'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
