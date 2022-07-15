class ClientModel {
  final String? id;
  final String name;
  final String telephone;
  final String whatsapp;

  ClientModel({
    this.id,
    required this.name,
    required this.telephone,
    required this.whatsapp,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'] ?? '',
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ClientModel(id: $id, name: $name, telephone: $telephone, whatsapp: $whatsapp)';
  }
}
