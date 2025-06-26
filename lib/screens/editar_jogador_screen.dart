import 'package:flutter/material.dart';
import '../models/jogador.dart';
import '../models/time.dart';
import '../services/api_service.dart';

class EditarJogadorScreen extends StatefulWidget {
  final Jogador jogador;

  const EditarJogadorScreen({super.key, required this.jogador});

  @override
  State<EditarJogadorScreen> createState() => _EditarJogadorScreenState();
}

class _EditarJogadorScreenState extends State<EditarJogadorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  String? _posicaoSelecionada;
  int? _timeSelecionadoId;

  final ApiService apiService = ApiService();
  List<Time> times = [];
  bool carregando = true;

  final List<String> posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meio-Campo',
    'Ponta Direita',
    'Ponta Esquerda',
    'Atacante',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.jogador.nome);
    _posicaoSelecionada = widget.jogador.posicao;
    _timeSelecionadoId = widget.jogador.timeId;
    carregarTimes();
  }

  Future<void> carregarTimes() async {
    final lista = await apiService.getTimes();
    setState(() {
      times = lista;
      carregando = false;
    });
  }

  Future<void> salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      final jogadorAtualizado = Jogador(
        id: widget.jogador.id,
        nome: _nomeController.text,
        posicao: _posicaoSelecionada!,
        timeId: _timeSelecionadoId!,
      );

      await apiService.updateJogador(jogadorAtualizado);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Jogador')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome do Jogador'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Digite o nome' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _posicaoSelecionada,
                      decoration: const InputDecoration(labelText: 'Posição'),
                      items: posicoes.map((pos) {
                        return DropdownMenuItem(value: pos, child: Text(pos));
                      }).toList(),
                      onChanged: (value) => setState(() => _posicaoSelecionada = value),
                      validator: (value) => value == null ? 'Selecione a posição' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: times.any((t) => t.id == _timeSelecionadoId)
                          ? _timeSelecionadoId
                          : null,
                      decoration: const InputDecoration(labelText: 'Time'),
                      items: times.map((time) {
                        return DropdownMenuItem(
                          value: time.id,
                          child: Text(time.nome),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _timeSelecionadoId = value),
                      validator: (value) => value == null ? 'Selecione o time' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: salvarAlteracoes,
                      child: const Text('Salvar alterações'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
