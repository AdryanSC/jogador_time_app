class Time {
  final int id;
  final String nome;
  final String cidade;

  Time({
    required this.id,
    required this.nome,
    required this.cidade,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      nome: json['nome'],
      cidade: json['cidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
    };
  }
}
