import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  Future<List<Produto>> buscarProdutos() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    
    try {
      // O await pausa a função até a API responder, mas não trava o app
      final resposta = await http.get(url).timeout(const Duration(seconds: 10));

      if (resposta.statusCode == 200) {
        List<dynamic> body = jsonDecode(resposta.body);
        List<Produto> produtos = body.map((item) => Produto.fromJson(item)).toList();
        return produtos;
      } else {
        throw Exception('Falha ao carregar produtos: Status ${resposta.statusCode}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } on HttpException {
      throw Exception('Erro de rede.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
