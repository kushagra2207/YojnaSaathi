import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/health_notice.dart';
import '../providers/starred_provider.dart';

class HealthNoticeDetailScreen extends StatelessWidget {
  final HealthNotice notice;

  const HealthNoticeDetailScreen({super.key, required this.notice});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'notice_detail'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<StarredProvider>(
            builder: (context, starred, child) {
              final isStarred = starred.isStarred(notice.id, 'health_notice');
              return IconButton(
                icon: Icon(
                  isStarred ? Icons.star : Icons.star_border,
                  color: isStarred ? Colors.amber : null,
                  size: 28,
                ),
                tooltip: isStarred ? 'unstar'.tr() : 'star'.tr(),
                onPressed: () {
                  starred.toggleStar(notice.id, 'health_notice');
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
              notice.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(
                    _typeLabel(notice.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: _typeColor(notice.type),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'description'.tr(),
              icon: Icons.info_outline,
              content: notice.description,
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'location'.tr(),
              icon: Icons.location_on_outlined,
              content: notice.location,
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'event_date'.tr(),
              icon: Icons.calendar_today,
              content: (notice.eventDate != null && notice.eventDate!.isNotEmpty)
                  ? notice.eventDate!
                  : 'no_event_date'.tr(),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'type'.tr(),
              icon: Icons.category,
              content: _typeLabel(notice.type),
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
