import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../db/local_database.dart';
import '../models/scheme.dart';
import '../models/health_notice.dart';
import '../providers/starred_provider.dart';
import '../widgets/scheme_card.dart';
import '../widgets/health_notice_card.dart';
import 'scheme_detail_screen.dart';
import 'health_notice_detail_screen.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({super.key});

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch starred provider to reload when stars change
    context.watch<StarredProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'starred_items'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'schemes_tab'.tr()),
            Tab(text: 'health_notices_tab'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSchemesTab(),
          _buildNoticesTab(),
        ],
      ),
    );
  }

  Widget _buildSchemesTab() {
    return FutureBuilder<List<Scheme>>(
      future: LocalDatabase.instance.getStarredSchemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final schemes = snapshot.data ?? [];

        if (schemes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_starred_items'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: schemes.length,
          itemBuilder: (context, index) {
            final scheme = schemes[index];
            return SchemeCard(
              scheme: scheme,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SchemeDetailScreen(scheme: scheme),
                  ),
                );
                if (mounted) setState(() {});
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNoticesTab() {
    return FutureBuilder<List<HealthNotice>>(
      future: LocalDatabase.instance.getStarredHealthNotices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notices = snapshot.data ?? [];

        if (notices.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_starred_items'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];
            return HealthNoticeCard(
              notice: notice,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        HealthNoticeDetailScreen(notice: notice),
                  ),
                );
                if (mounted) setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
