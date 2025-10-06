import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Image Section
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
'assets/images/Image 1.jpg',
                ),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {},
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'KAKISA Dive Resort',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bacong, Negros Oriental, Philippines',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // About Content
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Our Story',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'KAKISA Dive Resort stands as a premier destination in the heart of Bacong, Negros Oriental, Philippines. Our resort embodies the perfect fusion of tropical luxury and authentic Filipino hospitality, creating an unforgettable experience for every guest.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Features Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildFeatureCard(
                      Icons.waves,
                      'Ocean Access',
                      'Direct access to pristine waters perfect for diving and swimming',
                    ),
                    _buildFeatureCard(
                      Icons.restaurant_menu,
                      'Gourmet Dining',
                      'Authentic Filipino cuisine and international dishes',
                    ),
                    _buildFeatureCard(
                      Icons.event_available,
                      'Event Venues',
                      'Perfect spaces for weddings, conferences, and celebrations',
                    ),
                    _buildFeatureCard(
                      Icons.hotel,
                      'Premium Rooms',
                      'Comfortable accommodations with stunning ocean views',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mission & Vision Section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildMissionVisionCard(
                  'Our Mission',
                  'To provide exceptional hospitality and unforgettable experiences while preserving the natural beauty of our marine environment and supporting the local community.',
                  Icons.flag,
                ),
                const SizedBox(height: 20),
                _buildMissionVisionCard(
                  'Our Vision',
                  'To be the leading eco-friendly dive resort in the Philippines, setting the standard for sustainable tourism and marine conservation.',
                  Icons.visibility,
                ),
              ],
            ),
          ),

          // Location & Contact
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visit Us',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactInfo(
                  Icons.location_on,
                  'Location',
                  'Bacong, Negros Oriental, Philippines',
                ),
                const SizedBox(height: 12),
                _buildContactInfo(
                  Icons.phone,
                  'Phone',
                  '+63 123 456 7890',
                ),
                const SizedBox(height: 12),
                _buildContactInfo(
                  Icons.email,
                  'Email',
                  'info@kakisadiveresort.com',
                ),
                const SizedBox(height: 12),
                _buildContactInfo(
                  Icons.language,
                  'Website',
                  'www.kakisadiveresort.com',
                ),
              ],
            ),
          ),

          // Awards & Recognition
          Container(
            color: AppColors.grey50,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Awards & Recognition',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAwardCard('🏆', 'Best Dive Resort\n2023'),
                    _buildAwardCard('🌊', 'Marine Conservation\nAward'),
                    _buildAwardCard('⭐', '5-Star\nHospitality'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGradientStart,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionCard(String title, String content, IconData icon) {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAwardCard(String emoji, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}