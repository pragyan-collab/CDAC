import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/header_widget.dart';
import '../../models/application_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<ApplicationModel> pendingApplications = [];
  List<ApplicationModel> recentApprovals = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      pendingApplications = DataService().getPendingApplications();
      recentApprovals = DataService()
          .getPendingApplications() // Replace with approved applications
          .take(5)
          .toList();
    });
  }

  void _logout() {
    AuthService().logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.white,
        elevation: 2,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: AppConstants.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppConstants.primaryBlue),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppConstants.errorRed),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Pending',
                  pendingApplications.length.toString(),
                  AppConstants.primaryOrange,
                  Icons.pending_actions,
                ),
                _buildStatCard(
                  'Approved',
                  '24',
                  AppConstants.successGreen,
                  Icons.check_circle,
                ),
                _buildStatCard(
                  'Rejected',
                  '5',
                  AppConstants.errorRed,
                  Icons.cancel,
                ),
                _buildStatCard(
                  'Total',
                  '156',
                  AppConstants.primaryBlue,
                  Icons.assignment,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Pending Applications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Applications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (pendingApplications.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: AppConstants.successGreen,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No pending applications',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.textMedium,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingApplications.length,
                itemBuilder: (context, index) {
                  final app = pendingApplications[index];
                  return _buildPendingCard(app);
                },
              ),

            const SizedBox(height: 24),

            // Recent Approvals
            const Text(
              'Recent Approvals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentApprovals.length,
              itemBuilder: (context, index) {
                final app = recentApprovals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.successGreen.withOpacity(0.1),
                      child: const Icon(
                        Icons.check,
                        color: AppConstants.successGreen,
                        size: 20,
                      ),
                    ),
                    title: Text(app.serviceName),
                    subtitle: Text('ID: ${app.id}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.buttonShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(ApplicationModel app) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.adminDetail,
            arguments: {'application': app},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      app.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                        color: AppConstants.primaryOrange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Application ID: ${app.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Applicant: ${app.formData['name']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.adminDetail,
                        arguments: {'application': app},
                      );
                    },
                    child: const Text('Review'),
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