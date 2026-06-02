class CategoryModel {
  final String id;
  final String name;
  final String iconKey; // Identificador para renderizar iconos nativos o de FontAwesome

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconKey': iconKey,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
      id: documentId,
      name: map['name'] ?? '',
      iconKey: map['iconKey'] ?? '',
    );
  }
}