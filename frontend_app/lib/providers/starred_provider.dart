import 'package:flutter/foundation.dart';
import '../db/local_database.dart';

class StarredProvider extends ChangeNotifier {
  final LocalDatabase _db = LocalDatabase.instance;

  Set<int> _starredSchemeIds = {};
  Set<int> _starredNoticeIds = {};

  Set<int> get starredSchemeIds => _starredSchemeIds;
  Set<int> get starredNoticeIds => _starredNoticeIds;

  Future<void> loadStarred() async {
    _starredSchemeIds = await _db.getStarredSchemeIds();
    _starredNoticeIds = await _db.getStarredNoticeIds();
    notifyListeners();
  }

  bool isStarred(int itemId, String itemType) {
    if (itemType == 'scheme') {
      return _starredSchemeIds.contains(itemId);
    } else {
      return _starredNoticeIds.contains(itemId);
    }
  }

  Future<void> toggleStar(int itemId, String itemType) async {
    if (isStarred(itemId, itemType)) {
      await _db.removeStar(itemId, itemType);
      if (itemType == 'scheme') {
        _starredSchemeIds.remove(itemId);
      } else {
        _starredNoticeIds.remove(itemId);
      }
    } else {
      await _db.addStar(itemId, itemType);
      if (itemType == 'scheme') {
        _starredSchemeIds.add(itemId);
      } else {
        _starredNoticeIds.add(itemId);
      }
    }
    notifyListeners();
  }
}
