import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth.js';
import schemesRoutes from './routes/schemes.js';
import healthNoticesRoutes from './routes/healthNotices.js';
import db from './db/database.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (mobile apps, Postman, curl)
    if (!origin) return callback(null, true);
    const allowedOrigins = (process.env.FRONTEND_URL || '').split(',').map(s => s.trim());
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/schemes', schemesRoutes);
app.use('/api/health-notices', healthNoticesRoutes);

// Sync endpoint — returns latest update timestamps for mobile app
app.get('/api/sync/latest', (req, res) => {
  try {
    const schemesRow = db.prepare('SELECT MAX(updated_at) as latest FROM schemes').get();
    const noticesRow = db.prepare('SELECT MAX(updated_at) as latest FROM health_notices').get();

    res.json({
      schemes_updated_at: schemesRow?.latest || null,
      health_notices_updated_at: noticesRow?.latest || null,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch sync info' });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`YojnaSaathi backend running on http://localhost:${PORT}`);
});
