// lib/screens/user/home_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/kiosk_busy_overlay.dart';
import '../../widgets/status_card.dart';
import '../../models/application_model.dart';
import '../../widgets/skeleton/kiosk_skeleton_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final user = AuthService().currentUser;
  bool _isBusy = false;
  bool _isRecentLoading = true;
  List<ApplicationModel> _recentApplications = [];

  @override
  void initState() {
    super.initState();
    _loadRecentApplications();
  }

  Future<void> _loadRecentApplications() async {
    setState(() => _isRecentLoading = true);
    try {
      // Simulate slow kiosk network/data fetch to keep skeleton visible briefly.
      await Future.delayed(const Duration(milliseconds: 900));
      final apps = DataService().getUserApplications(user?.aadhaarNumber ?? '');
      if (!mounted) return;
      setState(() {
        _recentApplications = apps.take(3).toList();
        _isRecentLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRecentLoading = false);
    }
  }

  final List<Map<String, dynamic>> quickServices = [
    {'icon': Icons.description, 'label': 'Apply', 'color': AppConstants.primaryBlue, 'route': AppRoutes.apply},
    {'icon': Icons.payment, 'label': 'Pay', 'color': AppConstants.successGreen, 'route': AppRoutes.pay},
    {'icon': Icons.track_changes, 'label': 'Track', 'color': Colors.purple, 'route': AppRoutes.status},
  ];

  Future<void> _runBusyNavigation(Future<void> Function() action) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        // Short delay makes the loader feel intentional on fast route pushes.
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) setState(() => _isBusy = false);
      }
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    if (_isBusy) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        _runBusyNavigation(() => SafeNavigation.navigateReplacementTo(AppRoutes.services));
        break;
      case 2:
        _runBusyNavigation(() => SafeNavigation.navigateReplacementTo(AppRoutes.schemesList));
        break;
      case 3:
        _runBusyNavigation(() => SafeNavigation.navigateReplacementTo(AppRoutes.newsList));
        break;
      case 4:
        _runBusyNavigation(() => SafeNavigation.navigateReplacementTo(AppRoutes.about));
        break;
    }
  }

  Future<void> _navigateToScreen(String route) {
    return SafeNavigation.navigateTo(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: KioskBusyOverlay(
        isBusy: _isBusy,
        message: 'Loading...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppConstants.buttonShadow,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppConstants.primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.person,
                            size: 40, color: AppConstants.primaryBlue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                  color: AppConstants.textMedium, fontSize: 14),
                            ),
                            Text(
                              user?.name ?? 'User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: quickServices.map((service) {
                    return Expanded(
                      child: InkWell(
                        onTap: _isBusy
                            ? null
                            : () => _runBusyNavigation(
                                  () => _navigateToScreen(service['route']),
                                ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (service['color'] as Color).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                service['icon'] as IconData,
                                color: service['color'],
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service['label'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppConstants.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Applications',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textDark),
                    ),
                    TextButton(
                      onPressed: _isBusy
                          ? null
                          : () => _runBusyNavigation(
                                () => _navigateToScreen(AppRoutes.status),
                              ),
                      child: const Text('View All'),
                    ),
                  ],
                ),
            const SizedBox(height: 16),
            if (_isRecentLoading)
              Column(
                children: const [
                  KioskSkeletonRecentCard(height: 112),
                  KioskSkeletonRecentCard(height: 112),
                  KioskSkeletonRecentCard(height: 112),
                ],
              )
            else if (_recentApplications.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'No recent applications found.',
                  style: TextStyle(color: AppConstants.textMedium),
                ),
              )
            else
              Column(
                children: _recentApplications.map((app) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: StatusCardWidget(
                      application: app,
                      onTap: _isBusy
                          ? null
                          : () => _runBusyNavigation(
                                () => _navigateToScreen(AppRoutes.status),
                              ),
                    ),
                  );
                }).toList(),
              ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppConstants.primaryBlue, AppConstants.primaryBlueDark]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppConstants.buttonShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.campaign,
                          color: AppConstants.white, size: 32),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Scheme Launched!',
                              style: TextStyle(
                                color: AppConstants.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'PM Kisan - Apply now',
                              style: TextStyle(
                                color: AppConstants.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: AppConstants.white),
                        onPressed: _isBusy
                            ? null
                            : () => _runBusyNavigation(
                                  () => _navigateToScreen(AppRoutes.schemesList),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isBusy ? null : () => _runBusyNavigation(() => _navigateToScreen(AppRoutes.chatbot)),
        backgroundColor: AppConstants.primaryBlue,
        child: const Icon(Icons.chat_bubble, color: AppConstants.white),
      ),
    );
  }
}