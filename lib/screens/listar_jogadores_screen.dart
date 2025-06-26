import 'package:flutter/material.dart';
import '../models/jogador.dart';
import '../models/time.dart';
import '../services/api_service.dart';
import 'cadastrar_jogador_screen.dart';
import 'editar_jogador_screen.dart';

class ListarJogadoresScreen extends StatefulWidget {
  const ListarJogadoresScreen({Key? key}) : super(key: key);

  @override
  State<ListarJogadoresScreen> createState() => _ListarJogadoresScreenState();
}

class _ListarJogadoresScreenState extends State<ListarJogadoresScreen> {
  final ApiService apiService = ApiService();
  List<Jogador> jogadores = [];
  List<Time> times = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final listaJogadores = await apiService.getJogadores();
      final listaTimes = await apiService.getTimes();
      setState(() {
        jogadores = listaJogadores;
        times = listaTimes;
        carregando = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() => carregando = false);
    }
  }

  String nomeDoTime(int timeId) {
    final time = times.firstWhere(
      (t) => t.id == timeId,
      orElse: () => Time(id: 0, nome: 'Desconhecido', cidade: ''),
    );
    return time.nome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Jogadores')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jogadores.length,
              itemBuilder: (context, index) {
                final jogador = jogadores[index];
                return ListTile(
                  title: Text(jogador.nome),
                  subtitle: Text('${jogador.posicao} — ${nomeDoTime(jogador.timeId)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarJogadorScreen(jogador: jogador),
                            ),
                          );
                          carregarDados();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await apiService.deleteJogador(jogador.id);
                          carregarDados();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastrarJogadorScreen(),
            ),
          );
          carregarDados();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
