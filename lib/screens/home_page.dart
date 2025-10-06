import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../main.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';
import '../widgets/package_card.dart';

class HomePage extends StatefulWidget {
  final Function(PageType) onNavigate;

  const HomePage({
    super.key,
    required this.onNavigate,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _heroAnimationController.forward();
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          _buildHeroSection(),
          
          // About Us Section
          _buildAboutUsSection(),
          
          // Catering Choices Section
          _buildCateringChoicesSection(),
          
          // Venue & Catering Packages
          _buildVenuePackagesSection(),
          
          // Accommodations Section
          _buildAccommodationsSection(),
          
          // Resort Access & Rates
          _buildResortAccessSection(),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Image 1.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedBuilder(
                animation: _heroAnimationController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _heroSlideAnimation,
                    child: FadeTransition(
                      opacity: _heroFadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'KAKISA DIVE RESORT',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Premier seaside event resort in Bacong, Negros Oriental',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                              color: const Color(0xFFA5F3FC), // cyan-100
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TropicalButton(
                            onPressed: () => widget.onNavigate(PageType.bookNow),
                            size: TropicalButtonSize.large,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('BOOK NOW'),
                                SizedBox(width: 12),
                                Icon(Icons.arrow_forward, size: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Wave divider at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 64),
              painter: WavePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutUsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;
            
            if (isDesktop) {
              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/Slide 1.jpg',
                        height: 384,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 384,
                            color: AppColors.grey200,
                            child: const Center(
                              child: Icon(
                                Icons.waves,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    child: _buildAboutContent(),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/Slide 1.jpg',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: AppColors.grey200,
                          child: const Center(
                            child: Icon(
                              Icons.waves,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildAboutContent(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About KAKISA Dive Resort',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'A luxurious seaside escape offering weddings, parties, corporate events, and relaxing getaways with ocean views, swimming facilities, catering, and personalized service.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grey600,
            height: 1.6,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Bacong, Negros Oriental, Philippines',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCateringChoicesSection() {
    final cateringOptions = [
      {
        'title': 'Package 1',
        'price': '₱400',
        'description': '3 main dishes, noodles, dessert/vegetable, rice, Coke',
        'image': 'assets/images/Package1.jpg',
      },
      {
        'title': 'Package 2',
        'price': '₱450',
        'description': '3 main dishes, noodles, dessert + vegetable, rice, Coke',
        'image': 'assets/images/Package2.jpg'
      },
      {
        'title': 'Option 3',
        'price': '₱500',
        'description': '4 main dishes, noodles, dessert + vegetable, rice, Coke',
        'image': 'assets/images/Package3.jpg',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            const Text(
              'Catering Choices',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Delicious options for every palate',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 768;
                
                if (isDesktop) {
                  return Row(
                    children: cateringOptions.map((option) {
                      final index = cateringOptions.indexOf(option);
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 16,
                            right: index == cateringOptions.length - 1 ? 0 : 16,
                          ),
                          child: PackageCard(
                            title: option['title']!,
                            price: option['price']!,
                            description: option['description']!,
                            imageUrl: option['image']!,
                            onTap: () => widget.onNavigate(PageType.bookNow),
                            buttonText: 'BOOK NOW',
                            buttonIcon: Icons.restaurant,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Column(
                    children: cateringOptions.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: PackageCard(
                          title: option['title']!,
                          price: option['price']!,
                          description: option['description']!,
                          imageUrl: option['image']!,
                          onTap: () => widget.onNavigate(PageType.bookNow),
                          buttonText: 'BOOK NOW',
                          buttonIcon: Icons.restaurant,
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenuePackagesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            const Text(
              'Venue & Catering Packages',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Complete event solutions',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 768;
                  
                  if (isDesktop) {
                    return Row(
                      children: [
                        Expanded(
                          child: PackageCard(
                            title: 'Functional Hall',
                            price: '₱5,000',
                            description: '+ entrance fees - Perfect for weddings and events',
                            imageUrl: 'assets/images/CATERING 3.jpg',
                            onTap: () => widget.onNavigate(PageType.bookNow),
                            buttonText: 'BOOK VENUE',
                            centerTitle: true,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: PackageCard(
                            title: 'Setup Package',
                            price: '₱150/person',
                            description: 'Per person - tables, chairs, buffet & cake table',
                            imageUrl: 'assets/images/Catering 1.jpg',
                            onTap: () => widget.onNavigate(PageType.bookNow),
                            buttonText: 'BOOK SETUP',
                            centerTitle: true,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        PackageCard(
                          title: 'Functional Hall',
                          price: '₱5,000',
                          description: '+ entrance fees - Perfect for weddings and events',
                          imageUrl: 'assets/images/CATERING 3.jpg',
                          onTap: () => widget.onNavigate(PageType.bookNow),
                          buttonText: 'BOOK VENUE',
                          centerTitle: true,
                        ),
                        const SizedBox(height: 32),
                        PackageCard(
                          title: 'Setup Package',
                          price: '₱150/person',
                          description: '/person - tables, chairs, buffet & cake table',
                            imageUrl: 'assets/images/Catering 1.jpg',
                          onTap: () => widget.onNavigate(PageType.bookNow),
                          buttonText: 'BOOK SETUP',
                          centerTitle: true,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodationsSection() {
    final accommodations = [
      {
        'title': 'Rooms w/ Kitchenette',
        'price': '₱2,500',
        'period': '/night',
        'description': 'Spacious rooms with fully equipped kitchenette, perfect for longer stays',
        'image': 'assets/images/Kitchen.jpg',
      },
      {
        'title': 'Barkada Rooms',
        'price': '₱3,500',
        'period': '/night',
        'description': 'Perfect for groups of 6, with multiple beds and shared amenities',
        'image': 'assets/images/Barkada.jpg',
      },
      {
        'title': 'Standard Rooms',
        'price': '₱2,000',
        'period': '/night',
        'description': 'Comfortable standard rooms with essential amenities',
        'image': 'assets/images/standard.jpg',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            const Text(
              'Accommodations',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Comfortable rooms for every need',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 768;
                
                if (isDesktop) {
                  return Row(
                    children: accommodations.map((room) {
                      final index = accommodations.indexOf(room);
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 16,
                            right: index == accommodations.length - 1 ? 0 : 16,
                          ),
                          child: PackageCard(
                            title: room['title']!,
                            price: '${room['price']}${room['period']}',
                            description: room['description']!,
                            imageUrl: room['image']!,
                            onTap: () => widget.onNavigate(PageType.bookNow),
                            buttonText: 'BOOK NOW',
                            buttonIcon: Icons.bed,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Column(
                    children: accommodations.map((room) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: PackageCard(
                          title: room['title']!,
                          price: '${room['price']}${room['period']}',
                          description: room['description']!,
                          imageUrl: room['image']!,
                          onTap: () => widget.onNavigate(PageType.bookNow),
                          buttonText: 'BOOK NOW',
                          buttonIcon: Icons.bed,
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResortAccessSection() {
    return Container(
      color: const Color.fromARGB(255, 238, 238, 240),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            const Text(
              'Resort Access & Rates',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Affordable day use rates',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '₱100',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Adults',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '₱60',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Children',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Includes access to swimming pools, sunbeds, and resort facilities',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TropicalButton(
                    text: 'Book Day Use',
                    onPressed: () => widget.onNavigate(PageType.bookNow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: AppColors.grey800,
      padding: const EdgeInsets.all(64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 768;
                
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFooterContact()),
                      const SizedBox(width: 64),
                      Expanded(child: _buildFooterHours()),
                      const SizedBox(width: 64),
                      Expanded(child: _buildFooterSocial()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildFooterContact(),
                      const SizedBox(height: 32),
                      _buildFooterHours(),
                      const SizedBox(height: 32),
                      _buildFooterSocial(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.grey700),
            const SizedBox(height: 32),
            const Text(
              '© 2024 KAKISA Dive Resort. All rights reserved.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterContactItem(
          Icons.location_on,
          'National Highway, Bacong, Negros Oriental, Philippines',
        ),
        _buildFooterContactItem(
          Icons.phone,
          '09978919901 / 09753648107',
        ),
        _buildFooterContactItem(
          Icons.phone,
          'Landline: 5274882',
        ),
      ],
    );
  }

  Widget _buildFooterHours() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resort Hours',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Daily: 6:00 AM - 10:00 PM',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Free/Security Parking Available',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF67E8F9), // cyan-300
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSocial() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Stay connected for updates and special offers',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF67E8F9), // cyan-300
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);

    // Create wave effect matching React design
    for (double i = 0; i <= size.width; i += 10) {
      path.lineTo(
        i,
        size.height * 0.7 + 20 * math.sin((i / size.width) * 2 * math.pi),
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}