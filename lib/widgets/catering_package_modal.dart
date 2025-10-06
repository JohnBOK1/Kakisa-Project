import 'package:flutter/material.dart';
import '../models/package_model.dart';
import '../models/cart_item.dart';
import '../utils/app_colors.dart';
import 'tropical_button.dart';

class CateringPackageModal extends StatefulWidget {
  final PackageModel package;
  final int guests;
  final VoidCallback onClose;
  final Function(CartItem) onConfirmBooking;
  final Function(CartItem) onBookAnother;

  const CateringPackageModal({
    super.key,
    required this.package,
    required this.guests,
    required this.onClose,
    required this.onConfirmBooking,
    required this.onBookAnother,
  });

  @override
  State<CateringPackageModal> createState() => _CateringPackageModalState();
}

class _CateringPackageModalState extends State<CateringPackageModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _selectedMainDishes = [];
  String? _selectedNoodles;
  String? _selectedDessertOrVegetable;

  final List<String> _mainDishOptions = ['Beef', 'Chicken', 'Pork', 'Fish'];
  final List<String> _noodleOptions = ['Spaghetti', 'Carbonara', 'Any Pancit'];
  final List<String> _dessertVegetableOptions = ['Dessert', 'Vegetable'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isPackage1or2 => widget.package.packageVariant == 1 || widget.package.packageVariant == 2;
  int get _requiredMainDishes => 3;

  bool get _isSelectionComplete {
    if (_isPackage1or2) {
      return _selectedMainDishes.length == _requiredMainDishes &&
             _selectedNoodles != null &&
             _selectedDessertOrVegetable != null;
    } else {
      return _selectedNoodles != null;
    }
  }

  CartItem _createCartItem() {
  final selections = CartItemSelections(
    mainDishes: _isPackage1or2 ? _selectedMainDishes : null,
    noodles: _selectedNoodles,
    dessertOrVegetable: _isPackage1or2 ? _selectedDessertOrVegetable : null,
  );

  return CartItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    packageId: widget.package.id,
    packageName: widget.package.name,
    price: widget.package.price,
    guests: widget.guests,
    selections: selections, // ✅ now correct type
    total: widget.package.price * widget.guests,
  );
}


  List<String> get _includedItems {
    if (widget.package.packageVariant == 3) {
      return [
        '4 main dishes (Beef, Chicken, Pork, and Fish)',
        'Rice',
        'Vegetables',
        'Dessert',
        '8oz Coke'
      ];
    }
    return ['Rice', '8oz Coke'];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: GestureDetector(
        onTap: widget.onClose,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: GestureDetector(
                    onTap: () {}, // Prevent closing when tapping on modal
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(maxWidth: 600),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          Flexible(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPackageInfo(),
                                  const SizedBox(height: 24),
                                  if (_isPackage1or2) ...[
                                    _buildMainDishesSelection(),
                                    const SizedBox(height: 24),
                                  ],
                                  _buildNoodlesSelection(),
                                  const SizedBox(height: 24),
                                  if (_isPackage1or2) ...[
                                    _buildDessertVegetableSelection(),
                                    const SizedBox(height: 24),
                                  ],
                                  _buildIncludedItems(),
                                ],
                              ),
                            ),
                          ),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Customize your selection',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close),
            iconSize: 24,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFECFEFF), // cyan-50
            Color(0xFFDDEEFF), // blue-50
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.guests} guests',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₱${widget.package.price}/person',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₱${(widget.package.price * widget.guests).toStringAsFixed(0)}',
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
  }

  Widget _buildMainDishesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Select 3 Main Dishes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selectedMainDishes.length}/$_requiredMainDishes',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: _mainDishOptions.map((dish) {
            final isSelected = _selectedMainDishes.contains(dish);
            final canSelect = !isSelected && _selectedMainDishes.length < _requiredMainDishes;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  if (isSelected) {
                    setState(() => _selectedMainDishes.remove(dish));
                  } else if (canSelect) {
                    setState(() => _selectedMainDishes.add(dish));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.grey400,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: isSelected ? AppColors.primary : Colors.white,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dish,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? AppColors.primary : AppColors.grey800,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoodlesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Noodles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _noodleOptions.map((noodle) {
            final isSelected = _selectedNoodles == noodle;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedNoodles = noodle),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.grey400,
                          ),
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.white,
                        ),
                        child: isSelected
                            ? const Icon(Icons.circle, size: 12, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          noodle,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? AppColors.primary : AppColors.grey800,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDessertVegetableSelection() {
    final title = widget.package.packageVariant == 1
        ? 'Select Dessert or Vegetable'
        : 'Select Dessert and Vegetable';
    
    final options = widget.package.packageVariant == 1
        ? _dessertVegetableOptions
        : ['Dessert + Vegetable'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: options.map((option) {
            final isSelected = _selectedDessertOrVegetable == option;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedDessertOrVegetable = option),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.grey400,
                          ),
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.white,
                        ),
                        child: isSelected
                            ? const Icon(Icons.circle, size: 12, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? AppColors.primary : AppColors.grey800,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIncludedItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Also Included',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 12),
          ..._includedItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderColor),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TropicalButton(
              text: 'Book Another',
              variant: TropicalButtonVariant.secondary,
              onPressed: _isSelectionComplete
                  ? () => widget.onBookAnother(_createCartItem())
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TropicalButton(
              text: 'Confirm Booking',
              onPressed: _isSelectionComplete
                  ? () => widget.onConfirmBooking(_createCartItem())
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}