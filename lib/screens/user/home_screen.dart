import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final user = AuthService().currentUser;

  final List<Map<String, dynamic>> quickServices = [
    {'icon': Icons.description, 'label': 'Apply', 'color': AppConstants.primaryBlue},
    {'icon': Icons.upload_file, 'label': 'Upload', 'color': AppConstants.primaryOrange},
    {'icon': Icons.payment, 'label': 'Pay', 'color': AppConstants.successGreen},
    {'icon': Icons.track_changes, 'label': 'Track', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(title: 'Home', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
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
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: const TextStyle(
                            color: AppConstants.textMedium,
                            fontSize: 14,
                          ),
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

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: quickServices.map((service) {
                return InkWell(
                  onTap: () {
                    String route;
                    switch(service['label'].toLowerCase()) {
                      case 'apply':
                        route = AppRoutes.apply;
                        break;
                      case 'upload':
                        route = AppRoutes.upload;
                        break;
                      case 'pay':
                        route = AppRoutes.payment;
                        break;
                      case 'track':
                        route = AppRoutes.status;
                        break;
                      default:
                        route = AppRoutes.home;
                    }
                    Navigator.pushNamed(context, route);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: service['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          service['icon'],
                          color: service['color'],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['label'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.textDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Recent Applications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Applications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.status);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent applications list
            ...DataService()
                .getUserApplications(user?.aadhaarNumber ?? '')
                .take(3)
                .map((app) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: StatusCardWidget(
                application: app,
                onTap: () {
                  // Navigate to application detail
                },
              ),
            )),

            const SizedBox(height: 24),

            // Announcement Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConstants.primaryBlue, AppConstants.primaryBlueDark],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.campaign,
                    color: AppConstants.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'New Scheme Launched!',
                          style: TextStyle(
                            color: AppConstants.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'PM Awas Yojana - Apply now',
                          style: TextStyle(
                            color: AppConstants.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: AppConstants.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.schemesList);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch(index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.services);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.schemesList);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.newsList);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.about);
              break;
          }
        },
      ),
    );
  }
}