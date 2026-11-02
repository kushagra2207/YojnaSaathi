import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/health_notices_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/sync_status_bar.dart';
import '../widgets/health_notice_card.dart';
import 'health_notice_detail_screen.dart';

class HealthNoticesListScreen extends StatefulWidget {
  const HealthNoticesListScreen({super.key});

  @override
  State<HealthNoticesListScreen> createState() =>
      _HealthNoticesListScreenState();
}

class _HealthNoticesListScreenState extends State<HealthNoticesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HealthNoticesProvider>().loadNotices();
  }

  Future<void> _onRefresh() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.sync();
    if (mounted) {
      await context.read<HealthNoticesProvider>().loadNotices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'health_notices_plain'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SyncStatusBar(),
          Expanded(
            child: Consumer<HealthNoticesProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.notices.isEmpty) {
                  return Center(
                    child: Text(
                      'no_starred_items'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.notices.length,
                    itemBuilder: (context, index) {
                      final notice = provider.notices[index];
                      return HealthNoticeCard(
                        notice: notice,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HealthNoticeDetailScreen(notice: notice),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
