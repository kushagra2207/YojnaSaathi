import { Router } from 'express';
import db from '../db/database.js';
import { authenticateToken } from '../middleware/auth.js';

const router = Router();

const VALID_TYPES = ['camp', 'notice', 'outbreak_warning', 'medicine_availability'];

// GET all health notices (public)
router.get('/', (req, res) => {
  try {
    const notices = db.prepare('SELECT * FROM health_notices ORDER BY updated_at DESC').all();
    res.json(notices);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch health notices' });
  }
});

// GET single health notice (public)
router.get('/:id', (req, res) => {
  try {
    const notice = db.prepare('SELECT * FROM health_notices WHERE id = ?').get(req.params.id);
    if (!notice) {
      return res.status(404).json({ error: 'Health notice not found' });
    }
    res.json(notice);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch health notice' });
  }
});

// POST create health notice (admin only)
router.post('/', authenticateToken, (req, res) => {
  const { title, description, type, location, event_date } = req.body;

  if (!title || !description || !type || !location) {
    return res.status(400).json({ error: 'Title, description, type, and location are required' });
  }

  if (!VALID_TYPES.includes(type)) {
    return res.status(400).json({ error: `Invalid type. Must be one of: ${VALID_TYPES.join(', ')}` });
  }

  try {
    const stmt = db.prepare(`
      INSERT INTO health_notices (title, description, type, location, event_date)
      VALUES (?, ?, ?, ?, ?)
    `);
    const result = stmt.run(title, description, type, location, event_date || null);

    const notice = db.prepare('SELECT * FROM health_notices WHERE id = ?').get(result.lastInsertRowid);
    res.status(201).json(notice);
  } catch (err) {
    res.status(500).json({ error: 'Failed to create health notice' });
  }
});

// PUT update health notice (admin only)
router.put('/:id', authenticateToken, (req, res) => {
  const { title, description, type, location, event_date } = req.body;

  if (!title || !description || !type || !location) {
    return res.status(400).json({ error: 'Title, description, type, and location are required' });
  }

  if (!VALID_TYPES.includes(type)) {
    return res.status(400).json({ error: `Invalid type. Must be one of: ${VALID_TYPES.join(', ')}` });
  }

  try {
    const existing = db.prepare('SELECT * FROM health_notices WHERE id = ?').get(req.params.id);
    if (!existing) {
      return res.status(404).json({ error: 'Health notice not found' });
    }

    db.prepare(`
      UPDATE health_notices SET title = ?, description = ?, type = ?, location = ?, event_date = ?
      WHERE id = ?
    `).run(title, description, type, location, event_date || null, req.params.id);

    const notice = db.prepare('SELECT * FROM health_notices WHERE id = ?').get(req.params.id);
    res.json(notice);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update health notice' });
  }
});

// DELETE health notice (admin only)
router.delete('/:id', authenticateToken, (req, res) => {
  try {
    const existing = db.prepare('SELECT * FROM health_notices WHERE id = ?').get(req.params.id);
    if (!existing) {
      return res.status(404).json({ error: 'Health notice not found' });
    }

    db.prepare('DELETE FROM health_notices WHERE id = ?').run(req.params.id);
    res.json({ message: 'Health notice deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete health notice' });
  }
});

export default router;

