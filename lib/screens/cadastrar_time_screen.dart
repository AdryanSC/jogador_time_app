import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/time.dart';
import '../services/api_service.dart';

class CadastrarTimeScreen extends StatefulWidget {
  const CadastrarTimeScreen({Key? key}) : super(key: key);

  @override
  State<CadastrarTimeScreen> createState() => _CadastrarTimeScreenState();
}

class _CadastrarTimeScreenState extends State<CadastrarTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  final ApiService apiService = ApiService();

  Future<void> _salvarUltimoTime(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimoTime', nome);
  }

  Future<void> _salvarTime() async {
    if (_formKey.currentState!.validate()) {
      final novoTime = Time(
        id: 0,
        nome: _nomeController.text,
        cidade: _cidadeController.text,
      );

      await apiService.createTime(novoTime);

      // Salva o nome do time localmente
      await _salvarUltimoTime(novoTime.nome);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CADASTRAR TIME')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Time'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a cidade' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarTime,
                child: const Text('SALVAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
