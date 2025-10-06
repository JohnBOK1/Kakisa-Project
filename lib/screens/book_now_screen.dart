import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../widgets/tropical_button.dart';
import '../widgets/package_card.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({super.key});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int _guests = 1;
  String? _selectedPackage;
  
  final List<Map<String, dynamic>> _packages = [
    {
      'id': 'standard',
      'name': 'Standard Package',
      'price': 400.0,
      'description': 'Perfect for casual dining with essential amenities',
      'features': [
        '2 Main Dishes',
        'Rice & Noodles',
        'Basic Setup',
        'Standard Service',
      ],
      'imageUrl': 'assets/images/Package1.jpg',
    },
    {
      'id': 'premium',
      'name': 'Premium Package',
      'price': 450.0,
      'description': 'Enhanced dining experience with premium selections',
      'features': [
        '3 Main Dishes',
        'Rice & Noodles',
        'Dessert/Vegetable',
        'Premium Setup',
      ],
       'imageUrl': 'assets/images/Package2.jpg',
    },
    {
      'id': 'deluxe',
      'name': 'Deluxe Package',
      'price': 500.0,
      'description': 'Ultimate luxury dining with exclusive amenities',
      'features': [
        '4 Main Dishes',
        'Rice & Premium Noodles',
        'Dessert & Vegetable',
        'Luxury Setup',
      ],
      'imageUrl': 'assets/images/Package3.jpg',
    },
  ];

  void _addToCart() {
    if (_selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final package = _packages.firstWhere((p) => p['id'] == _selectedPackage);
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      packageId: package['id'],
      packageName: package['name'],
      price: package['price'],
      guests: _guests,
      total: package['price'] * _guests,
    );

    context.read<CartProvider>().addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${package['name']} added to cart'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1280),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Your Experience',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select your preferred package and number of guests',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 24),

            // Guest Counter
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Number of Guests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guests > 1
                            ? () {
                                setState(() {
                                  _guests--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGradientStart,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_guests',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _guests++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Package Selection
            const Text(
              'Select Package',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // ListView inside Column needs shrinkWrap
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _packages.length,
                itemBuilder: (context, index) {
                  final package = _packages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PackageCard(
                      title: package['name'],
                      price: '₱${package['price'].toInt()}',
                      description: package['description'],
                      imageUrl: package['imageUrl'],
                      buttonText: _selectedPackage == package['id']
                          ? 'Selected'
                          : 'Select',
                      onTap: () {
                        setState(() {
                          _selectedPackage = package['id'];
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Total and Add to Cart
            if (_selectedPackage != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '₱${(_packages.firstWhere((p) => p['id'] == _selectedPackage)['price'] * _guests).toInt()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TropicalButton(
                        text: 'Add to Cart',
                        onPressed: _addToCart,
                        icon: Icons.add_shopping_cart,
                        size: TropicalButtonSize.large,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}