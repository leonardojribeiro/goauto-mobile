class ClientModel {
  final String? id;
  final String? name;
  final String? telephone;
  final String? whatsapp;

  ClientModel({
    this.id,
    this.name,
    this.telephone,
    this.whatsapp,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      telephone: map['telephone'],
      whatsapp: map['whatsapp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'telephone': telephone,
      'whatsapp': whatsapp,
    };
  }

  @override
  String toString() {
    return 'ClientModel(id: $id, name: $name, telephone: $telephone, whatsapp: $whatsapp)';
  }
}
