enum TipoCliente { fisica, juridica }

class Cliente {
  String id;
  String cep;
  String nome;
  String endereco;
  TipoCliente tipo;
  String bairro;
  String documento; // CPF ou CNPJ
  String cidade;
  String email;
  String uf;
  String telefone;

  Cliente({
    required this.id,
    required this.cep,
    required this.nome,
    required this.endereco,
    required this.tipo,
    required this.bairro,
    required this.documento,
    required this.cidade,
    required this.email,
    required this.uf,
    required this.telefone,
  });

  // Converter de JSON para objeto
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      cep: json['cep'],
      nome: json['nome'],
      endereco: json['endereco'],
      tipo: TipoCliente.values.byName(json['tipo']),
      bairro: json['bairro'],
      documento: json['documento'],
      cidade: json['cidade'],
      email: json['email'],
      uf: json['uf'],
      telefone: json['telefone'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cep': cep,
      'nome': nome,
      'endereco': endereco,
      'tipo': tipo.name,
      'bairro': bairro,
      'documento': documento,
      'cidade': cidade,
      'email': email,
      'uf': uf,
      'telefone': telefone,
    };
  }
}