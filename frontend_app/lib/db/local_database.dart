import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scheme.dart';
import '../models/health_notice.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'yojna_saathi.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schemes (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        eligibility TEXT NOT NULL,
        documents_required TEXT NOT NULL,
        where_to_apply TEXT NOT NULL,
        category TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE health_notices (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        event_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE starred_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        item_type TEXT NOT NULL,
        starred_at TEXT NOT NULL,
        UNIQUE(item_id, item_type)
      )
    ''');

    await db.execute('''
      CREATE TABLE meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // --- Schemes ---

  Future<void> upsertSchemes(List<Scheme> schemes) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('schemes');
      for (final scheme in schemes) {
        await txn.insert('schemes', scheme.toDb());
      }
    });
  }

  Future<List<Scheme>> getAllSchemes() async {
    final db = await database;
    final maps = await db.query('schemes', orderBy: 'id DESC');
    return maps.map((map) => Scheme.fromDb(map)).toList();
  }

  // --- Health Notices ---

  Future<void> upsertHealthNotices(List<HealthNotice> notices) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('health_notices');
      for (final notice in notices) {
        await txn.insert('health_notices', notice.toDb());
      }
    });
  }

  Future<List<HealthNotice>> getAllHealthNotices() async {
    final db = await database;
    final maps = await db.query('health_notices', orderBy: 'id DESC');
    return maps.map((map) => HealthNotice.fromDb(map)).toList();
  }

  // --- Starred Items ---

  Future<void> addStar(int itemId, String itemType) async {
    final db = await database;
    await db.insert(
      'starred_items',
      {
        'item_id': itemId,
        'item_type': itemType,
        'starred_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeStar(int itemId, String itemType) async {
    final db = await database;
    await db.delete(
      'starred_items',
      where: 'item_id = ? AND item_type = ?',
      whereArgs: [itemId, itemType],
    );
  }

  Future<bool> isStarred(int itemId, String itemType) async {
    final db = await database;
    final result = await db.query(
      'starred_items',
      where: 'item_id = ? AND item_type = ?',
      whereArgs: [itemId, itemType],
    );
    return result.isNotEmpty;
  }

  Future<List<Scheme>> getStarredSchemes() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT s.* FROM schemes s
      INNER JOIN starred_items si ON s.id = si.item_id AND si.item_type = 'scheme'
      ORDER BY si.starred_at DESC
    ''');
    return maps.map((map) => Scheme.fromDb(map)).toList();
  }

  Future<List<HealthNotice>> getStarredHealthNotices() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT hn.* FROM health_notices hn
      INNER JOIN starred_items si ON hn.id = si.item_id AND si.item_type = 'health_notice'
      ORDER BY si.starred_at DESC
    ''');
    return maps.map((map) => HealthNotice.fromDb(map)).toList();
  }

  Future<Set<int>> getStarredSchemeIds() async {
    final db = await database;
    final maps = await db.query(
      'starred_items',
      columns: ['item_id'],
      where: 'item_type = ?',
      whereArgs: ['scheme'],
    );
    return maps.map((m) => m['item_id'] as int).toSet();
  }

  Future<Set<int>> getStarredNoticeIds() async {
    final db = await database;
    final maps = await db.query(
      'starred_items',
      columns: ['item_id'],
      where: 'item_type = ?',
      whereArgs: ['health_notice'],
    );
    return maps.map((m) => m['item_id'] as int).toSet();
  }

  // --- Meta ---

  Future<void> setMeta(String key, String value) async {
    final db = await database;
    await db.insert(
      'meta',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getMeta(String key) async {
    final db = await database;
    final result = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }
}
