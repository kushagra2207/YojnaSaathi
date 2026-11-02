CREATE TABLE IF NOT EXISTS schemes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  eligibility TEXT NOT NULL,
  documents_required TEXT NOT NULL,
  where_to_apply TEXT NOT NULL,
  category TEXT NOT NULL CHECK(category IN ('pension', 'scholarship', 'ration', 'housing', 'insurance', 'healthcare', 'employment', 'other')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS health_notices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('camp', 'notice', 'outbreak_warning', 'medicine_availability')),
  location TEXT NOT NULL,
  event_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to auto-update updated_at on schemes
CREATE TRIGGER IF NOT EXISTS update_schemes_timestamp
AFTER UPDATE ON schemes
FOR EACH ROW
BEGIN
  UPDATE schemes SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Trigger to auto-update updated_at on health_notices
CREATE TRIGGER IF NOT EXISTS update_health_notices_timestamp
AFTER UPDATE ON health_notices
FOR EACH ROW
BEGIN
  UPDATE health_notices SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

