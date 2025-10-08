import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../main.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';

class AboutUsPage extends StatefulWidget {
  final Function(PageType) onNavigate;

  const AboutUsPage({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<FeatureItem> _features = const [
    FeatureItem(
      icon: Icons.waves,
      title: 'Seaside Location',
      description: 'Prime beachfront location with stunning ocean views and direct beach access',
    ),
    FeatureItem(
      icon: Icons.favorite,
      title: 'Personalized Service',
      description: 'Dedicated staff providing warm Filipino hospitality and customized experiences',
    ),
    FeatureItem(
      icon: Icons.people,
      title: 'Event Specialists',
      description: 'Expert team for weddings, corporate events, and special celebrations',
    ),
    FeatureItem(
      icon: Icons.star,
      title: 'Premium Facilities',
      description: 'Modern amenities including swimming pools, function halls, and dining areas',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Banner
          _buildHeroBanner(),
          
          // Main Content
          _buildMainContent(),
          
          // Call to Action
          _buildCallToAction(),
          
          // Footer Wave
          _buildFooterWave(),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return SizedBox(
      height: 384,
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                'assets/images/Image 1.jpg'
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
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.3),
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
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _animationController.value)),
                    child: Opacity(
                      opacity: _animationController.value,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'About KAKISA',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your Gateway to Paradise in Negros Oriental',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                                color: const Color(0xFFA5F3FC), // cyan-100
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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

  Widget _buildMainContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            // Our Story Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                
                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(child: _buildStoryContent()),
                      const SizedBox(width: 64),
                      Expanded(child: _buildStoryImage()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildStoryContent(),
                      const SizedBox(height: 48),
                      _buildStoryImage(),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: 80),
            
            // Features Grid
            _buildFeaturesSection(),
            
            const SizedBox(height: 80),
            
            // Awards Section
            _buildAwardsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Story',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'KAKISA Dive Resort is a serene seaside destination offering elegant venues, comfortable rooms, swimming pools, and personalized catering services. Experience warm Filipino hospitality in a relaxing coastal setting.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grey600,
            height: 1.6,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Located along the beautiful coastline of Bacong in Negros Oriental, our resort combines modern amenities with the natural beauty of the Philippines. Whether you\'re planning an intimate wedding, a corporate retreat, or a relaxing vacation, KAKISA provides the perfect backdrop for unforgettable memories.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grey600,
            height: 1.6,
          ),
        ),
        SizedBox(height: 24),
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

  Widget _buildStoryImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 384,
        width: double.infinity,
        child: Image.asset(
          'assets/images/Slide 1.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
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
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      children: [
        const Text(
          'Why Choose KAKISA?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;
            final isTablet = constraints.maxWidth >= 768;
            final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
            
            if (crossAxisCount == 1) {
              return Column(
                children: _features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _buildFeatureCard(feature, index),
                  );
                }).toList(),
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: 0.8,
                ),
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  return _buildFeatureCard(_features[index], index);
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(FeatureItem feature, int index) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.tropicalGradient,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            feature.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFECFEFF), // cyan-50
            Color(0xFFDDEEFF), // blue-50
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.tropicalGradient,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Premier Destination',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: const Text(
              'Recognized as one of Negros Oriental\'s finest seaside resorts, we pride ourselves on delivering exceptional experiences that exceed expectations. Our commitment to excellence has made us a preferred choice for discerning travelers and event planners.',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.tropicalGradient,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1024),
        child: Column(
          children: [
            const Text(
              'Ready to Experience Paradise?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Book your stay at KAKISA Dive Resort and create memories that will last a lifetime.',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFA5F3FC), // cyan-100
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 600;
                
                if (isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TropicalButton(
                        text: 'Book Now',
                        size: TropicalButtonSize.large,
                        backgroundColor: Colors.white,
                        textColor: AppColors.primary,
                        onPressed: () => widget.onNavigate(PageType.bookNow),
                      ),
                      const SizedBox(width: 16),
                      TropicalButton(
                        text: 'Contact Us',
                        size: TropicalButtonSize.large,
                        backgroundColor: Colors.white,
                        textColor: AppColors.primary,
                        onPressed: () => widget.onNavigate(PageType.contact),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TropicalButton(
                          text: 'Book Now',
                          size: TropicalButtonSize.large,
                          backgroundColor: Colors.white,
                          textColor: AppColors.primary,
                          onPressed: () => widget.onNavigate(PageType.bookNow),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TropicalButton(
                          text: 'Contact Us',
                          size: TropicalButtonSize.large,
                          backgroundColor: Colors.white,
                          textColor: AppColors.primary,
                          onPressed: () => widget.onNavigate(PageType.contact),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterWave() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.tropicalGradient,
        ),
      ),
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 64),
        painter: WavePainter(),
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
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

    // Create wave effect
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