import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart';
import '../models/usuario.dart';
import '../widgets/custom_text_field.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({Key? key}) : super(key: key);

  @override
  _UsuarioListScreenState createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final UsuarioController _controller = UsuarioController();
  List<Usuario> _usuarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    setState(() {
      _isLoading = true;
    });

    final usuarios = await _controller.getAll();

    setState(() {
      _usuarios = usuarios;
      _isLoading = false;
    });
  }

  void _showUsuarioForm({Usuario? usuario}) {
    final _formKey = GlobalKey<FormState>();
    final _idController = TextEditingController(text: usuario?.id ?? '');
    final _senhaController = TextEditingController(text: usuario?.senha ?? '');
    final _nomeController = TextEditingController(text: usuario?.nome ?? '');
    final bool isEditing = usuario != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Usuu00e1rio' : 'Novo Usuu00e1rio'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'ID',
                  controller: _idController,
                  isRequired: true,
                  enabled: !isEditing,
                ),
                CustomTextField(
                  label: 'Senha',
                  controller: _senhaController,
                  isRequired: true,
                  obscureText: true,
                ),
                CustomTextField(
                  label: 'Nome',
                  controller: _nomeController,
                  isRequired: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newUsuario = Usuario(
                  id: _idController.text,
                  senha: _senhaController.text,
                  nome: _nomeController.text,
                );

                bool success;
                if (isEditing) {
                  success = await _controller.update(newUsuario);
                } else {
                  success = await _controller.add(newUsuario);
                }

                Navigator.pop(context);

                if (success) {
                  _loadUsuarios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuu00e1rio ${isEditing ? 'atualizado' : 'adicionado'} com sucesso!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao ${isEditing ? 'atualizar' : 'adicionar'} usuu00e1rio')),
                  );
                }
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUsuario(Usuario usuario) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusu00e3o'),
        content: Text('Tem certeza que deseja excluir o usuu00e1rio ${usuario.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Excluir'),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      final success = await _controller.delete(usuario.id);

      if (success) {
        _loadUsuarios();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuu00e1rio excluu00eddo com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir usuu00e1rio')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuu00e1rios'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _usuarios.isEmpty
              ? Center(child: Text('Nenhum usuu00e1rio cadastrado'))
              : ListView.builder(
                  itemCount: _usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = _usuarios[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(usuario.nome),
                        subtitle: Text('ID: ${usuario.id}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showUsuarioForm(usuario: usuario),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUsuario(usuario),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUsuarioForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Usuu00e1rio',
      ),
    );
  }
}