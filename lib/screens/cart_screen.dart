import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/cart_provider.dart';
import '../widgets/tropical_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: AppColors.grey400,
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add some packages to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundGradientStart,
          appBar: AppBar(
            title: const Text("My Cart"),
            backgroundColor: AppColors.primary,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Cart Summary
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${cart.itemCount} Items',
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.grey600)),
                        Text('${cart.totalGuests} Guests',
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.grey600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.grey600)),
                        Text(
                          '₱${cart.totalAmount.toInt()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Cart Items
              ...cart.items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // item header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.packageName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cart.removeItem(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Item removed from cart'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // item details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.guests} guests',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.grey600,
                            ),
                          ),
                          Text(
                            '₱${item.price.toInt()} per person',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: item.guests > 1
                                    ? () {
                                        cart.updateItemGuests(
                                            item.id, item.guests - 1);
                                      }
                                    : null,
                                icon:
                                    const Icon(Icons.remove_circle_outline),
                                color: AppColors.primary,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGradientStart,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.guests}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cart.updateItemGuests(
                                      item.id, item.guests + 1);
                                },
                                icon:
                                    const Icon(Icons.add_circle_outline),
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          Text(
                            '₱${item.total.toInt()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),

          // ✅ Bottom bar moved here
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.borderColor),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  // 📱 Small screen: stack buttons vertically
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TropicalButton(
                        text: 'Clear Cart',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear Cart'),
                              content: const Text(
                                  'Are you sure you want to remove all items from your cart?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.clearCart();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text('Cart cleared'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  },
                                  child: const Text('Clear',
                                      style: TextStyle(
                                          color: AppColors.error)),
                                ),
                              ],
                            ),
                          );
                        },
                        backgroundColor: AppColors.grey500,
                      ),
                      const SizedBox(height: 12),
                      TropicalButton(
                        text: 'Proceed to Checkout',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Proceeding to checkout...'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: Icons.payment,
                      ),
                    ],
                  );
                } else {
                  // 🖥️ Larger screen: show side by side
                  return Row(
                    children: [
                      Expanded(
                        child: TropicalButton(
                          text: 'Clear Cart',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clear Cart'),
                                content: const Text(
                                    'Are you sure you want to remove all items from your cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      cart.clearCart();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Cart cleared'),
                                          backgroundColor:
                                              AppColors.success,
                                        ),
                                      );
                                    },
                                    child: const Text('Clear',
                                        style: TextStyle(
                                            color: AppColors.error)),
                                  ),
                                ],
                              ),
                            );
                          },
                          backgroundColor: AppColors.grey500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: TropicalButton(
                          text: 'Proceed to Checkout',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Proceeding to checkout...'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          icon: Icons.payment,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
