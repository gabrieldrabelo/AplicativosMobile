import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../models/cliente.dart';
import '../widgets/custom_text_field.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({Key? key}) : super(key: key);

  @override
  _ClienteListScreenState createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  final ClienteController _controller = ClienteController();
  List<Cliente> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    setState(() {
      _isLoading = true;
    });

    final clientes = await _controller.getAll();

    setState(() {
      _clientes = clientes;
      _isLoading = false;
    });
  }

  void _showClienteForm({Cliente? cliente}) {
    final _formKey = GlobalKey<FormState>();
    final _idController = TextEditingController(text: cliente?.id ?? '');
    final _nomeController = TextEditingController(text: cliente?.nome ?? '');
    final _cepController = TextEditingController(text: cliente?.cep ?? '');
    final _enderecoController = TextEditingController(text: cliente?.endereco ?? '');
    final _bairroController = TextEditingController(text: cliente?.bairro ?? '');
    final _cidadeController = TextEditingController(text: cliente?.cidade ?? '');
    final _ufController = TextEditingController(text: cliente?.uf ?? '');
    final _documentoController = TextEditingController(text: cliente?.documento ?? '');
    final _emailController = TextEditingController(text: cliente?.email ?? '');
    final _telefoneController = TextEditingController(text: cliente?.telefone ?? '');
    
    TipoCliente _tipoCliente = cliente?.tipo ?? TipoCliente.fisica;
    final bool isEditing = cliente != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Editar Cliente' : 'Novo Cliente'),
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
                    label: 'Nome',
                    controller: _nomeController,
                    isRequired: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<TipoCliente>(
                          title: Text('Fu00edsica'),
                          value: TipoCliente.fisica,
                          groupValue: _tipoCliente,
                          onChanged: (value) {
                            setState(() {
                              _tipoCliente = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TipoCliente>(
                          title: Text('Juru00eddica'),
                          value: TipoCliente.juridica,
                          groupValue: _tipoCliente,
                          onChanged: (value) {
                            setState(() {
                              _tipoCliente = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    label: _tipoCliente == TipoCliente.fisica ? 'CPF' : 'CNPJ',
                    controller: _documentoController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: 'CEP',
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: 'Endereu00e7o',
                    controller: _enderecoController,
                  ),
                  CustomTextField(
                    label: 'Bairro',
                    controller: _bairroController,
                  ),
                  CustomTextField(
                    label: 'Cidade',
                    controller: _cidadeController,
                  ),
                  CustomTextField(
                    label: 'UF',
                    controller: _ufController,
                  ),
                  CustomTextField(
                    label: 'E-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    label: 'Telefone',
                    controller: _telefoneController,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
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
                  final newCliente = Cliente(
                    id: _idController.text,
                    nome: _nomeController.text,
                    tipo: _tipoCliente,
                    documento: _documentoController.text,
                    cep: _cepController.text,
                    endereco: _enderecoController.text,
                    bairro: _bairroController.text,
                    cidade: _cidadeController.text,
                    uf: _ufController.text,
                    email: _emailController.text,
                    telefone: _telefoneController.text,
                  );

                  bool success;
                  if (isEditing) {
                    success = await _controller.update(newCliente);
                  } else {
                    success = await _controller.add(newCliente);
                  }

                  Navigator.pop(context);

                  if (success) {
                    _loadClientes();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cliente ${isEditing ? 'atualizado' : 'adicionado'} com sucesso!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao ${isEditing ? 'atualizar' : 'adicionar'} cliente')),
                    );
                  }
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCliente(Cliente cliente) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusu00e3o'),
        content: Text('Tem certeza que deseja excluir o cliente ${cliente.nome}?'),
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
      final success = await _controller.delete(cliente.id);

      if (success) {
        _loadClientes();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente excluu00eddo com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir cliente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
              ? Center(child: Text('Nenhum cliente cadastrado'))
              : ListView.builder(
                  itemCount: _clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = _clientes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(cliente.nome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${cliente.tipo == TipoCliente.fisica ? 'CPF' : 'CNPJ'}: ${cliente.documento}'),
                            Text('Telefone: ${cliente.telefone}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showClienteForm(cliente: cliente),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCliente(cliente),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClienteForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Cliente',
      ),
    );
  }
}