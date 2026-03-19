// lib/screens/user/services_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allServices = [
    {'name': 'Birth Certificate', 'icon': Icons.child_care, 'category': 'Certificates', 'color': Colors.blue},
    {'name': 'Death Certificate', 'icon': Icons.heart_broken, 'category': 'Certificates', 'color': Colors.grey},
    {'name': 'Marriage Certificate', 'icon': Icons.favorite, 'category': 'Certificates', 'color': Colors.pink},
    {'name': 'Income Certificate', 'icon': Icons.attach_money, 'category': 'Certificates', 'color': Colors.green},
    {'name': 'Caste Certificate', 'icon': Icons.people, 'category': 'Certificates', 'color': Colors.orange},
    {'name': 'Residence Certificate', 'icon': Icons.home, 'category': 'Certificates', 'color': Colors.brown},
    {'name': 'Passport Application', 'icon': Icons.flight, 'category': 'Travel', 'color': Colors.indigo},
    {'name': 'Driving License', 'icon': Icons.drive_eta, 'category': 'Transport', 'color': Colors.teal},
    {'name': 'Voter ID', 'icon': Icons.how_to_vote, 'category': 'Identity', 'color': Colors.deepPurple},
    {'name': 'PAN Card', 'icon': Icons.credit_card, 'category': 'Identity', 'color': Colors.amber},
    {'name': 'Ration Card', 'icon': Icons.food_bank, 'category': 'Food', 'color': Colors.lightGreen},
    {'name': 'Property Tax', 'icon': Icons.account_balance, 'category': 'Tax', 'color': Colors.cyan},
  ];

  List<Map<String, dynamic>> filteredServices = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredServices = allServices;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices(String query) {
    setState(() {
      filteredServices = allServices.where((service) {
        return service['name'].toLowerCase().contains(query.toLowerCase()) ||
            service['category'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterServices(_searchController.text);
    });
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        SafeNavigation.navigateReplacementTo(AppRoutes.home);
        break;
      case 1:
        break;
      case 2:
        SafeNavigation.navigateReplacementTo(AppRoutes.schemesList);
        break;
      case 3:
        SafeNavigation.navigateReplacementTo(AppRoutes.newsList);
        break;
      case 4:
        SafeNavigation.navigateReplacementTo(AppRoutes.about);
        break;
    }
  }

  void _navigateToApply(String serviceName) {
    SafeNavigation.navigateTo(
      AppRoutes.apply,
      arguments: {'service': serviceName},
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...allServices.map((s) => s['category'] as String).toSet()];

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppConstants.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterServices,
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search, color: AppConstants.primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppConstants.pageBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Container(
            height: 50,
            color: AppConstants.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _filterByCategory(category),
                    backgroundColor: AppConstants.white,
                    selectedColor: AppConstants.primaryBlue.withOpacity(0.1),
                    checkmarkColor: AppConstants.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? AppConstants.primaryBlue : AppConstants.textDark,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredServices.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: AppConstants.textMedium.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No services found', style: TextStyle(fontSize: 16, color: AppConstants.textMedium)),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return InkWell(
                  onTap: () => _navigateToApply(service['name']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppConstants.buttonShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: service['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(service['icon'], color: service['color'], size: 30),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            service['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppConstants.textDark),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}