class CreateProviderDTO {
  final String? name;
  final String? telephone;
  final String? whatsapp;

  CreateProviderDTO({
    this.name,
    this.telephone,
    this.whatsapp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'telephone': telephone,
      'whatsapp': whatsapp,
    };
  }
}
