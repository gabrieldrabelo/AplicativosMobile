enum StatusProduto { ativo, inativo }

class Produto {
  String id;
  double precoVenda;
  String nome;
  StatusProduto status;
  String unidade; // un, cx, kg, lt, ml
  double custo;
  int quantidadeEstoque;
  String codigoBarra;

  Produto({
    required this.id,
    required this.precoVenda,
    required this.nome,
    required this.status,
    required this.unidade,
    required this.custo,
    required this.quantidadeEstoque,
    required this.codigoBarra,
  });

  // Converter de JSON para objeto
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      precoVenda: json['precoVenda'].toDouble(),
      nome: json['nome'],
      status: StatusProduto.values.byName(json['status']),
      unidade: json['unidade'],
      custo: json['custo'].toDouble(),
      quantidadeEstoque: json['quantidadeEstoque'],
      codigoBarra: json['codigoBarra'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'precoVenda': precoVenda,
      'nome': nome,
      'status': status.name,
      'unidade': unidade,
      'custo': custo,
      'quantidadeEstoque': quantidadeEstoque,
      'codigoBarra': codigoBarra,
    };
  }
}