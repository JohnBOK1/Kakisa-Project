import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';
import '../widgets/package_card.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.tropicalGradient,
              ),
            ),
            child: Stack(
              children: [
                // Wave decoration
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to Paradise',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Experience luxury and tranquility at KAKISA Dive Resort',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TropicalButton(
                        text: 'Book Your Stay',
                        onPressed: () {
                          // Navigate to booking
                        },
                        size: TropicalButtonSize.large,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // About Us Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'About KAKISA Dive Resort',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nestled in the pristine waters of Bacong, Negros Oriental, Philippines, KAKISA Dive Resort offers an unparalleled tropical experience. Our resort combines luxury accommodations with world-class diving opportunities and exceptional event hosting capabilities.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
             Image.asset(
  'assets/images/Image 1.jpg',
  height: MediaQuery.of(context).size.height * 0.25,
  width: double.infinity,
  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
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
              ],
            ),
          ),

          // Features Section
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Resort Features',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    FeatureCard(
                      icon: Icons.pool,
                      title: 'Ocean Access',
                      description: 'Direct beach access with crystal clear waters',
                    ),
                    FeatureCard(
                      icon: Icons.restaurant,
                      title: 'Fine Dining',
                      description: 'Exquisite local and international cuisine',
                    ),
                    FeatureCard(
                      icon: Icons.event,
                      title: 'Event Hosting',
                      description: 'Perfect venue for weddings and celebrations',
                    ),
                    FeatureCard(
                      icon: Icons.hotel,
                      title: 'Luxury Rooms',
                      description: 'Comfortable accommodations with ocean views',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Catering Packages Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Catering Packages',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose from our carefully crafted catering options',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    PackageCard(
                      title: 'Standard Package',
                      price: '₱400',
                      description: 'Perfect for casual dining with essential amenities',
                      imageUrl: 'assets/images/Package1.jpg',
                      buttonText: 'Book Now',    
                      features: const [
                        '2 Main Dishes',
                        'Rice & Noodles',
                        'Basic Setup',
                        'Standard Service',
                      ],
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    PackageCard(
                      title: 'Premium Package',
                      price: '₱450',
                      description: 'Enhanced dining experience with premium selections',
                        imageUrl: 'assets/images/Package2.jpg',
                      buttonText: 'Book Now', 
                      features: const [
                        '3 Main Dishes',
                        'Rice & Noodles',
                        'Dessert/Vegetable',
                        'Premium Setup',
                      ],
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    PackageCard(
                      title: 'Deluxe Package',
                      price: '₱500',
                      description: 'Ultimate luxury dining with exclusive amenities',
                        imageUrl: 'assets/images/Package3.jpg',
                      buttonText: 'Book Now', 
                      features: const [
                        '4 Main Dishes',
                        'Rice & Premium Noodles',
                        'Dessert & Vegetable',
                        'Luxury Setup',
                      ],
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Resort Access Rates Section
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Resort Access Rates',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '₱100',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '₱60',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Footer
          Container(
            color: AppColors.grey800,
            padding: const EdgeInsets.all(24.0),
            child: const Column(
              children: [
                Text(
                  'KAKISA Dive Resort',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bacong, Negros Oriental, Philippines',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey300,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '© 2024 KAKISA Dive Resort. All rights reserved.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}