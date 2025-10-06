enum PackageType { catering, venue, accommodation }

class PackageModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final PackageType type;
  final bool perPerson;
  final int? packageVariant; // 1, 2, or 3 for catering packages

  const PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.type,
    this.perPerson = false,
    this.packageVariant,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'type': type.toString(),
      'perPerson': perPerson,
      'packageVariant': packageVariant,
    };
  }

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: PackageType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      perPerson: json['perPerson'] ?? false,
      packageVariant: json['packageVariant'],
    );
  }
}