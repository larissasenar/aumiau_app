class UsuarioModel {
  String id;
  String nome;
  String email;
  String tipo;

  // Construtor
  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  // Método para criar um UsuarioModel a partir de um Map
  UsuarioModel.fromJson(String userId, Map<String, dynamic> json)
      : id = userId,
        nome = json['nome'] ?? '', // Valor padrão caso 'nome' seja nulo
        email = json['email'] ?? '', // Valor padrão caso 'email' seja nulo
        tipo = json['tipo'] ?? ''; // Valor padrão caso 'tipo' seja nulo

  // Método para converter UsuarioModel de volta para Map (útil para salvar no Firestore)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'tipo': tipo,
    };
  }
}
