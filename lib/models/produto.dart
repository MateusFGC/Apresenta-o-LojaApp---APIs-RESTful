class Produto {
  final int id;
  final String titulo;
  final double preco;
  final String imagem;

  Produto({required this.id, required this.titulo, required this.preco, required this.imagem});

  // Converte o mapa JSON em um objeto Produto
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      titulo: json['title'],
      preco: json['price'].toDouble(),
      imagem: json['image'],
    );
  }
}
