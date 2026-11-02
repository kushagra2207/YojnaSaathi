import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/health_notice.dart';

class HealthNoticeCard extends StatelessWidget {
  final HealthNotice notice;
  final VoidCallback onTap;

  const HealthNoticeCard({
    super.key,
    required this.notice,
    required this.onTap,
  });

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'camp':
        return Colors.green;
      case 'notice':
        return Colors.blue;
      case 'outbreak_warning':
        return Colors.red;
      case 'medicine_availability':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'camp':
        return Icons.local_hospital;
      case 'notice':
        return Icons.info_outline;
      case 'outbreak_warning':
        return Icons.warning_amber_rounded;
      case 'medicine_availability':
        return Icons.medication;
      default:
        return Icons.article;
    }
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'camp':
        return 'type_camp'.tr();
      case 'notice':
        return 'type_notice'.tr();
      case 'outbreak_warning':
        return 'type_outbreak_warning'.tr();
      case 'medicine_availability':
        return 'type_medicine_availability'.tr();
      default:
        return type;
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
              Row(
                children: [
                  Icon(
                    _typeIcon(notice.type),
                    size: 20,
                    color: _typeColor(notice.type),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notice.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Chip(
                    label: Text(
                      _typeLabel(notice.type),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: _typeColor(notice.type),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (notice.eventDate != null && notice.eventDate!.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notice.eventDate!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
