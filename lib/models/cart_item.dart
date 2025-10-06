class CartItem {
  final String id;
  final String packageId;
  final String packageName;
  final double price;
  final int guests;
  final CartItemSelections? selections;
  final double total;

  CartItem({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.price,
    required this.guests,
    this.selections,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'packageName': packageName,
      'price': price,
      'guests': guests,
      'selections': selections?.toJson(),
      'total': total,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      packageId: json['packageId'],
      packageName: json['packageName'],
      price: json['price'].toDouble(),
      guests: json['guests'],
      selections: json['selections'] != null 
          ? CartItemSelections.fromJson(json['selections'])
          : null,
      total: json['total'].toDouble(),
    );
  }

  CartItem copyWith({
    String? id,
    String? packageId,
    String? packageName,
    double? price,
    int? guests,
    CartItemSelections? selections,
    double? total,
  }) {
    return CartItem(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      price: price ?? this.price,
      guests: guests ?? this.guests,
      selections: selections ?? this.selections,
      total: total ?? this.total,
    );
  }
}

class CartItemSelections {
  final List<String>? mainDishes;
  final String? noodles;
  final String? dessertOrVegetable;

  CartItemSelections({
    this.mainDishes,
    this.noodles,
    this.dessertOrVegetable,
  });

  Map<String, dynamic> toJson() {
    return {
      'mainDishes': mainDishes,
      'noodles': noodles,
      'dessertOrVegetable': dessertOrVegetable,
    };
  }

  factory CartItemSelections.fromJson(Map<String, dynamic> json) {
    return CartItemSelections(
      mainDishes: json['mainDishes'] != null 
          ? List<String>.from(json['mainDishes'])
          : null,
      noodles: json['noodles'],
      dessertOrVegetable: json['dessertOrVegetable'],
    );
  }

  CartItemSelections copyWith({
    List<String>? mainDishes,
    String? noodles,
    String? dessertOrVegetable,
  }) {
    return CartItemSelections(
      mainDishes: mainDishes ?? this.mainDishes,
      noodles: noodles ?? this.noodles,
      dessertOrVegetable: dessertOrVegetable ?? this.dessertOrVegetable,
    );
  }
}