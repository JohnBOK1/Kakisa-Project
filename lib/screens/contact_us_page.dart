import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../main.dart';
import '../utils/app_colors.dart';
import '../widgets/tropical_button.dart';

class ContactUsPage extends StatefulWidget {
  final Function(PageType) onNavigate;

  const ContactUsPage({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _formAnimationController;
  
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isSubmitted = false;

  final List<ContactInfo> _contactInfo = const [
    ContactInfo(
      icon: Icons.location_on,
      title: 'Address',
      details: [
        'National Highway',
        'Bacong, Negros Oriental',
        'Philippines'
      ],
    ),
    ContactInfo(
      icon: Icons.phone,
      title: 'Phone Numbers',
      details: [
        'Mobile: 09978919901',
        'Mobile: 09753648107',
        'Landline: 5274882'
      ],
    ),
    ContactInfo(
      icon: Icons.access_time,
      title: 'Operating Hours',
      details: [
        'Daily: 6:00 AM - 10:00 PM',
        'Events by appointment',
        '24/7 for guests'
      ],
    ),
    ContactInfo(
      icon: Icons.local_parking,
      title: 'Parking',
      details: [
        'Free parking available',
        '24/7 security',
        'Ample space for events'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _heroAnimationController.forward();
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _formAnimationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitted = true);
    _formAnimationController.forward();
    
    // Reset form after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSubmitted = false;
          _fullNameController.clear();
          _emailController.clear();
          _messageController.clear();
        });
        _formAnimationController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          _buildHeroSection(),
          
          // Main Content
          _buildMainContent(),
          
          // Map Section
          _buildMapSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 384,
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Slide 1.jpg',
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
                animation: _heroAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _heroAnimationController.value)),
                    child: Opacity(
                      opacity: _heroAnimationController.value,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Get in touch to plan your perfect getaway',
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
            // Contact Information
            _buildContactInformation(),
            
            const SizedBox(height: 64),
            
            // Contact Form and Image
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildContactForm()),
                      const SizedBox(width: 48),
                      Expanded(child: _buildContactImage()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildContactForm(),
                      const SizedBox(height: 48),
                      _buildContactImage(),
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

  Widget _buildContactInformation() {
    return Column(
      children: [
        const Text(
          'Get in Touch',
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
                children: _contactInfo.asMap().entries.map((entry) {
                  final index = entry.key;
                  final info = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildContactInfoCard(info, index),
                  );
                }).toList(),
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.9,
                ),
                itemCount: _contactInfo.length,
                itemBuilder: (context, index) {
                  return _buildContactInfoCard(_contactInfo[index], index);
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(ContactInfo info, int index) {
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
              info.icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            info.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...info.details.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
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
            'Send us a Message',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 24),
          
          if (_isSubmitted)
            _buildSubmissionSuccess()
          else
            _buildContactFormFields(),
        ],
      ),
    );
  }

  Widget _buildSubmissionSuccess() {
    return AnimatedBuilder(
      animation: _formAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * _formAnimationController.value,
          child: Opacity(
            opacity: _formAnimationController.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Message Sent!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thank you for contacting us. We\'ll get back to you soon!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
            controller: _fullNameController,
            label: 'Full Name *',
            hint: 'Enter your full name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildTextFormField(
            controller: _emailController,
            label: 'Email *',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildTextFormField(
            controller: _messageController,
            label: 'Message *',
            hint: 'Tell us how we can help you...',
            maxLines: 6,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a message';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: TropicalButton(
              text: 'Send Message',
              icon: Icons.send,
              onPressed: _handleSubmit,
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

  Widget _buildContactImage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 256,
            width: double.infinity,
            child: Image.asset(
              'assets/images/Slide 4.jpg',
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
        ),
        const SizedBox(height: 24),
        
        Container(
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
              const Text(
                'Visit Our Resort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Experience the beauty of KAKISA Dive Resort in person. We\'re open daily and welcome visitors to explore our facilities and discuss your event needs.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TropicalButton(
                text: 'Plan a Visit',
                size: TropicalButtonSize.small,
                onPressed: () => widget.onNavigate(PageType.bookNow),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
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
            children: [
              const Text(
                'Quick Response',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                  children: [
                    TextSpan(text: 'Need immediate assistance? Call us directly at '),
                    TextSpan(
                      text: '09978919901',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' for quick responses to your inquiries.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF9FAFB), // gray-50
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            const Text(
              'Find Us',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Located along the beautiful coastline of Negros Oriental',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFECFEFF), // cyan-100
                    Color(0xFFDDEEFF), // blue-100
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
                      Icons.location_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'KAKISA Dive Resort',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'National Highway, Bacong, Negros Oriental, Philippines',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Easily accessible via the main highway with ample parking space for guests and events.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfo {
  final IconData icon;
  final String title;
  final List<String> details;

  const ContactInfo({
    required this.icon,
    required this.title,
    required this.details,
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