class CreateClientDTO {
  final String? name;
  final String? telephone;
  final String? whatsapp;

  CreateClientDTO({
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
