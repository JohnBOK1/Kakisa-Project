import 'package:flutter/material.dart';
import '../models/booking_data.dart';
import '../models/package_model.dart';
import '../utils/app_colors.dart';

class BookingForm extends StatefulWidget {
  final List<String> selectedPackages;
  final List<PackageModel> packages;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;
  final double total;
  final VoidCallback onBack;
  final Function(BookingData) onBookingComplete;

  const BookingForm({
    super.key,
    required this.selectedPackages,
    required this.packages,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.total,
    required this.onBack,
    required this.onBookingComplete,
  });

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _paymentMethod = 'pay-on-site';

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmitBooking() {
    if (!_formKey.currentState!.validate() || widget.selectedPackages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields and select at least one package.'),
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
  package: widget.selectedPackages
      .map((id) => widget.packages.firstWhere((p) => p.id == id).name)
      .join(', '),
  checkIn: widget.checkIn?.toIso8601String().split('T')[0] ?? '',
  checkOut: widget.checkOut?.toIso8601String().split('T')[0] ?? '',
  guests: widget.guests,
  total: widget.total,
   createdAt: DateTime.now(),
);


    widget.onBookingComplete(booking);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor: const Color(0xFFF0F9FF),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Your Booking',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Review your details and confirm your reservation below.',
                    style: TextStyle(fontSize: 16, color: AppColors.grey600),
                  ),
                  const SizedBox(height: 24),

                  // Fields
                  _buildTextFormField(
                    controller: _fullNameController,
                    label: 'Full Name *',
                    hint: 'Enter your full name',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter your full name' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _addressController,
                    label: 'Address',
                    hint: 'Enter your address',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email *',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _phoneController,
                    label: 'Phone *',
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentMethodField(),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFEFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.security, color: AppColors.primary, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your information is secure and will never be shared.',
                            style: TextStyle(fontSize: 14, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildBookingSummary(),

                  const SizedBox(height: 100), // leave space for total + buttons
                ],
              ),
            ),
          ),
        ),
      ),
    ),

    // ✅ Bottom Section (Total + Buttons)
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💰 Total Amount Section
            const Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₱${widget.total.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // 🟦 Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSubmitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}



  Widget _buildBookingSummary() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Booking Summary',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 16),
      _buildSummaryRow(
        'Check-in:',
        widget.checkIn?.toIso8601String().split('T')[0] ?? 'Not selected',
      ),
      _buildSummaryRow(
        'Check-out:',
        widget.checkOut?.toIso8601String().split('T')[0] ?? 'Not selected',
      ),
      _buildSummaryRow('Guests:', widget.guests.toString()),

      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),

      const Text(
        'Selected Packages:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 8),

      ...widget.selectedPackages.map((packageId) {
        final pkg = widget.packages.firstWhere((p) => p.id == packageId);
        final price = pkg.type == PackageType.catering || pkg.perPerson
            ? pkg.price * widget.guests
            : pkg.price;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pkg.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey700,
                  ),
                ),
              ),
              Text(
                '₱${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey800,
                ),
              ),
            ],
          ),
        );
      }),

      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),

    ],
  );
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

 Widget _buildPaymentMethodField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Payment Method',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.grey800,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: _paymentMethod,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'pay-on-site',
            child: Row(
              children: [
                Icon(Icons.store, size: 16, color: AppColors.grey500),
                SizedBox(width: 8),
                Text('Pay On-Site'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'paypal',
            child: Row(
              children: [
                Icon(Icons.payment, size: 16, color: AppColors.grey500),
                SizedBox(width: 8),
                Text('Pay with PayPal'),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _paymentMethod = value!;
          });
        },
      ),
    ],
  );
}
}