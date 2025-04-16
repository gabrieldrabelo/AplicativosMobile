import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.json');
  }

  static Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString('[]');
        return [];
      }
      
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Erro ao ler arquivo: $e');
      return [];
    }
  }

  static Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    try {
      final file = await _localFile(fileName);
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Erro ao escrever arquivo: $e');
    }
  }
}