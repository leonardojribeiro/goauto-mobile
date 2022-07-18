class ProviderModel {
  final String? id;
  final String? name;
  final String? telephone;
  final String? whatsapp;

  ProviderModel({
    this.id,
    required this.name,
    required this.telephone,
    required this.whatsapp,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id'],
      name: map['name'] ?? '',
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ProviderModel(id: $id, name: $name, telephone: $telephone, whatsapp: $whatsapp)';
  }
}
