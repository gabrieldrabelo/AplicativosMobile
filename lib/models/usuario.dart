class Usuario {
  String id;
  String senha;
  String nome;

  Usuario({required this.id, required this.senha, required this.nome});

  // Converter de JSON para objeto
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      senha: json['senha'],
      nome: json['nome'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senha': senha,
      'nome': nome,
    };
  }
}