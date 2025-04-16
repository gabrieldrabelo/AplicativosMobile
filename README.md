# Aplicativo de Força de Vendas em Flutter

Este é um aplicativo de Força de Vendas desenvolvido em Flutter, que permite o gerenciamento de usuários, clientes e produtos.

## Funcionalidades

- **Tela de Login**: Autenticação de usuários com validação.
- **Tela Principal**: Menu de navegação para as demais funcionalidades.
- **Cadastro de Usuários**: CRUD completo para gerenciamento de usuários.
- **Cadastro de Clientes**: CRUD completo para gerenciamento de clientes.
- **Cadastro de Produtos**: CRUD completo para gerenciamento de produtos.

## Estrutura do Projeto

- **models/**: Classes de modelo para as entidades (Usuário, Cliente, Produto).
- **controllers/**: Controladores para gerenciar a lógica de negócios.
- **screens/**: Telas do aplicativo.
- **utils/**: Utilitários e funções auxiliares.
- **widgets/**: Widgets reutilizáveis.

## Regras de Negócio

- Campos obrigatórios são validados antes de salvar os dados.
- Os dados são persistidos em arquivos JSON.
- Caso não haja usuários cadastrados, é possível acessar com o usuário "admin" e senha "admin".

## Como Executar

1. Certifique-se de ter o Flutter instalado e configurado em seu ambiente.
2. Clone este repositório.
3. Execute `flutter pub get` para baixar as dependências.
4. Execute `flutter run` para iniciar o aplicativo.

## Tecnologias Utilizadas

- Flutter
- Dart
- Persistência de dados em JSON

## Entidades

### Usuário
- ID
- Senha
- Nome

### Cliente
- ID
- CEP
- Nome
- Endereço
- Tipo (Física/Jurídica)
- Bairro
- CPF/CNPJ
- Cidade
- E-mail
- UF
- Telefone

### Produto
- ID
- Preço de Venda
- Nome
- Status (Ativo/Inativo)
- Unidade (un, cx, kg, lt, ml)
- Custo
- Quantidade em Estoque
- Código de Barra