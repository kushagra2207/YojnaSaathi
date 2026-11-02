import 'package:connectivity_plus/connectivity_plus.dart';
import '../db/local_database.dart';
import '../services/api_service.dart';

class SyncService {
  final ApiService _apiService = ApiService();
  final LocalDatabase _db = LocalDatabase.instance;

  Future<bool> hasConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  Future<void> performSync() async {
    // Fetch data from API
    final schemes = await _apiService.fetchSchemes();
    final notices = await _apiService.fetchHealthNotices();

    // Save to local database
    await _db.upsertSchemes(schemes);
    await _db.upsertHealthNotices(notices);

    // Update meta
    final now = DateTime.now().toIso8601String();
    await _db.setMeta('last_synced_at', now);
    await _db.setMeta('has_ever_synced', 'true');
  }
}
