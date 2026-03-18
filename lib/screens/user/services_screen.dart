import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
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

  void _filterServices(String query) {
    setState(() {
      filteredServices = allServices.where((service) {
        final nameLower = service['name'].toLowerCase();
        final categoryLower = service['category'].toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) || categoryLower.contains(searchLower);
      }).toList();

      if (selectedCategory != 'All') {
        filteredServices = filteredServices.where((s) => s['category'] == selectedCategory).toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredServices = allServices.where((s) {
        final matchesCategory = category == 'All' || s['category'] == category;
        final matchesSearch = _searchController.text.isEmpty ||
            s['name'].toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...allServices.map((s) => s['category'] as String).toSet()];

    return Scaffold(
      appBar: const HeaderWidget(title: 'Services', showBackButton: false),
      body: Column(
        children: [
          // Search Bar
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

          // Category Chips
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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppConstants.primaryBlue : AppConstants.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Services Grid
          Expanded(
            child: filteredServices.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppConstants.textMedium.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No services found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.textMedium,
                    ),
                  ),
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
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.apply,
                      arguments: {'service': service['name']},
                    );
                  },
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
                          child: Icon(
                            service['icon'],
                            color: service['color'],
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            service['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppConstants.textDark,
                            ),
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
}