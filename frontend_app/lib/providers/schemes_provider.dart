import 'package:flutter/foundation.dart';
import '../db/local_database.dart';
import '../models/scheme.dart';

class SchemesProvider extends ChangeNotifier {
  final LocalDatabase _db = LocalDatabase.instance;

  List<Scheme> _schemes = [];
  bool _isLoading = false;

  List<Scheme> get schemes => _schemes;
  bool get isLoading => _isLoading;

  Future<void> loadSchemes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _schemes = await _db.getAllSchemes();
    } catch (e) {
      _schemes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
