import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  CartItem? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  int get itemCount => _items.length;

  int get totalGuests {
    return _items.fold(0, (total, item) => total + item.guests);
  }

  double get totalPrice {
    return _items.fold(0.0, (total, item) => total + item.total);
  }

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

double get totalAmount => _items.fold(0, (sum, item) => sum + item.total);

    void updateItemGuests(String id, int newGuests) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1 && newGuests > 0) {
      final item = _items[index];
      final updatedItem = item.copyWith(
        guests: newGuests,
        total: item.price * newGuests, // recalc total
      );
      _items[index] = updatedItem;
      notifyListeners();
    }
  }
}