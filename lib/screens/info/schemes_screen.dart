import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/data_service.dart';
import '../../widgets/safe_navigation.dart';
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
  Timer? _debounce;

  List<SchemeModel> allSchemes = [];
  List<SchemeModel> filteredSchemes = [];

  @override
  void initState() {
    super.initState();

    final dataService = DataService();
    allSchemes = dataService.getSchemes();
    filteredSchemes = allSchemes;

    // 🔥 Debounced search (better performance)
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterSchemes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _filterSchemes(String query) {
    final trimmedQuery = query.trim().toLowerCase();

    setState(() {
      if (trimmedQuery.isEmpty) {
        filteredSchemes = allSchemes;
      } else {
        filteredSchemes = allSchemes.where((scheme) {
          return scheme.title.toLowerCase().contains(trimmedQuery) ||
              scheme.description.toLowerCase().contains(trimmedQuery) ||
              scheme.department.toLowerCase().contains(trimmedQuery);
        }).toList();
      }
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
        SafeNavigation.navigateReplacementTo(AppRoutes.services);
        break;
      case 2:
        break;
      case 3:
        SafeNavigation.navigateReplacementTo(AppRoutes.newsList);
        break;
      case 4:
        SafeNavigation.navigateReplacementTo(AppRoutes.about);
        break;
    }
  }

  void _navigateToSchemeDetail(SchemeModel scheme) {
    SafeNavigation.navigateTo(
      AppRoutes.schemeDetail,
      arguments: {'scheme': scheme},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildSchemeList()),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  // 🔍 SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppConstants.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search schemes...',
          prefixIcon:
          const Icon(Icons.search, color: AppConstants.primaryBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
    );
  }

  // 📋 LIST
  Widget _buildSchemeList() {
    if (filteredSchemes.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSchemes.length,
      itemBuilder: (context, index) {
        return _buildSchemeCard(filteredSchemes[index]);
      },
    );
  }

  // ❌ EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 70,
            color: AppConstants.textMedium.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No schemes found',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 📦 CARD
  Widget _buildSchemeCard(SchemeModel scheme) {
    final now = DateTime.now();
    final daysLeft = scheme.lastDate.difference(now).inDays;
    final isExpired = daysLeft < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToSchemeDetail(scheme),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTitleSection(scheme)),
                  _buildStatusBadge(daysLeft, isExpired),
                ],
              ),
              const SizedBox(height: 12),
              _buildDescription(scheme),
              const SizedBox(height: 12),
              _buildFooter(scheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
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
    );
  }

  Widget _buildTitleSection(SchemeModel scheme) {
    return Column(
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
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(int daysLeft, bool isExpired) {
    if (isExpired) {
      return _buildBadge('Expired', AppConstants.errorRed);
    } else if (daysLeft < 30) {
      return _buildBadge('$daysLeft days left', AppConstants.primaryOrange);
    }
    return const SizedBox();
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescription(SchemeModel scheme) {
    return Text(
      scheme.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        color: AppConstants.textMedium,
      ),
    );
  }

  Widget _buildFooter(SchemeModel scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today,
                size: 14, color: AppConstants.textMedium),
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
        const Icon(Icons.arrow_forward_ios,
            size: 14, color: AppConstants.primaryBlue),
      ],
    );
  }
}