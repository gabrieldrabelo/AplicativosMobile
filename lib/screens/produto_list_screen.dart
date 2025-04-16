import 'package:flutter/material.dart';
import '../controllers/produto_controller.dart';
import '../models/produto.dart';
import '../widgets/custom_text_field.dart';

class ProdutoListScreen extends StatefulWidget {
  const ProdutoListScreen({Key? key}) : super(key: key);

  @override
  _ProdutoListScreenState createState() => _ProdutoListScreenState();
}

class _ProdutoListScreenState extends State<ProdutoListScreen> {
  final ProdutoController _controller = ProdutoController();
  List<Produto> _produtos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    setState(() {
      _isLoading = true;
    });

    final produtos = await _controller.getAll();

    setState(() {
      _produtos = produtos;
      _isLoading = false;
    });
  }

  void _showProdutoForm({Produto? produto}) {
    final _formKey = GlobalKey<FormState>();
    final _idController = TextEditingController(text: produto?.id ?? '');
    final _nomeController = TextEditingController(text: produto?.nome ?? '');
    final _precoVendaController =
        TextEditingController(text: produto?.precoVenda.toString() ?? '0.0');
    final _custoController =
        TextEditingController(text: produto?.custo.toString() ?? '0.0');
    final _quantidadeEstoqueController = TextEditingController(
        text: produto?.quantidadeEstoque.toString() ?? '0');
    final _codigoBarraController =
        TextEditingController(text: produto?.codigoBarra ?? '');

    StatusProduto _status = produto?.status ?? StatusProduto.ativo;
    String _unidade = produto?.unidade ?? 'un';
    final bool isEditing = produto != null;

    final List<String> _unidades = ['un', 'cx', 'kg', 'lt', 'ml'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
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
                  CustomTextField(
                    label: 'Código de Barra',
                    controller: _codigoBarraController,
                    isRequired: true,
                  ),
                  CustomTextField(
                    label: 'Preço de Venda',
                    controller: _precoVendaController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o preço de venda';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Informe um valor valido';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Custo',
                    controller: _custoController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o custo';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Informe um valor de Venda';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Quantidade em Estoque',
                    controller: _quantidadeEstoqueController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Informe um valor de Venda';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Unidade *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    value: _unidade,
                    items: _unidades.map((String unidade) {
                      return DropdownMenuItem<String>(
                        value: unidade,
                        child: Text(unidade),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _unidade = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a unidade';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<StatusProduto>(
                          title: Text('Ativo'),
                          value: StatusProduto.ativo,
                          groupValue: _status,
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<StatusProduto>(
                          title: Text('Inativo'),
                          value: StatusProduto.inativo,
                          groupValue: _status,
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                      ),
                    ],
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
                  final newProduto = Produto(
                    id: _idController.text,
                    nome: _nomeController.text,
                    precoVenda: double.parse(_precoVendaController.text),
                    custo: double.parse(_custoController.text),
                    quantidadeEstoque:
                        int.parse(_quantidadeEstoqueController.text),
                    codigoBarra: _codigoBarraController.text,
                    status: _status,
                    unidade: _unidade,
                  );

                  bool success;
                  if (isEditing) {
                    success = await _controller.update(newProduto);
                  } else {
                    success = await _controller.add(newProduto);
                  }

                  Navigator.pop(context);

                  if (success) {
                    _loadProdutos();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Produto ${isEditing ? 'atualizado' : 'adicionado'} com sucesso!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Erro ao ${isEditing ? 'atualizar' : 'adicionar'} produto')),
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

  Future<void> _deleteProduto(Produto produto) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar excluir'),
            content: Text(
                'Tem certeza que deseja excluir o produto ${produto.nome}?'),
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
        ) ??
        false;

    if (confirmed) {
      final success = await _controller.delete(produto.id);

      if (success) {
        _loadProdutos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto excluido com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir produto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? Center(child: Text('Nenhum produto cadastrado'))
              : ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(produto.nome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Preu00e7o: R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
                            Text(
                                'Estoque: ${produto.quantidadeEstoque} ${produto.unidade}'),
                            Text(
                                'Status: ${produto.status == StatusProduto.ativo ? 'Ativo' : 'Inativo'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showProdutoForm(produto: produto),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduto(produto),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProdutoForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}
