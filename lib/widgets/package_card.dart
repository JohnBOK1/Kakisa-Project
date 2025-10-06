import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'tropical_button.dart';

class PackageCard extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final String buttonText;
  final IconData? buttonIcon;
  final bool centerTitle;
  final List<String> features;

  const PackageCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    required this.buttonText,
    this.buttonIcon,
    this.centerTitle = false,
    this.features = const [],
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) => _hoverController.reverse(),
      onTapCancel: () => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    _buildImage(),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: widget.centerTitle 
                            ? CrossAxisAlignment.center 
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey800,
                            ),
                            textAlign: widget.centerTitle 
                                ? TextAlign.center 
                                : TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey600,
                            ),
                            textAlign: widget.centerTitle 
                                ? TextAlign.center 
                                : TextAlign.start,
                          ),
                          const SizedBox(height: 16),
                           if (widget.features.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.features.map((f) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "• ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.grey700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grey700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                          ],

                          SizedBox(
                            width: double.infinity,
                            child: TropicalButton(
                              text: widget.buttonText,
                              icon: widget.buttonIcon,
                              size: TropicalButtonSize.small,
                              onPressed: widget.onTap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage() {
  final bool isAsset = !widget.imageUrl.startsWith('http');

  return Stack(
    children: [
      SizedBox(
        height: 192,
        width: double.infinity,
        child: isAsset
            ? Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
              )
            : Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey200,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: AppColors.grey400,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.grey200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      Positioned(
        top: 16,
        left: 16,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

}