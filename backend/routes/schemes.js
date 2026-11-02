import { Router } from 'express';
import db from '../db/database.js';
import { authenticateToken } from '../middleware/auth.js';

const router = Router();

const VALID_CATEGORIES = ['pension', 'scholarship', 'ration', 'housing', 'insurance', 'healthcare', 'employment', 'other'];

// GET all schemes (public)
router.get('/', (req, res) => {
  try {
    const schemes = db.prepare('SELECT * FROM schemes ORDER BY updated_at DESC').all();
    res.json(schemes);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch schemes' });
  }
});

// GET single scheme (public)
router.get('/:id', (req, res) => {
  try {
    const scheme = db.prepare('SELECT * FROM schemes WHERE id = ?').get(req.params.id);
    if (!scheme) {
      return res.status(404).json({ error: 'Scheme not found' });
    }
    res.json(scheme);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch scheme' });
  }
});

// POST create scheme (admin only)
router.post('/', authenticateToken, (req, res) => {
  const { title, description, eligibility, documents_required, where_to_apply, category } = req.body;

  if (!title || !description || !eligibility || !documents_required || !where_to_apply || !category) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  if (!VALID_CATEGORIES.includes(category)) {
    return res.status(400).json({ error: `Invalid category. Must be one of: ${VALID_CATEGORIES.join(', ')}` });
  }

  try {
    const stmt = db.prepare(`
      INSERT INTO schemes (title, description, eligibility, documents_required, where_to_apply, category)
      VALUES (?, ?, ?, ?, ?, ?)
    `);
    const result = stmt.run(title, description, eligibility, documents_required, where_to_apply, category);

    const scheme = db.prepare('SELECT * FROM schemes WHERE id = ?').get(result.lastInsertRowid);
    res.status(201).json(scheme);
  } catch (err) {
    res.status(500).json({ error: 'Failed to create scheme' });
  }
});

// PUT update scheme (admin only)
router.put('/:id', authenticateToken, (req, res) => {
  const { title, description, eligibility, documents_required, where_to_apply, category } = req.body;

  if (!title || !description || !eligibility || !documents_required || !where_to_apply || !category) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  if (!VALID_CATEGORIES.includes(category)) {
    return res.status(400).json({ error: `Invalid category. Must be one of: ${VALID_CATEGORIES.join(', ')}` });
  }

  try {
    const existing = db.prepare('SELECT * FROM schemes WHERE id = ?').get(req.params.id);
    if (!existing) {
      return res.status(404).json({ error: 'Scheme not found' });
    }

    db.prepare(`
      UPDATE schemes SET title = ?, description = ?, eligibility = ?, documents_required = ?, where_to_apply = ?, category = ?
      WHERE id = ?
    `).run(title, description, eligibility, documents_required, where_to_apply, category, req.params.id);

    const scheme = db.prepare('SELECT * FROM schemes WHERE id = ?').get(req.params.id);
    res.json(scheme);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update scheme' });
  }
});

// DELETE scheme (admin only)
router.delete('/:id', authenticateToken, (req, res) => {
  try {
    const existing = db.prepare('SELECT * FROM schemes WHERE id = ?').get(req.params.id);
    if (!existing) {
      return res.status(404).json({ error: 'Scheme not found' });
    }

    db.prepare('DELETE FROM schemes WHERE id = ?').run(req.params.id);
    res.json({ message: 'Scheme deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete scheme' });
  }
});

export default router;

