// lib/screens/info/news_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 3;
  late TabController _tabController;

  final List<Map<String, dynamic>> newsItems = [
    {
      'id': 1,
      'title': 'New Digital India Initiative Launched',
      'summary': 'Government launches new initiative to digitize government services',
      'content': 'The Government of India today launched a new initiative to bring all government services online...',
      'date': '15 Mar 2024',
      'category': 'National',
      'image': Icons.newspaper,
      'important': true,
    },
    {
      'id': 2,
      'title': 'PM Awas Yojana Deadline Extended',
      'summary': 'Last date for PM Awas Yojana applications extended to 31st December',
      'content': 'In a major relief to applicants, the government has extended the deadline for PM Awas Yojana...',
      'date': '14 Mar 2024',
      'category': 'Scheme',
      'image': Icons.home,
      'important': true,
    },
    {
      'id': 3,
      'title': 'New Tax Filing Portal Launched',
      'summary': 'Simplified tax filing process for citizens',
      'content': 'The Income Tax Department has launched a new user-friendly portal for tax filing...',
      'date': '13 Mar 2024',
      'category': 'Tax',
      'image': Icons.account_balance,
      'important': false,
    },
    {
      'id': 4,
      'title': 'Digital Payment Rewards Scheme',
      'summary': 'Cashback and rewards for digital payments',
      'content': 'To promote digital payments, government announces cashback scheme for UPI transactions...',
      'date': '12 Mar 2024',
      'category': 'Digital',
      'image': Icons.payment,
      'important': false,
    },
    {
      'id': 5,
      'title': 'New Passport Seva Kendra Opens',
      'summary': '10 new Passport Seva Kendras inaugurated across the country',
      'content': 'Ministry of External Affairs inaugurates 10 new Passport Seva Kendras to streamline passport services...',
      'date': '11 Mar 2024',
      'category': 'Service',
      'image': Icons.flight,
      'important': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        SafeNavigation.navigateReplacementTo(AppRoutes.home);
        break;
      case 1:
        SafeNavigation.navigateReplacementTo(AppRoutes.services);
        break;
      case 2:
        SafeNavigation.navigateReplacementTo(AppRoutes.schemesList);
        break;
      case 3:
        break;
      case 4:
        SafeNavigation.navigateReplacementTo(AppRoutes.about);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
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
                  Tab(text: 'All'),
                  Tab(text: 'Important'),
                  Tab(text: 'Updates'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(newsItems),
          _buildNewsList(newsItems.where((n) => n['important'] == true).toList()),
          _buildNewsList(newsItems.where((n) => n['category'] == 'Update').toList()),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildNewsList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: 64,
              color: AppConstants.textMedium.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No news available',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textMedium,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final news = items[index];
        return _buildNewsCard(news);
      },
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showNewsDetails(news);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  news['image'],
                  size: 30,
                  color: AppConstants.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            news['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textDark,
                            ),
                          ),
                        ),
                        if (news['important'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'IMPORTANT',
                              style: TextStyle(
                                color: AppConstants.primaryOrange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news['summary'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news['category'],
                            style: const TextStyle(
                              color: AppConstants.primaryBlue,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          news['date'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewsDetails(Map<String, dynamic> news) {
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

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          news['image'],
                          color: AppConstants.primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news['category'],
                              style: TextStyle(
                                color: AppConstants.textMedium,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              news['date'],
                              style: TextStyle(
                                color: AppConstants.textMedium,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (news['important'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'IMPORTANT',
                            style: TextStyle(
                              color: AppConstants.primaryOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    news['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        news['content'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppConstants.textMedium,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Share Button
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share feature coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share News'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryBlue,
                      side: const BorderSide(color: AppConstants.primaryBlue),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}