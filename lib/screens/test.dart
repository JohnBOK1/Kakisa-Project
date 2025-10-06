import 'package:flutter/material.dart';
import '../main.dart';
import '../models/cart_item.dart';
import '../models/booking_data.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(PageType) onNavigate;
  final Function(String) onRemoveItem;
  final VoidCallback onClearCart;
  final Function(BookingData) onBookingComplete;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onNavigate,
    required this.onRemoveItem,
    required this.onClearCart,
    required this.onBookingComplete,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}



class _CartPageState extends State<CartPage> {
    // ADD THIS INSIDE _CartPageState (below your controllers, above dispose())

  // payment dropdown state
  String _paymentMethod = 'Pay On-Site';


  void _showClearCartDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Clear Cart"),
      content: const Text("Are you sure you want to clear your cart?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // cancel
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Notify parent / provider to clear the cart (preferred)
            widget.onClearCart();
            Navigator.of(context).pop(); // close dialog
            setState(() {}); // rebuild to reflect empty cart
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text("Clear"),
        ),
      ],
    ),
  );
}


  // a thin wrapper around your existing _buildTextFormField implementation
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String hint = '',
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    // uses your existing _buildTextFormField (which you already have lower in the file)
    return _buildTextFormField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  bool _showCheckout = false;
  DateTime? _checkIn;
  DateTime? _checkOut;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Re-add this inside _CartPageState
Widget _buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String hint,
  TextInputType? keyboardType,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.grey500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ],
  );
}

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    return widget.cartItems.fold(0.0, (total, item) => total + item.total);
  }

  int get _totalGuests {
    return widget.cartItems.fold(0, (total, item) => total + item.guests);
  }

  void _handleCheckout() {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all required fields.'),
        backgroundColor: AppColors.error,
      ),
    );
    return;
  }

  if (_totalGuests <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please add at least 1 guest.'),
        backgroundColor: AppColors.error,
      ),
    );
    return;
  }

  if (_paymentMethod.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a payment method.'),
        backgroundColor: AppColors.error,
      ),
    );
    return;
  }

  if (widget.cartItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your cart is empty.'),
        backgroundColor: AppColors.error,
      ),
    );
    return;
  }

  final booking = BookingData(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    fullName: _fullNameController.text,
    address: _addressController.text,
    email: _emailController.text,
    phone: _phoneController.text,
    package: widget.cartItems.map((item) {
      String name = item.packageName;
      if (item.selections?.mainDishes != null) {
        name += " (${item.selections!.mainDishes!.join(', ')})";
      }
      if (item.selections?.noodles != null) {
        name += " - ${item.selections!.noodles}";
      }
      if (item.selections?.dessertOrVegetable != null) {
        name += " - ${item.selections!.dessertOrVegetable}";
      }
      return name;
    }).join(', '),
    checkIn: _checkIn?.toIso8601String().split('T')[0] ?? '',
    checkOut: _checkOut?.toIso8601String().split('T')[0] ?? '',
    guests: _totalGuests,
    total: _totalPrice,
    createdAt: DateTime.now(),
  );

  widget.onBookingComplete(booking);
}

  @override
  Widget build(BuildContext context) {
    if (_showCheckout) {
      return _buildCheckoutScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // cyan-50
      body: widget.cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 48,
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Add some packages to get started!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TropicalButton(
                text: 'Browse Packages',
                onPressed: () => widget.onNavigate(PageType.bookNow),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildCartContent() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
        child: Center( // 👈 Center everything horizontally
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // 👈 Full height
              maxWidth: 2024,                   // 👈 Desktop-friendly width
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 👈 optional
                children: [
                  const Text(
                    'Your Cart',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Review your selected packages',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Cart Items
                  ...widget.cartItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCartItem(item, index),
                    );
                  }),

                  const Spacer(),
                  _buildCartSummary(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildCartItem(CartItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.packageName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 12),
                
            if (hasSelections(item.selections)) ...[
  ..._buildSelectionDetails(item.selections!),
  const SizedBox(height: 12),
],      
                Text(
                  '${item.guests} guests × ₱${item.price.toStringAsFixed(0)} = ₱${item.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₱${item.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TropicalButton(
                text: 'Remove',
                icon: Icons.delete,
                variant: TropicalButtonVariant.destructive,
                size: TropicalButtonSize.small,
                onPressed: () => widget.onRemoveItem(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

 List<Widget> _buildSelectionDetails(CartItemSelections selections) {
  final details = <Widget>[];

  if (selections.mainDishes != null && selections.mainDishes!.isNotEmpty) {
    final dishes = selections.mainDishes!.join(', ');
    details.add(_buildSelectionDetail('Main Dishes:', dishes));
  }

  if (selections.noodles != null && selections.noodles!.isNotEmpty) {
    details.add(_buildSelectionDetail('Noodles:', selections.noodles!));
  }

  if (selections.dessertOrVegetable != null && selections.dessertOrVegetable!.isNotEmpty) {
    details.add(_buildSelectionDetail('Extra:', selections.dessertOrVegetable!));
  }

  return details;
}


  Widget _buildSelectionDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label $value',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFECFEFF), // cyan-50
            Color(0xFFDDEEFF), // blue-50
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey800,
                      ),
                    ),
                    Text(
                      '${widget.cartItems.length} item${widget.cartItems.length != 1 ? 's' : ''} in cart',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₱${_totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TropicalButton(
                  text: 'Clear Cart',
                  icon: Icons.delete,
                  variant: TropicalButtonVariant.secondary,
                  onPressed: () => _showClearCartDialog(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TropicalButton(
                  text: 'Proceed to Checkout',
                  size: TropicalButtonSize.large,
                  onPressed: () => setState(() => _showCheckout = true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildCheckoutScreen() {
  return Scaffold(
    backgroundColor: const Color(0xFFF0F9FF),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 140),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1024),
        child: Form(  // ⬅️ wrap with Form here
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Complete Your Booking',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your details to confirm reservation',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

            // Merged Container
           Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderColor),
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
      // 🔹 Contact Info FIRST
      const Text(
        'Contact Information',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 16),

      _buildTextField(
        label: "Phone *",
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        validator: (v) => v == null || v.isEmpty ? "Phone number required" : null,
      ),
      const SizedBox(height: 16),

      _buildTextField(label: "Full Name *", controller: _fullNameController),
      const SizedBox(height: 16),

      _buildTextField(label: "Address", controller: _addressController),
      const SizedBox(height: 16),

      DropdownButtonFormField<String>(
        initialValue: _paymentMethod,
        items: const [
          DropdownMenuItem(value: "Pay On-Site", child: Text("Pay On-Site")),
          DropdownMenuItem(value: "GCash", child: Text("GCash")),
          DropdownMenuItem(value: "PayPal", child: Text("PayPal")),
        ],
        onChanged: (value) {
          setState(() {
            _paymentMethod = value!;
          });
        },
        decoration: const InputDecoration(
          labelText: "Payment Method",
          border: OutlineInputBorder(),
        ),
      ),

      const SizedBox(height: 24),


      const SizedBox(height: 32),

      // 🔹 Booking Summary SECOND (moved down)
      const Text(
        'Booking Summary',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 16),
      _buildSummaryRow('Total Guests:', _totalGuests.toString()),

      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),

      const Text(
        'Cart Items:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 8),
      ...widget.cartItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.packageName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                      ),
                    ),
                  ),
                  Text(
                    '₱${item.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                    ),
                  ),
                ],
              ),
              if (hasSelections(item.selections)) ...[
                const SizedBox(height: 4),
                ..._buildSelectionDetails(item.selections!),
              ],
              const SizedBox(height: 4),
              Text(
                '${item.guests} guests × ₱${item.price.toStringAsFixed(0)} = ₱${item.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        );
      }),
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          Text(
            '₱${_totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
          Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _showCheckout = false),
              child: const Text("Back to Cart"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleCheckout,
              child: const Text("Confirm Booking"),
            ),
          ),
        ],
      ),
    ],
  ),
)

          ],
        ),
      ),
    ),
    )
  );
}


 
bool hasSelections(CartItemSelections? selections) {
  if (selections == null) return false;
  return (selections.mainDishes != null && selections.mainDishes!.isNotEmpty) ||
         (selections.noodles != null && selections.noodles!.isNotEmpty) ||
         (selections.dessertOrVegetable != null && selections.dessertOrVegetable!.isNotEmpty);
}

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

}