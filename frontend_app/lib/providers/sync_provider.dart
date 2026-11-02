import 'package:flutter/foundation.dart';
import '../db/local_database.dart';
import '../services/sync_service.dart';

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService = SyncService();
  final LocalDatabase _db = LocalDatabase.instance;

  DateTime? _lastSyncedAt;
  bool _hasEverSynced = false;
  bool _isSyncing = false;
  String? _syncError;

  DateTime? get lastSyncedAt => _lastSyncedAt;
  bool get hasEverSynced => _hasEverSynced;
  bool get isSyncing => _isSyncing;
  String? get syncError => _syncError;

  Future<void> loadSyncState() async {
    final hasEver = await _db.getMeta('has_ever_synced');
    _hasEverSynced = hasEver == 'true';

    final lastSynced = await _db.getMeta('last_synced_at');
    if (lastSynced != null) {
      _lastSyncedAt = DateTime.tryParse(lastSynced);
    }

    notifyListeners();
  }

  Future<bool> hasConnectivity() async {
    return await _syncService.hasConnectivity();
  }

  Future<void> sync() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final hasNetwork = await _syncService.hasConnectivity();
      if (!hasNetwork) {
        _syncError = 'No internet connection';
        _isSyncing = false;
        notifyListeners();
        return;
      }

      await _syncService.performSync();

      _lastSyncedAt = DateTime.now();
      _hasEverSynced = true;
      _syncError = null;
    } catch (e) {
      _syncError = e.toString();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
