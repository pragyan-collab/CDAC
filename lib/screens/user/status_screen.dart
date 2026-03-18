import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/status_card.dart';
import '../../models/application_model.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 1;
  late TabController _tabController;

  final user = AuthService().currentUser;
  List<ApplicationModel> allApplications = [];
  List<ApplicationModel> pendingApplications = [];
  List<ApplicationModel> approvedApplications = [];
  List<ApplicationModel> rejectedApplications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadApplications();
  }

  void _loadApplications() {
    allApplications = DataService().getUserApplications(user?.aadhaarNumber ?? '');

    pendingApplications = allApplications
        .where((app) => app.status == ApplicationStatus.pending ||
        app.status == ApplicationStatus.paymentPending)
        .toList();

    approvedApplications = allApplications
        .where((app) => app.status == ApplicationStatus.approved)
        .toList();

    rejectedApplications = allApplications
        .where((app) => app.status == ApplicationStatus.rejected)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.white,
        elevation: 2,
        title: const Text(
          'Application Status',
          style: TextStyle(
            color: AppConstants.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.primaryBlue,
          labelColor: AppConstants.primaryBlue,
          unselectedLabelColor: AppConstants.textMedium,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.list)),
            Tab(text: 'Pending', icon: Icon(Icons.pending)),
            Tab(text: 'Approved', icon: Icon(Icons.check_circle)),
            Tab(text: 'Rejected', icon: Icon(Icons.cancel)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApplicationList(allApplications),
          _buildApplicationList(pendingApplications),
          _buildApplicationList(approvedApplications),
          _buildApplicationList(rejectedApplications),
        ],
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
            // Already here
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

  Widget _buildApplicationList(List<ApplicationModel> applications) {
    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: AppConstants.textMedium.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 18,
                color: AppConstants.textMedium,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.services);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryBlue,
              ),
              child: const Text('Apply for Service'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final app = applications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StatusCardWidget(
            application: app,
            onTap: () {
              _showApplicationDetails(app);
            },
          ),
        );
      },
    );
  }

  void _showApplicationDetails(ApplicationModel app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppConstants.textMedium.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header with status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.serviceName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: app.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          app.statusText,
                          style: TextStyle(
                            color: app.statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Application details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstants.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppConstants.buttonShadow,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Application ID', app.id),
                        _buildDetailRow('Applied Date',
                            '${app.appliedDate.day}/${app.appliedDate.month}/${app.appliedDate.year}'),
                        _buildDetailRow('Applicant Name', app.formData['name'] ?? 'N/A'),
                        if (app.amount != null)
                          _buildDetailRow('Fee Amount', '₹${app.amount}'),
                        if (app.paymentId != null)
                          _buildDetailRow('Payment ID', app.paymentId!),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Timeline
                  const Text(
                    'Application Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildTimelineItem(
                    'Application Submitted',
                    app.appliedDate,
                    true,
                    isFirst: true,
                  ),

                  _buildTimelineItem(
                    'Document Verification',
                    app.appliedDate.add(const Duration(days: 1)),
                    app.status != ApplicationStatus.pending,
                  ),

                  _buildTimelineItem(
                    'Payment',
                    app.appliedDate.add(const Duration(days: 2)),
                    app.status != ApplicationStatus.paymentPending &&
                        app.status != ApplicationStatus.pending,
                  ),

                  _buildTimelineItem(
                    'Final Approval',
                    app.appliedDate.add(const Duration(days: 5)),
                    app.status == ApplicationStatus.approved,
                    isLast: true,
                  ),

                  if (app.status == ApplicationStatus.paymentPending) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.payment,
                            arguments: {
                              'amount': app.amount,
                              'serviceName': app.serviceName,
                              'applicationId': app.id,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Complete Payment',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppConstants.textMedium,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime date, bool isCompleted, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                height: 20,
                width: 2,
                color: isCompleted
                    ? AppConstants.successGreen
                    : AppConstants.textMedium.withOpacity(0.3),
              ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppConstants.successGreen
                    : AppConstants.textMedium.withOpacity(0.3),
                border: Border.all(
                  color: AppConstants.white,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                Icons.check,
                size: 10,
                color: AppConstants.white,
              )
                  : null,
            ),
            if (!isLast)
              Container(
                height: 30,
                width: 2,
                color: isCompleted
                    ? AppConstants.successGreen
                    : AppConstants.textMedium.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: isFirst ? 0 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? AppConstants.textDark : AppConstants.textMedium,
                  ),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}