import 'package:flutter/material.dart';
import '../main.dart';
import '../models/booking_data.dart';
import '../models/cart_item.dart';
import '../models/package_model.dart';
import '../widgets/tropical_button.dart';
import '../widgets/package_card.dart';
import '../widgets/catering_package_modal.dart';
import '../widgets/booking_form.dart';
import '../utils/app_colors.dart';


class BookNowPage extends StatefulWidget {
  final Function(PageType) onNavigate;
  final Function(CartItem) onAddToCart;
  final Function(BookingData) onBookingComplete;
  final Function() onClearCart; // ✅ Add this

  const BookNowPage({
    super.key,
    required this.onNavigate,
    required this.onAddToCart,
    required this.onBookingComplete,
    required this.onClearCart, // ✅ Add this
  });


  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  final TextEditingController _checkInController = TextEditingController();
final TextEditingController _checkOutController = TextEditingController();

@override
void dispose() {
  _checkInController.dispose();
  _checkOutController.dispose();
  super.dispose();
}


  final List<String> _selectedPackages = [];
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  bool _showBookingForm = false;
  bool _showCateringModal = false;
  PackageModel? _selectedCateringPackage;

  final List<PackageModel> _packages = [
    // Catering Packages
    const PackageModel(
      id: 'catering-1',
      name: 'Catering Package 1',
      price: 400,
      description: '3 main dishes (Beef, Chicken, Pork, or Fish), Noodles (Spaghetti, Carbonara, or Any Pancit), dessert/vegetable, rice, Coke',
      imageUrl: 'assets/images/Package1.jpg',
      type: PackageType.catering,
      packageVariant: 1,
    ),
    const PackageModel(
      id: 'catering-2',
      name: 'Catering Package 2',
      price: 450,
      description: '3 main dishes (Beef, Chicken, Pork, or Fish), Noodles (Spaghetti, Carbonara, or Any Pancit), dessert + vegetable, rice, Coke',
      imageUrl: 'assets/images/Package2.jpg',
      type: PackageType.catering,
      packageVariant: 2,
    ),
    const PackageModel(
      id: 'catering-3',
      name: 'Catering Option 3',
      price: 500,
      description: '4 main dishes (Beef, Chicken, Pork, and Fish), Noodles (Spaghetti, Carbonara, or Any Pancit), dessert + vegetable, rice, Coke',
      imageUrl: 'assets/images/Package3.jpg',
      type: PackageType.catering,
      packageVariant: 3,
    ),
    
    // Venue Packages
    const PackageModel(
      id: 'venue-hall',
      name: 'Functional Hall',
      price: 5000,
      description: 'Complete venue rental with entrance fees included',
      imageUrl: 'assets/images/CATERING 3.jpg',
      type: PackageType.venue,
    ),
    const PackageModel(
      id: 'venue-setup',
      name: 'Setup Package',
      price: 150,
      description: 'Tables, chairs, buffet & cake table setup (per person)',
      imageUrl: 'assets/images/Catering 1.jpg',
      type: PackageType.venue,
      perPerson: true,
    ),
    
    // Accommodation Packages
    const PackageModel(
      id: 'room-kitchenette',
      name: 'Rooms w/ Kitchenette',
      price: 2500,
      description: 'Spacious rooms with fully equipped kitchenette (per night)',
      imageUrl: 'assets/images/Kitchen.jpg',
      type: PackageType.accommodation,
    ),
    const PackageModel(
      id: 'room-barkada',
      name: 'Barkada Rooms',
      price: 3500,
      description: 'Perfect for groups of 6, multiple beds (per night)',
      imageUrl: 'assets/images/Barkada.jpg',
      type: PackageType.accommodation,
    ),
    const PackageModel(
      id: 'room-standard',
      name: 'Standard Rooms',
      price: 2000,
      description: 'Comfortable standard rooms with essential amenities (per night)',
      imageUrl: 'assets/images/standard.jpg',
      type: PackageType.accommodation,
    ),
  ];

  void _togglePackage(String packageId) {
    // Handle catering packages with modal
   if (packageId.startsWith('catering-')) {
  // ✅ Prevent reopening modal if already selected
  if (_selectedPackages.contains(packageId)) return;

  final pkg = _packages.firstWhere((p) => p.id == packageId);
  setState(() {
    _selectedCateringPackage = pkg;
    _showCateringModal = true;
  });
  return;
}


    // Handle other packages normally
    setState(() {
      if (_selectedPackages.contains(packageId)) {
        _selectedPackages.remove(packageId);
      } else {
        _selectedPackages.add(packageId);
      }
    });
  }

double _calculateTotal() {
  int nights = 1;
  if (_checkIn != null && _checkOut != null) {
    nights = _checkOut!.difference(_checkIn!).inDays;
    if (nights < 1) nights = 1; // ensure at least one night
  }

  return _selectedPackages.fold(0.0, (total, packageId) {
    final pkg = _packages.firstWhere((p) => p.id == packageId);
    if (pkg.type == PackageType.accommodation) {
      // ✅ Room price × nights
      return total + (pkg.price * nights);
    } else if (pkg.type == PackageType.catering || pkg.perPerson) {
      // ✅ Per person
      return total + (pkg.price * _guests);
    } else {
      // ✅ Normal package (flat price)
      return total + pkg.price;
    }
  });
}


 void _handleCateringConfirmBooking(CartItem item) {
  widget.onAddToCart(item);

  setState(() {
    // ✅ Add catering package to selected list if not yet added
    if (!_selectedPackages.contains(item.packageId)) {
      _selectedPackages.add(item.packageId);
    }

    _showCateringModal = false;
    _selectedCateringPackage = null;
    _showBookingForm = true;
  });


  // 🚀 Later when backend is ready (Firebase, API, etc.)
  // You will also save this booking to your backend here:
  // FirebaseFirestore.instance.collection('bookings').add(booking.toMap());
}

void _handleCateringBookAnother(CartItem item) {
  widget.onAddToCart(item);

  setState(() {
    // ✅ Add the catering package to selected packages (if not already there)
    if (!_selectedPackages.contains(item.packageId)) {
      _selectedPackages.add(item.packageId);
    }

    // ✅ Close modal and reset states
    _showCateringModal = false;
    _selectedCateringPackage = null;
  });
}


  @override
  Widget build(BuildContext context) {
   if (_showBookingForm) {
  return BookingForm(
    selectedPackages: _selectedPackages,
    packages: _packages,
    checkIn: _checkIn,
    checkOut: _checkOut,
    guests: _guests,
    total: _calculateTotal(),
    onBack: () => setState(() => _showBookingForm = false),
    onBookingComplete: (booking) {
      widget.onBookingComplete(booking);
      widget.onClearCart(); // ✅ Clear the cart right after booking is confirmed
      setState(() {
        _showBookingForm = false;
        _selectedPackages.clear(); // ✅ Clear selections too
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed! Cart cleared.'),
          backgroundColor: Colors.green,
        ),
      );
    },
  );
}


    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // cyan-50
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 41),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
                children: [
                  // Header
                  const Text(
                    'Book Your Stay',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select your preferred packages and dates',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Date & Guest Selector
                  _buildDateGuestSelector(),
                  const SizedBox(height: 48),

                  // Catering Options
                  _buildSection(
                    'Catering Options',
                    _packages.where((p) => p.type == PackageType.catering).toList(),
                  ),
                  const SizedBox(height: 48),

                  // Venue Packages
                  _buildSection(
                    'Venue Packages',
                    _packages.where((p) => p.type == PackageType.venue).toList(),
                  ),
                  const SizedBox(height: 48),

                  // Accommodations
                  _buildSection(
                    'Accommodations',
                    _packages.where((p) => p.type == PackageType.accommodation).toList(),
                  ),
                  const SizedBox(height: 48),

                  // Selected Packages Summary
                  if (_selectedPackages.isNotEmpty) _buildSelectedPackagesSummary(),
                ],
              ),
            ),
          ),

          // Catering Package Modal
          if (_showCateringModal && _selectedCateringPackage != null)
            CateringPackageModal(
              package: _selectedCateringPackage!,
              guests: _guests,
              onClose: () => setState(() {
                _showCateringModal = false;
                _selectedCateringPackage = null;
              }),
              onConfirmBooking: _handleCateringConfirmBooking,
              onBookAnother: _handleCateringBookAnother,
            ),
        ],
      ),
    );
  }

  Widget _buildDateGuestSelector() {
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
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 768;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildCheckInField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCheckOutField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildGuestsField()),
                    const SizedBox(width: 16),
                    _buildFindDatesButton(),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildCheckInField(),
                    const SizedBox(height: 16),
                    _buildCheckOutField(),
                    const SizedBox(height: 16),
                    _buildGuestsField(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildFindDatesButton(),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Check-in Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _checkIn ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _checkIn = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                const SizedBox(width: 8),
                Text(
                  _checkIn?.toIso8601String().split('T')[0] ?? 'Select date',
                  style: TextStyle(
                    color: _checkIn != null ? AppColors.grey800 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckOutField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Check-out Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _checkOut ?? DateTime.now().add(const Duration(days: 1)),
              firstDate: _checkIn ?? DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _checkOut = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                const SizedBox(width: 8),
                Text(
                  _checkOut?.toIso8601String().split('T')[0] ?? 'Select date',
                  style: TextStyle(
                    color: _checkOut != null ? AppColors.grey800 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showGuestSelector(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 16, color: AppColors.grey500),
                const SizedBox(width: 8),
                Text(
                  '$_guests ${_guests == 1 ? 'Guest' : 'Guests'}',
                  style: const TextStyle(color: AppColors.grey800),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.grey500),
              ],
            ),
          ),
        ),
      ],
    );
  }

 Widget _buildFindDatesButton() {
  return TropicalButton(
    text: 'Find Available Dates',
    onPressed: () => _selectDatesFlow(),
  );
}

Future<void> _selectDatesFlow() async {
  // Step 1: Pick check-in
  final checkIn = await showDatePicker(
    context: context,
    initialDate: _checkIn ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    helpText: "Select Check-in Date", // ✅ label at top of dialog
  );

  if (checkIn == null) return; // user closed
  if (!mounted) return;
  setState(() => _checkIn = checkIn);

  // Step 2: Pick check-out
  final checkOut = await showDatePicker(
    context: context,
    initialDate: _checkOut ?? checkIn.add(const Duration(days: 1)),
    firstDate: checkIn.add(const Duration(days: 1)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    helpText: "Select Check-out Date", // ✅ label at top of dialog
  );

  if (checkOut == null) return; // user closed
  if (!mounted) return;
  setState(() => _checkOut = checkOut);

  // Step 3: Show confirmation modal
  if (!mounted) return;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Your Dates"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Check-in:"),
                Text(_checkIn!.toIso8601String().split('T')[0]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Check-out:"),
                Text(_checkOut!.toIso8601String().split('T')[0]),
              ],
            ),
            const SizedBox(height: 16),
            Text("Guests: $_guests"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) {
                setState(() => _showBookingForm = true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Next"),
          ),
        ],
      );
    },
  );
}



  void _showGuestSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Select Number of Guests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: 12, // 1-10, 15, 20, 25, 30, 40, 50
                  itemBuilder: (context, index) {
                    final counts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 40, 50];
                    if (index >= counts.length) return const SizedBox.shrink();
                    
                    final count = counts[index];
                    return ListTile(
                      title: Text('$count ${count == 1 ? 'Guest' : 'Guests'}'),
                      selected: _guests == count,
                      onTap: () {
                        setState(() => _guests = count);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<PackageModel> packages) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.grey800,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;
          
          if (isDesktop) {
            return Row(
              children: packages.map((pkg) {
                final index = packages.indexOf(pkg);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 16,
                      right: index == packages.length - 1 ? 0 : 16,
                    ),
                    child: _buildPackageCard(pkg),
                  ),
                );
              }).toList(),
            );
          } else {
            return Column(
              children: packages.map((pkg) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildPackageCard(pkg),
                );
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}


 Widget _buildPackageCard(PackageModel pkg) {
  final isSelected = _selectedPackages.contains(pkg.id);
  final priceText = pkg.type == PackageType.catering || pkg.perPerson
      ? '₱${pkg.price}/person'
      : '₱${pkg.price}';

  final totalText = pkg.type == PackageType.catering || pkg.perPerson
      ? 'Total for $_guests guests: ₱${(pkg.price * _guests).toStringAsFixed(0)}'
      : '₱${pkg.price.toStringAsFixed(0)}';

  return PackageCard(
    title: pkg.name,
    price: priceText,
    description: "${pkg.description}\n\n$totalText",
    imageUrl: pkg.imageUrl,
    buttonText: isSelected ? "Selected" : "Select",
    buttonIcon: isSelected ? Icons.check : Icons.add,
    centerTitle: false,
    onTap: () => _togglePackage(pkg.id),
  );
}


  Widget _buildSelectedPackagesSummary() {
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
        const Text(
          'Selected Packages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 16),
        ..._selectedPackages.map((packageId) {
          final pkg = _packages.firstWhere((p) => p.id == packageId);
          final price = pkg.type == PackageType.catering || pkg.perPerson
              ? pkg.price * _guests
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
                      fontSize: 16,
                      color: AppColors.grey800,
                    ),
                  ),
                ),
                Text(
                  '₱${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
              '₱${_calculateTotal().toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: TropicalButton(
            text: 'Book Selected Packages',
            size: TropicalButtonSize.large,
            onPressed: () {
             if (_checkIn == null || _checkOut == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please select your check-in and check-out dates before proceeding.'),
      backgroundColor: Colors.redAccent,
    ),
  );
  return;
    } else {
                setState(() => _showBookingForm = true);
              }
            },
          ),
        ),
      ],
    ),
  );
}
}