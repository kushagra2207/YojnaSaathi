import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/sync_provider.dart';
import '../providers/schemes_provider.dart';
import '../providers/health_notices_provider.dart';
import '../providers/starred_provider.dart';
import '../widgets/sync_status_bar.dart';
import 'schemes_list_screen.dart';
import 'health_notices_list_screen.dart';
import 'starred_screen.dart';
import 'no_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.loadSyncState();

    if (syncProvider.hasEverSynced) {
      // Load cached data
      await _loadAllData();
    } else {
      // Try to sync
      final hasNetwork = await syncProvider.hasConnectivity();
      if (hasNetwork) {
        await syncProvider.sync();
        if (syncProvider.hasEverSynced) {
          await _loadAllData();
        }
      }
    }

    if (mounted) {
      setState(() {
        _initializing = false;
      });
    }
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      context.read<SchemesProvider>().loadSchemes(),
      context.read<HealthNoticesProvider>().loadNotices(),
      context.read<StarredProvider>().loadStarred(),
    ]);
  }

  Future<void> _onRefresh() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.sync();
    if (syncProvider.hasEverSynced) {
      await _loadAllData();
    }
  }

  Future<void> _onRetry() async {
    setState(() {
      _initializing = true;
    });
    await _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final syncProvider = context.watch<SyncProvider>();

    // Show no data screen only if never synced
    if (!syncProvider.hasEverSynced) {
      return NoDataScreen(onRetry: _onRetry);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'home_title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, size: 28),
            tooltip: 'language_selector'.tr(),
            onSelected: (Locale locale) {
              context.setLocale(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    const Text('🇺🇸  '),
                    Text(
                      'English',
                      style: TextStyle(
                        fontWeight: context.locale == const Locale('en')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('hi'),
                child: Row(
                  children: [
                    const Text('🇮🇳  '),
                    Text(
                      'हिन्दी',
                      style: TextStyle(
                        fontWeight: context.locale == const Locale('hi')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SyncStatusBar(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _HomeCard(
                icon: Icons.description,
                iconColor: Colors.deepOrange,
                title: 'welfare_schemes'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SchemesListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _HomeCard(
                icon: Icons.local_hospital,
                iconColor: Colors.teal,
                title: 'health_notices'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HealthNoticesListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _HomeCard(
                icon: Icons.star,
                iconColor: Colors.amber.shade700,
                title: 'starred_items'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StarredScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
