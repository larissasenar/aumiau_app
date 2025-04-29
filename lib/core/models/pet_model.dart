class PetModel {
  final String nome;
  final String tipo;
  final int idade;
  final double peso;

  PetModel({
    required this.nome,
    required this.tipo,
    required this.idade,
    required this.peso,
  });

  // Método para converter PetModel em um mapa, para armazenar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
      'idade': idade,
      'peso': peso,
    };
  }

  // Método para criar um PetModel a partir dos dados no Firestore
  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      nome: map['nome'],
      tipo: map['tipo'],
      idade: map['idade'],
      peso: map['peso'],
    );
  }
}
