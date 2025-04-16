import '../models/usuario.dart';
import '../utils/file_utils.dart';

class UsuarioController {
  static const String _fileName = 'usuarios';
  
  // Buscar todos os usuários
  Future<List<Usuario>> getAll() async {
    final jsonList = await FileUtils.readJsonFile(_fileName);
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  }
  
  // Buscar usuário por ID
  Future<Usuario?> getById(String id) async {
    final usuarios = await getAll();
    try {
      return usuarios.firstWhere((usuario) => usuario.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Adicionar um novo usuário
  Future<bool> add(Usuario usuario) async {
    try {
      final usuarios = await getAll();
      
      // Verificar se já existe um usuário com o mesmo ID
      if (usuarios.any((u) => u.id == usuario.id)) {
        return false;
      }
      
      usuarios.add(usuario);
      await FileUtils.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
      return false;
    }
  }
  
  // Atualizar um usuário existente
  Future<bool> update(Usuario usuario) async {
    try {
      final usuarios = await getAll();
      final index = usuarios.indexWhere((u) => u.id == usuario.id);
      
      if (index == -1) {
        return false;
      }
      
      usuarios[index] = usuario;
      await FileUtils.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
  }
  
  // Remover um usuário
  Future<bool> delete(String id) async {
    try {
      final usuarios = await getAll();
      final initialLength = usuarios.length;
      
      usuarios.removeWhere((u) => u.id == id);
      
      if (usuarios.length == initialLength) {
        return false;
      }
      
      await FileUtils.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
      return true;
    } catch (e) {
      print('Erro ao remover usuário: $e');
      return false;
    }
  }
  
  // Validar login
  Future<bool> validarLogin(String id, String senha) async {
    try {
      final usuarios = await getAll();
      
      // Se não houver usuários cadastrados, permitir acesso com admin/admin
      if (usuarios.isEmpty && id == 'admin' && senha == 'admin') {
        return true;
      }
      
      return usuarios.any((u) => u.id == id && u.senha == senha);
    } catch (e) {
      print('Erro ao validar login: $e');
      return false;
    }
  }
}