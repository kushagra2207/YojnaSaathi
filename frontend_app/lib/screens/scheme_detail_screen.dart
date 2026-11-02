import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/scheme.dart';
import '../providers/starred_provider.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Scheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'pension':
        return Colors.blue;
      case 'scholarship':
        return Colors.purple;
      case 'ration':
        return Colors.orange;
      case 'housing':
        return Colors.brown;
      case 'insurance':
        return Colors.indigo;
      case 'healthcare':
        return Colors.red;
      case 'employment':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'pension':
        return 'category_pension'.tr();
      case 'scholarship':
        return 'category_scholarship'.tr();
      case 'ration':
        return 'category_ration'.tr();
      case 'housing':
        return 'category_housing'.tr();
      case 'insurance':
        return 'category_insurance'.tr();
      case 'healthcare':
        return 'category_healthcare'.tr();
      case 'employment':
        return 'category_employment'.tr();
      default:
        return 'category_other'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'scheme_detail'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<StarredProvider>(
            builder: (context, starred, child) {
              final isStarred = starred.isStarred(scheme.id, 'scheme');
              return IconButton(
                icon: Icon(
                  isStarred ? Icons.star : Icons.star_border,
                  color: isStarred ? Colors.amber : null,
                  size: 28,
                ),
                tooltip: isStarred ? 'unstar'.tr() : 'star'.tr(),
                onPressed: () {
                  starred.toggleStar(scheme.id, 'scheme');
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scheme.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                _categoryLabel(scheme.category),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: _categoryColor(scheme.category),
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'description'.tr(),
              icon: Icons.info_outline,
              content: scheme.description,
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'eligibility'.tr(),
              icon: Icons.check_circle_outline,
              content: scheme.eligibility,
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'documents_required'.tr(),
              icon: Icons.folder_open,
              content: scheme.documentsRequired,
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'where_to_apply'.tr(),
              icon: Icons.location_on_outlined,
              content: scheme.whereToApply,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
