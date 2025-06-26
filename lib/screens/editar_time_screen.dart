import 'package:flutter/material.dart';
import '../models/time.dart';
import '../services/api_service.dart';

class EditarTimeScreen extends StatefulWidget {
  final Time time;

  const EditarTimeScreen({Key? key, required this.time}) : super(key: key);

  @override
  State<EditarTimeScreen> createState() => _EditarTimeScreenState();
}

class _EditarTimeScreenState extends State<EditarTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _cidadeController;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.time.nome);
    _cidadeController = TextEditingController(text: widget.time.cidade);
  }

  Future<void> _atualizarTime() async {
    if (_formKey.currentState!.validate()) {
      final timeAtualizado = Time(
        id: widget.time.id,
        nome: _nomeController.text,
        cidade: _cidadeController.text,
      );

      await apiService.updateTime(timeAtualizado);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Time')),
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
                onPressed: _atualizarTime,
                child: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
