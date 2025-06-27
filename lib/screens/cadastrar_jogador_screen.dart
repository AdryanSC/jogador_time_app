import 'package:flutter/material.dart';
import '../models/jogador.dart';
import '../models/time.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastrarJogadorScreen extends StatefulWidget {
  const CadastrarJogadorScreen({super.key});

  @override
  State<CadastrarJogadorScreen> createState() => _CadastrarJogadorScreenState();
}

class _CadastrarJogadorScreenState extends State<CadastrarJogadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
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
    carregarTimes();
    carregarUltimoJogador(); // Carrega o nome salvo ao abrir a tela
  }

  Future<void> carregarTimes() async {
    final lista = await apiService.getTimes();
    setState(() {
      times = lista;
      carregando = false;
    });
  }

  Future<void> salvarUltimoJogador(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimoJogador', nome);
  }

  Future<void> carregarUltimoJogador() async {
    final prefs = await SharedPreferences.getInstance();
    String? nome = prefs.getString('ultimoJogador');

    if (nome != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Último jogador cadastrado: $nome')),
      );
    }
  }

  Future<void> salvarJogador() async {
    if (_formKey.currentState!.validate()) {
      final novoJogador = Jogador(
        id: 0,
        nome: _nomeController.text,
        posicao: _posicaoSelecionada!,
        timeId: _timeSelecionadoId!,
      );

      await apiService.createJogador(novoJogador);
      await salvarUltimoJogador(novoJogador.nome); // Salva localmente
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Jogador')),
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
                      value: _timeSelecionadoId,
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
                      onPressed: salvarJogador,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
