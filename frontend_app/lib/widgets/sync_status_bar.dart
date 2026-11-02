import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/sync_provider.dart';
import '../utils/time_ago.dart';

class SyncStatusBar extends StatelessWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncProvider>(
      builder: (context, syncProvider, child) {
        Color backgroundColor;
        String text;
        VoidCallback? onTap;

        if (syncProvider.isSyncing) {
          backgroundColor = Colors.blue.shade600;
          text = 'syncing'.tr();
          onTap = null;
        } else if (syncProvider.syncError != null) {
          backgroundColor = Colors.red.shade600;
          text = 'sync_error'.tr(namedArgs: {'error': syncProvider.syncError!});
          onTap = () => syncProvider.sync();
        } else if (syncProvider.lastSyncedAt != null) {
          backgroundColor = Colors.teal.shade600;
          text = 'last_synced'.tr(
            namedArgs: {'time': timeAgo(syncProvider.lastSyncedAt!)},
          );
          onTap = () => syncProvider.sync();
        } else {
          backgroundColor = Colors.orange.shade700;
          text = 'never_synced'.tr();
          onTap = () => syncProvider.sync();
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: backgroundColor,
            child: Row(
              children: [
                if (syncProvider.isSyncing)
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!syncProvider.isSyncing)
                  const Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
