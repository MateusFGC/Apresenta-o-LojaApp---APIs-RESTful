import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'services/produto_service.dart';

void main() {
  runApp(const LojaApp());
}

class LojaApp extends StatelessWidget {
  const LojaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LojaApp API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProdutosScreen(),
    );
  }
}

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key}) : super(key: key);

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final ProdutoService _produtoService = ProdutoService();
  late Future<List<Produto>> _futureProdutos;

  @override
  void initState() {
    super.initState();
    // Chamamos a API no initState (jeito certo), nunca no build (jeito errado)
    _futureProdutos = _produtoService.buscarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo LojaApp')),
      body: FutureBuilder<List<Produto>>(
        future: _futureProdutos,
        builder: (context, snapshot) {
          // Cenário: Carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // Cenário: Erro (Offline, Timeout, etc)
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureProdutos = _produtoService.buscarProdutos();
                        });
                      },
                      child: const Text('Tentar Novamente'),
                    )
                  ],
                ),
              ),
            );
          } 
          // Cenário: Sucesso
          else if (snapshot.hasData) {
            final produtos = snapshot.data!;
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  leading: Image.network(produto.imagem, width: 50, height: 50, fit: BoxFit.contain),
                  title: Text(produto.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                );
              },
            );
          }
          
          return const Center(child: Text('Nenhum produto encontrado.'));
        },
      ),
    );
  }
}
