import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const HeaderWidget({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.white,
      elevation: 2,
      shadowColor: AppConstants.primaryBlueDark.withOpacity(0.1),
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: AppConstants.primaryBlue),
        onPressed: () => Navigator.pop(context),
      )
          : Row(
        children: [
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/emblem.png',
            height: 32,
            width: 32,
          ),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConstants.primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppStrings.tagline,
            style: const TextStyle(
              color: AppConstants.textMedium,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        ...?actions,
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
            width: 40,
          ),
        ),
      ],
    );
  }
}