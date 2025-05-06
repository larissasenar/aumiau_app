import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String? _servicoSelecionado;
  String? _petSelecionado;
  bool _isLoading = false;

  final List<String> _servicos = ['Banho', 'Tosa', 'Consulta', 'Vacina'];
  List<String> _pets = [];

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  Future<void> _carregarPets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('pets')
        .where('uidDono', isEqualTo: user.uid)
        .get();

    setState(() {
      _pets = snapshot.docs
          .map((doc) => doc['nome'] as String)
          .toSet() // Remove duplicatas
          .toList();
      // Se houver pets, define o primeiro como selecionado por padrão
      _petSelecionado = _pets.isNotEmpty ? _pets[0] : null;
    });
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  Future<void> _salvarAgendamento() async {
    if (!_formKey.currentState!.validate() ||
        _dataSelecionada == null ||
        _horaSelecionada == null ||
        _petSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado.');

      final dataHora = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );

      // 🔄 Correção: salvar na subcoleção correta
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('agendamentos')
          .add({
        'usuarioId': user.uid,
        'nomeUsuario': user.displayName ?? '',
        'dataHora': dataHora,
        'servico': _servicoSelecionado,
        'pet': _petSelecionado,
        'status': 'PENDENTE',
        'criadoEm': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento realizado com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao agendar. Tente novamente.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Campo de seleção do Pet
                    if (_pets.isEmpty)
                      const Center(child: Text('Nenhum pet cadastrado.'))
                    else
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Selecione o Pet',
                          prefixIcon: Icon(Icons.pets),
                        ),
                        value: _petSelecionado,
                        items: _pets
                            .map((pet) => DropdownMenuItem(
                                  value: pet,
                                  child: Text(pet),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _petSelecionado = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Selecione um pet' : null,
                      ),
                    const SizedBox(height: 16),

                    // Campo de seleção do serviço
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Serviço',
                        prefixIcon: Icon(Icons.pets),
                      ),
                      value: _servicoSelecionado,
                      items: _servicos
                          .map((servico) => DropdownMenuItem(
                                value: servico,
                                child: Text(servico),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _servicoSelecionado = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um serviço' : null,
                    ),
                    const SizedBox(height: 16),

                    // Campo de seleção de data
                    ListTile(
                      title: Text(_dataSelecionada == null
                          ? 'Selecione uma data'
                          : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selecionarData,
                    ),
                    // Campo de seleção de hora
                    ListTile(
                      title: Text(_horaSelecionada == null
                          ? 'Selecione um horário'
                          : 'Horário: ${_horaSelecionada!.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: _selecionarHora,
                    ),
                    const SizedBox(height: 32),
                    // Botão para salvar o agendamento
                    ElevatedButton(
                      onPressed: _salvarAgendamento,
                      child: const Text('Agendar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
