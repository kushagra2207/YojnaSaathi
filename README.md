# YojnaSaathi

**YojnaSaathi** is an offline-first welfare scheme finder and village health notice board designed for rural families, daily-wage workers, elderly citizens, and local community volunteers.

---

## Architecture Overview

```text
       ┌────────────────────────┐
       │   Admin Web Panel      │  (React + Vite)
       │  (NGOs / ASHA / Admin) │
       └───────────┬────────────┘
                   │ HTTP / JWT
                   ▼
       ┌────────────────────────┐
       │      Backend API       │  (Node.js + Express + SQLite)
       │  (REST + Sync Route)   │
       └───────────▲────────────┘
                   │ HTTP (Sync)
       ┌───────────┴────────────┐
       │   Mobile Client App    │  (Flutter + Local SQLite)
       │  (Offline-first users) │
       └────────────────────────┘
```

---

## Features

### 1. Mobile App (`frontend_app` — Flutter)
* **Offline-First**: Uses local SQLite (`sqflite`) so all saved schemes and health notices work without continuous internet.
* **Smart Sync**: Pull-to-refresh syncs with the backend and displays a real-time *"Last synced: X minutes ago"* status bar.
* **First-Launch Resilience**: Shows a clear offline fallback screen if opened for the very first time without an internet connection.
* **Bilingual (English / हिन्दी)**: Bundled offline translations switchable on-the-fly.
* **Bookmarking (Starred Items)**: Star important schemes and vaccination camps to quickly review them anytime in a dedicated tab.
* **Simple, Accessible UI**: High-contrast, easy-to-read typography and card-based navigation suitable for rural and elderly users.

### 2. Admin Web Panel (`frontend_web` — React + Vite)
* **Secure Admin Access**: Simple credentials-based JWT authentication.
* **Welfare Schemes Manager**: Add, edit, or delete welfare schemes with plain-language eligibility, required documents, and application office details.
* **Health Notices & Camps Manager**: Post village health camps, vaccination drives, outbreak warnings, and local medicine availability.
* **Responsive Dashboard**: Modal-based editing and delete confirmations with toast feedback.

### 3. Backend API (`backend` — Node.js + Express)
* **Embedded SQLite (`better-sqlite3`)**: Lightweight with WAL mode enabled for fast concurrent read/write access.
* **Auto-Seeding**: Automatically seeds sample Indian welfare schemes and health camps on fresh startup if the database is empty.
* **Public & Protected Endpoints**: Public routes for mobile read/sync; JWT authentication required for admin writes.
* **Mobile-Friendly CORS**: Permits requests from web clients while seamlessly supporting mobile clients and tools with undefined origins.

---

## Getting Started

### 1. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Start server (auto-seeds sample data on first run)
npm run dev
```

* **Runs on:** `http://localhost:3000`
* **Default Admin Credentials:**
  * **Username:** `admin`
  * **Password:** `yojnasaathi2024`

> Optional `.env` configuration in `backend/.env`:
> ```env
> PORT=3000
> ADMIN_USERNAME=admin
> ADMIN_PASSWORD=yojnasaathi2024
> JWT_SECRET=your_jwt_secret_here
> FRONTEND_URL=http://localhost:5173
> ```

---

### 2. Admin Web Panel Setup

```bash
cd frontend_web

# Install dependencies
npm install

# Start development server
npm run dev
```

* **Runs on:** `http://localhost:5173`
* Create a `frontend_web/.env` file:
  ```env
  VITE_API_URL=http://localhost:3000
  ```

---

### 3. Mobile App Setup

```bash
cd frontend_app

# Fetch dependencies
flutter pub get

# Run on emulator or connected device
flutter run
```

* Create a `frontend_app/.env` file:
  ```env
  # Android emulator pointing to host machine
  API_URL=http://10.0.2.2:3000

  # For physical device, use your local Wi-Fi IP (e.g., http://192.168.1.10:3000)
  # For production, point to your deployed backend (e.g., https://your-backend.onrender.com)
  ```

---

## Tech Stack

| Layer | Technologies |
|---|---|
| **Backend** | Node.js, Express, better-sqlite3, JWT, CORS, dotenv |
| **Web Admin** | React 19, Vite, React Router, React Hot Toast |
| **Mobile** | Flutter (Material 3), Provider, sqflite, easy_localization, flutter_dotenv |

