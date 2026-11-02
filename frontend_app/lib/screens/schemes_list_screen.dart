import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/schemes_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/sync_status_bar.dart';
import '../widgets/scheme_card.dart';
import 'scheme_detail_screen.dart';

class SchemesListScreen extends StatefulWidget {
  const SchemesListScreen({super.key});

  @override
  State<SchemesListScreen> createState() => _SchemesListScreenState();
}

class _SchemesListScreenState extends State<SchemesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SchemesProvider>().loadSchemes();
  }

  Future<void> _onRefresh() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.sync();
    if (mounted) {
      await context.read<SchemesProvider>().loadSchemes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'welfare_schemes_plain'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SyncStatusBar(),
          Expanded(
            child: Consumer<SchemesProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.schemes.isEmpty) {
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
                    itemCount: provider.schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = provider.schemes[index];
                      return SchemeCard(
                        scheme: scheme,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SchemeDetailScreen(scheme: scheme),
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
