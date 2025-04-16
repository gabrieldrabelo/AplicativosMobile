import '../models/cliente.dart';
import '../utils/file_utils.dart';

class ClienteController {
  static const String _fileName = 'clientes';
  
  Future<List<Cliente>> getAll() async {
    final jsonList = await FileUtils.readJsonFile(_fileName);
    return jsonList.map((json) => Cliente.fromJson(json)).toList();
  }
  
  Future<Cliente?> getById(String id) async {
    final clientes = await getAll();
    try {
      return clientes.firstWhere((cliente) => cliente.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> add(Cliente cliente) async {
    try {
      final clientes = await getAll();
      
      if (clientes.any((c) => c.id == cliente.id)) {
        return false;
      }
      
      clientes.add(cliente);
      await FileUtils.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao adicionar cliente: $e');
      return false;
    }
  }
  
  Future<bool> update(Cliente cliente) async {
    try {
      final clientes = await getAll();
      final index = clientes.indexWhere((c) => c.id == cliente.id);
      
      if (index == -1) {
        return false;
      }
      
      clientes[index] = cliente;
      await FileUtils.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao atualizar cliente: $e');
      return false;
    }
  }
  
  Future<bool> delete(String id) async {
    try {
      final clientes = await getAll();
      final initialLength = clientes.length;
      
      clientes.removeWhere((c) => c.id == id);
      
      if (clientes.length == initialLength) {
        return false;
      }
      
      await FileUtils.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao remover cliente: $e');
      return false;
    }
  }
  
  bool validarCamposObrigatorios(Cliente cliente) {
    return cliente.id.isNotEmpty &&
           cliente.nome.isNotEmpty &&
           cliente.documento.isNotEmpty &&
           cliente.telefone.isNotEmpty;
  }
}