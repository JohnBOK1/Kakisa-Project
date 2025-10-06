import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import 'tropical_button.dart';

class Header extends StatefulWidget {
  final PageType currentPage;
  final Function(PageType) onNavigate;
  final int cartItemCount;

  const Header({
    super.key,
    required this.currentPage,
    required this.onNavigate,
    this.cartItemCount = 0,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _menuAnimationController;
  late Animation<double> _menuAnimation;

  final List<NavItem> _navItems = const [
    NavItem(label: 'Home', page: PageType.home),
    NavItem(label: 'Bookings', page: PageType.bookings),
    NavItem(label: 'Cart', page: PageType.cart, icon: Icons.shopping_cart),
    NavItem(label: 'Book Now', page: PageType.bookNow),
    NavItem(label: 'About Us', page: PageType.about),
    NavItem(label: 'Contact Us', page: PageType.contact),
  ];

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _menuAnimation = CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    
    if (_isMenuOpen) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }
  }

  void _handleNavigate(PageType page) {
    widget.onNavigate(page);
    if (_isMenuOpen) {
      _toggleMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    // Logo
                    GestureDetector(
                      onTap: () => _handleNavigate(PageType.home),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                        Container(
  width: 220,
  height: 220,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.asset(
      'assets/icons/Final.png', // 👈 put your file path here
      fit: BoxFit.cover,
    ),
  ),
),

                            const SizedBox(width: 12),
                      
                          ],
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Desktop Navigation
                    if (MediaQuery.of(context).size.width >= 768)
                      Row(
                        children: _navItems.map((item) {
                          final isActive = widget.currentPage == item.page;
                          final showBadge = item.page == PageType.cart && widget.cartItemCount > 0;
                          
                          return Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: _buildNavItem(item, isActive, showBadge),
                          );
                        }).toList(),
                      )
                    else
                      // Mobile Menu Button
                      IconButton(
                        onPressed: _toggleMenu,
                        icon: AnimatedRotation(
                          turns: _isMenuOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _isMenuOpen ? Icons.close : Icons.menu,
                            color: AppColors.grey700,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Mobile Menu
          if (MediaQuery.of(context).size.width < 768)
            AnimatedBuilder(
              animation: _menuAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    heightFactor: _menuAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          children: _navItems.map((item) {
                            final isActive = widget.currentPage == item.page;
                            final showBadge = item.page == PageType.cart && widget.cartItemCount > 0;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildMobileNavItem(item, isActive, showBadge),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

Widget _buildNavItem(NavItem item, bool isActive, bool showBadge) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;

  final double iconSize = isMobile ? 22 : 26;
  final double badgeOffset = isMobile ? -6 : -8;
  final double badgeFontSize = isMobile ? 9 : 11;
  final double badgeSize = isMobile ? 16 : 20;

  return GestureDetector(
    onTap: () => _handleNavigate(item.page),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive ? AppColors.primary.withValues(alpha: 0.1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  color: isActive ? AppColors.primary : AppColors.grey700,
                  size: iconSize,
                ),
                if (showBadge)
                  Transform.translate(
                    offset: Offset(badgeOffset, badgeOffset),
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.cartItemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(width: 8),
          Text(
            item.label,
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.grey700,
              fontSize: isMobile ? 15 : 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget _buildMobileNavItem(NavItem item, bool isActive, bool showBadge) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;

  final double iconSize = isMobile ? 22 : 26;
  final double badgeOffset = isMobile ? -8 : -10;
  final double badgeFontSize = isMobile ? 9 : 11;
  final double badgeSize = isMobile ? 16 : 20;

  return SizedBox(
    width: double.infinity,
    child: TropicalButton(
      onPressed: () => _handleNavigate(item.page),
      variant: isActive
          ? TropicalButtonVariant.primary
          : TropicalButtonVariant.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.icon != null)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : AppColors.primary,
                  size: iconSize,
                ),
                if (showBadge)
                  Transform.translate(
                    offset: Offset(badgeOffset, badgeOffset),
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.cartItemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(width: 8),
          Text(
            item.label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.primary,
              fontSize: isMobile ? 15 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class NavItem {
  final String label;
  final PageType page;
  final IconData? icon;

  const NavItem({
    required this.label,
    required this.page,
    this.icon,
  });
}