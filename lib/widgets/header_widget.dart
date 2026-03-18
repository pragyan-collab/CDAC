// lib/widgets/header_widget.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const HeaderWidget({
    Key? key,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppConstants.white,
      child: Padding(
        padding: EdgeInsets.only(top: padding),
        child: Container(
          height: 100 - padding,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Emblem (Larger)
              Container(
                width: 100,
                height: 85,
                child: Image.asset(
                  'assets/images/emblem.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),

              // Right side - Back button (if needed) and Logo
              Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: AppConstants.primaryBlue, size: 24),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    ),
                  ],
                  // Logo (Larger)
                  Container(
                    width: 100,
                    height: 45,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text(
                              'Logo',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}