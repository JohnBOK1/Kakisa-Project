import 'package:flutter/material.dart';
import '../main.dart';
import '../models/booking_data.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';


class BookingsPage extends StatefulWidget {
  final List<BookingData> bookings;
  final Function(PageType) onNavigate;

  const BookingsPage({
    super.key,
    required this.bookings,
    required this.onNavigate,
  });

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {

  final Map<String, bool> _confirmedBookings = {};
  
  @override
  Widget build(BuildContext context) {
    if (widget.bookings.isEmpty) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // cyan-50
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Header
              const Text(
                'Your Bookings',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Manage your reservations',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Bookings List
              ...widget.bookings.asMap().entries.map((entry) {
                final index = entry.key;
                final booking = entry.value;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildBookingCard(booking, index),
                );
              }),

              // Action Button
              const SizedBox(height: 48),
              TropicalButton(
                text: 'Make Another Booking',
                onPressed: () => widget.onNavigate(PageType.bookNow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // cyan-50
      body: Center(
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
                    color: const Color(0xFFECFEFF), // cyan-100
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Bookings Yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'You haven\'t made any reservations yet. Start planning your perfect getaway!',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TropicalButton(
                  text: 'Make a Booking',
                  onPressed: () => widget.onNavigate(PageType.bookNow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingData booking, int index) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking #${booking.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              if (_confirmedBookings[booking.id] == true)
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.green.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 14, color: Colors.green),
        SizedBox(width: 4),
        Text(
          'Confirmed',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ],
    ),
  ),
            ],
          ),
          const SizedBox(height: 24),

          // Details
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 140;
              
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCustomerDetails(booking)),
                    const SizedBox(width: 48),
                    Expanded(child: _buildBookingDetails(booking)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildCustomerDetails(booking),
                    const SizedBox(height: 24),
                    _buildBookingDetails(booking),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Services
          _buildServicesSection(booking),
          const SizedBox(height: 24),

          // Total & Actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey600,
                      ),
                    ),
                    Text(
                      '₱${booking.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
  children: [
    const SizedBox(width: 12),
    if (_confirmedBookings[booking.id] != true)
      TropicalButton(
        text: 'Confirm',
        icon: Icons.check_circle,
        size: TropicalButtonSize.small,
        onPressed: () => _showConfirmDialog(booking),
      ),
    TropicalButton(
      text: 'Cancel',
      icon: Icons.close,
      variant: TropicalButtonVariant.secondary,
      size: TropicalButtonSize.small,
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      textColor: Colors.red,
      onPressed: () => _showCancelDialog(booking),
    ),
  ],
),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetails(BookingData booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Name:', booking.fullName),
        _buildDetailRow('Phone:', booking.phone),
        if (booking.address.isNotEmpty)
          _buildDetailRow('Address:', booking.address),
      ],
    );
  }

  Widget _buildBookingDetails(BookingData booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Guests:', booking.guests.toString()),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BookingData booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            booking.package,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey700,
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BookingData booking) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel Booking'),
      content: Text('Are you sure you want to cancel booking #${booking.id}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep Booking'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);

            // Remove booking from provider (source of truth)
            try {
             Provider.of<BookingProvider>(context, listen: false)
    .removeBooking(booking.id);
 // or removeBookingById(booking.id) depending on your provider API
            } catch (e) {
              // Fallback attempt if provider API expects id
              try {
                Provider.of<BookingProvider>(context, listen: false)
                    .removeBooking(booking.id);
              } catch (_) {
                // If neither method exists, as fallback try to mutate the list (not recommended)
                setState(() {
                  widget.bookings.remove(booking);
                });
              }
            }

            // Also clear the confirmed flag locally and ask UI to refresh
            setState(() {
              _confirmedBookings.remove(booking.id);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking cancelled successfully'),
                backgroundColor: Colors.red,
              ),
            );
          },
          child: const Text('Cancel Booking'),
        ),
      ],
    ),
  );
}


 void _showConfirmDialog(BookingData booking) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Booking'),
      content: Text('Confirm booking #${booking.id} for ${booking.fullName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              _confirmedBookings[booking.id] = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking confirmed successfully'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
}