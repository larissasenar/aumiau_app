import 'package:aumiau_app/core/exceptions/email_em_uso_exception.dart';
import 'package:aumiau_app/core/exceptions/email_invalido_exception.dart';
import 'package:aumiau_app/core/exceptions/senha_fraca_exception.dart';
import 'package:aumiau_app/pages/sing_up/sign_up_controller.dart';
import 'package:aumiau_app/widgets/app_loading.dart';
import 'package:aumiau_app/widgets/app_logo.dart';
import 'package:aumiau_app/widgets/toasts/toast_utils.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignUpController();

  void _onSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        _controller.setIsLoading(true);
      });

      try {
        await _controller.criaUsuario();
        Toasts.showSuccessToast('Cadastro salvo com sucesso!');
        Navigator.of(context).pop();
      } on EmailInvalidoException {
        Toasts.showWarningToast('Email inválido!');
      } on EmailEmUsoException {
        Toasts.showWarningToast('Email já está em uso. Escolha outro.');
      } on SenhaFracaException {
        Toasts.showWarningToast('A senha deve ter pelo menos 6 caracteres');
      } catch (_) {
        Toasts.showErrorToast('Ocorreu um erro inesperado! Contate o suporte');
      } finally {
        setState(() {
          _controller.setIsLoading(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _controller.isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            child: isLoading
                ? const Center(child: AppLoading())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLogo(),
                      const SizedBox(height: 16),
                      _buildNomeField(),
                      const SizedBox(height: 16),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildSenhaField(),
                      const SizedBox(height: 16),
                      _buildRepetirSenhaField(),
                      const SizedBox(height: 16),
                      _buildConfirmarButton(),
                      const SizedBox(height: 16),
                      _buildVoltarButton(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNomeField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Nome',
          prefixIcon: Icon(Icons.person, size: 24),
        ),
        validator: (nome) =>
            nome == null || nome.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (nome) => _controller.setNome(nome!),
      );

  Widget _buildEmailField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email, size: 24),
        ),
        validator: (email) =>
            email == null || email.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (email) => _controller.setEmail(email!),
      );

  Widget _buildSenhaField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Senha',
          prefixIcon: Icon(Icons.lock, size: 24),
        ),
        obscureText: true,
        onChanged: _controller.setSenha,
        validator: (senha) =>
            senha == null || senha.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (senha) => _controller.setSenha(senha!),
      );

  Widget _buildRepetirSenhaField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Repita a Senha',
          prefixIcon: Icon(Icons.lock, size: 24),
        ),
        obscureText: true,
        validator: _controller.validaSenhaRepetida,
        onSaved: (senhaRepetida) =>
            _controller.setSenhaConfirmada(senhaRepetida!),
      );

  Widget _buildConfirmarButton() => SizedBox(
        width: 120,
        child: OutlinedButton(
          onPressed: _onSubmit,
          child: const Text('Confirmar'),
        ),
      );

  Widget _buildVoltarButton() => SizedBox(
        width: 120,
        child: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Voltar'),
        ),
      );
}
