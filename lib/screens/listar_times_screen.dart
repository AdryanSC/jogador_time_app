import 'package:flutter/material.dart';
import '../models/time.dart';
import '../services/api_service.dart';
import 'cadastrar_time_screen.dart';
import 'editar_time_screen.dart';

class ListarTimesScreen extends StatefulWidget {
  const ListarTimesScreen({Key? key}) : super(key: key);

  @override
  _ListarTimesScreenState createState() => _ListarTimesScreenState();
}

class _ListarTimesScreenState extends State<ListarTimesScreen> {
  final ApiService apiService = ApiService();
  List<Time> listaTimes = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarTimes();
  }

  Future<void> carregarTimes() async {
    try {
      final times = await apiService.getTimes();
      setState(() {
        listaTimes = times;
        carregando = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Times')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaTimes.length,
              itemBuilder: (context, index) {
                final time = listaTimes[index];
                return ListTile(
                  title: Text(time.nome),
                  subtitle: Text(time.cidade),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarTimeScreen(time: time),
                            ),
                          );
                          carregarTimes();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await apiService.deleteTime(time.id);
                          carregarTimes();
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
              builder: (_) => const CadastrarTimeScreen(),
            ),
          );
          carregarTimes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
