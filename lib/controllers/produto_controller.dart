import '../models/produto.dart';
import '../utils/file_utils.dart';

class ProdutoController {
  static const String _fileName = 'produtos';
  
  // Buscar todos os produtos
  Future<List<Produto>> getAll() async {
    final jsonList = await FileUtils.readJsonFile(_fileName);
    return jsonList.map((json) => Produto.fromJson(json)).toList();
  }
  
  // Buscar produto por ID
  Future<Produto?> getById(String id) async {
    final produtos = await getAll();
    try {
      return produtos.firstWhere((produto) => produto.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Adicionar um novo produto
  Future<bool> add(Produto produto) async {
    try {
      final produtos = await getAll();
      
      // Verificar se ju00e1 existe um produto com o mesmo ID
      if (produtos.any((p) => p.id == produto.id)) {
        return false;
      }
      
      produtos.add(produto);
      await FileUtils.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao adicionar produto: $e');
      return false;
    }
  }
  
  // Atualizar um produto existente
  Future<bool> update(Produto produto) async {
    try {
      final produtos = await getAll();
      final index = produtos.indexWhere((p) => p.id == produto.id);
      
      if (index == -1) {
        return false;
      }
      
      produtos[index] = produto;
      await FileUtils.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      return false;
    }
  }
  
  // Remover um produto
  Future<bool> delete(String id) async {
    try {
      final produtos = await getAll();
      final initialLength = produtos.length;
      
      produtos.removeWhere((p) => p.id == id);
      
      if (produtos.length == initialLength) {
        return false;
      }
      
      await FileUtils.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao remover produto: $e');
      return false;
    }
  }
  
  // Validar campos obrigatu00f3rios
  bool validarCamposObrigatorios(Produto produto) {
    return produto.id.isNotEmpty &&
           produto.nome.isNotEmpty &&
           produto.unidade.isNotEmpty &&
           produto.codigoBarra.isNotEmpty;
  }
}