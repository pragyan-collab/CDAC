// lib/screens/user/status_screen.dart
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

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> with TickerProviderStateMixin {
  int _currentIndex = 1;
  late TabController _tabController;
  final user = AuthService().currentUser;
  bool _isBusy = false;

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
    if (!mounted) return;

    setState(() {
      allApplications = DataService().getUserApplications(user?.aadhaarNumber ?? '');
      pendingApplications = allApplications.where((app) => app.status == ApplicationStatus.pending || app.status == ApplicationStatus.paymentPending).toList();
      approvedApplications = allApplications.where((app) => app.status == ApplicationStatus.approved).toList();
      rejectedApplications = allApplications.where((app) => app.status == ApplicationStatus.rejected).toList();
    });
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await action();
    } finally {
      if (mounted) {
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
        _runBusyAction(() => SafeNavigation.navigateReplacementTo(AppRoutes.home));
        break;
      case 1:
        break;
      case 2:
        _runBusyAction(() => SafeNavigation.navigateReplacementTo(AppRoutes.schemesList));
        break;
      case 3:
        _runBusyAction(() => SafeNavigation.navigateReplacementTo(AppRoutes.newsList));
        break;
      case 4:
        _runBusyAction(() => SafeNavigation.navigateReplacementTo(AppRoutes.about));
        break;
    }
  }

  void _navigateToPayment(ApplicationModel app) {
    if (_isBusy) return;
    _runBusyAction(() async {
      Navigator.pop(context);
      await SafeNavigation.navigateTo(
        AppRoutes.payment,
        arguments: {
          'amount': app.amount,
          'serviceName': app.serviceName,
          'applicationId': app.id,
        },
      );
    });
  }

  void _navigateToServices() {
    if (_isBusy) return;
    _runBusyAction(() => SafeNavigation.navigateTo(AppRoutes.services));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(148), // Changed from 128 to 148 to fix overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeaderWidget(showBackButton: false),
            Container(
              color: AppConstants.white,
              child: TabBar(
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
          ],
        ),
      ),
      body: KioskBusyOverlay(
        isBusy: _isBusy,
        message: 'Loading...',
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildApplicationList(context, allApplications),
                    _buildApplicationList(context, pendingApplications),
                    _buildApplicationList(context, approvedApplications),
                    _buildApplicationList(context, rejectedApplications),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildApplicationList(
      BuildContext context, List<ApplicationModel> applications) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    if (applications.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No applications found',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isBusy ? null : _navigateToServices,
                      child: const Text('Apply for Service'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: StatusCardWidget(
            application: applications[index],
            onTap: () => _showApplicationDetails(applications[index]),
          ),
        );
      },
    );
  }

  void _showApplicationDetails(ApplicationModel app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.serviceName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Status: ${app.statusText}'),
              Text('Application ID: ${app.id}'),
              if (app.status == ApplicationStatus.paymentPending) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isBusy ? null : () => _navigateToPayment(app),
                  child: const Text('Complete Payment'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}