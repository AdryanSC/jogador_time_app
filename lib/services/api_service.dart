import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/time.dart';
import '../models/jogador.dart';

class ApiService {
  static const String baseUrl = 'https://api-jogador-time.onrender.com';


  // ---------- TIME ---------- //

  Future<List<Time>> getTimes() async {
    final response = await http.get(Uri.parse('$baseUrl/times'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Time.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar times');
    }
  }

  Future<void> createTime(Time time) async {
    await http.post(
      Uri.parse('$baseUrl/times'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(time.toJson()),
    );
  }

  Future<void> updateTime(Time time) async {
    await http.put(
      Uri.parse('$baseUrl/times/${time.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(time.toJson()),
    );
  }

  Future<void> deleteTime(int id) async {
    await http.delete(Uri.parse('$baseUrl/times/$id'));
  }

  // ---------- JOGADOR ---------- //

  Future<List<Jogador>> getJogadores() async {
    final response = await http.get(Uri.parse('$baseUrl/jogadores'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Jogador.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar jogadores');
    }
  }

  Future<void> createJogador(Jogador jogador) async {
    await http.post(
      Uri.parse('$baseUrl/jogadores'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jogador.toJson()),
    );
  }

  Future<void> updateJogador(Jogador jogador) async {
    await http.put(
      Uri.parse('$baseUrl/jogadores/${jogador.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jogador.toJson()),
    );
  }

  Future<void> deleteJogador(int id) async {
    await http.delete(Uri.parse('$baseUrl/jogadores/$id'));
  }
}
