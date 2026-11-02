import 'package:flutter/foundation.dart';
import '../db/local_database.dart';
import '../models/health_notice.dart';

class HealthNoticesProvider extends ChangeNotifier {
  final LocalDatabase _db = LocalDatabase.instance;

  List<HealthNotice> _notices = [];
  bool _isLoading = false;

  List<HealthNotice> get notices => _notices;
  bool get isLoading => _isLoading;

  Future<void> loadNotices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notices = await _db.getAllHealthNotices();
    } catch (e) {
      _notices = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
