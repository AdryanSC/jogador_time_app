class Jogador {
  final int id;
  final String nome;
  final String posicao;
  final int timeId;

  Jogador({
    required this.id,
    required this.nome,
    required this.posicao,
    required this.timeId,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      id: json['id'],
      nome: json['nome'],
      posicao: json['posicao'],
      timeId: json['timeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'posicao': posicao,
      'timeId': timeId,
    };
  }
}
