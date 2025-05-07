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
        child: Container(
          child: _controller.isLoading
              ? Center(
                  child: AppLoading(),
                )
              : Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      const AppLogo(),
                      const SizedBox(height: 0.0),
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
                        validator: (senha) => senha == null || senha.isEmpty
                            ? 'Campo obrigatório'
                            : null,
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
                              setState(() => _controller.setIsLoading(true));

                              try {
                                final user = await _controller.fazLogin();
                                print("Login realizado com sucesso.");
                                print("ID do usuário: ${user.id}");
                                print("Nome do usuário: ${user.nome}");
                                Navigator.of(context)
                                    .pushReplacementNamed('/home');
                              } on AcessoNegadoException catch (e) {
                                // Exibindo a mensagem de erro específica para Acesso Negado
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              } on AuthException catch (e) {
                                // Exibindo a mensagem de erro para outras exceções
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              } catch (e) {
                                // Tratamento de erro genérico
                                print('Erro inesperado: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Erro inesperado')),
                                );
                              } finally {
                                setState(() => _controller.setIsLoading(false));
                              }
                            }
                          },
                          child: _controller.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: _controller.isLoading
                              ? null
                              : () {
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
      ),
    );
  }
}
