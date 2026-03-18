import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/data_service.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import '../../models/scheme_model.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({Key? key}) : super(key: key);

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  int _currentIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  List<SchemeModel> allSchemes = [];
  List<SchemeModel> filteredSchemes = [];

  @override
  void initState() {
    super.initState();
    allSchemes = DataService().getSchemes();
    filteredSchemes = allSchemes;
  }

  void _filterSchemes(String query) {
    setState(() {
      filteredSchemes = allSchemes.where((scheme) {
        return scheme.title.toLowerCase().contains(query.toLowerCase()) ||
            scheme.description.toLowerCase().contains(query.toLowerCase()) ||
            scheme.department.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppConstants.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterSchemes,
              decoration: InputDecoration(
                hintText: 'Search schemes...',
                prefixIcon: const Icon(Icons.search, color: AppConstants.primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppConstants.pageBg,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterSchemes('');
                  },
                )
                    : null,
              ),
            ),
          ),

          // Schemes List
          Expanded(
            child: filteredSchemes.isEmpty
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
                    'No schemes found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.textMedium,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredSchemes.length,
              itemBuilder: (context, index) {
                final scheme = filteredSchemes[index];
                return _buildSchemeCard(scheme);
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
              Navigator.pushReplacementNamed(context, AppRoutes.services);
              break;
            case 2:
            // Already here
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

  Widget _buildSchemeCard(SchemeModel scheme) {
    final daysLeft = scheme.lastDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.schemeDetail,
            arguments: {'scheme': scheme},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.description,
                      color: AppConstants.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textDark,
                          ),
                        ),
                        Text(
                          scheme.department,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (daysLeft < 30)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$daysLeft days left',
                        style: const TextStyle(
                          color: AppConstants.primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scheme.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textMedium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppConstants.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Last Date: ${scheme.lastDate.day}/${scheme.lastDate.month}/${scheme.lastDate.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.textMedium,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppConstants.primaryBlue,
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