import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/scheme.dart';

class SchemeCard extends StatelessWidget {
  final Scheme scheme;
  final VoidCallback onTap;

  const SchemeCard({
    super.key,
    required this.scheme,
    required this.onTap,
  });

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scheme.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                scheme.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Chip(
                label: Text(
                  _categoryLabel(scheme.category),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: _categoryColor(scheme.category),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
