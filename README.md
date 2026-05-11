# PNG Census 2025 — Hybrid Mobile App

A Flutter-based offline-first field data collection app for the Papua New Guinea national census. Built for Android and iOS, designed to work reliably in low-connectivity rural environments.

> **WIA** means *village* in the Yangoru tok ples (local language of the Yangoru-Saussia District, East Sepik Province).

---

## Overview

Field enumerators use the app to record household data against a JSON-driven census form. Records are stored locally in an Isar database and automatically synced to a central server whenever connectivity is available. Supervisors have a separate dashboard to monitor submission progress and resolve data conflicts.

---

## Features

- **Offline-first data capture** — all records written to local Isar DB; no network required during enumeration
- **JSON form engine** — census questionnaire loaded from `assets/schemas/png_census_2025.json`; supports skip logic, repeat groups, and conditional validation
- **Background sync** — `workmanager` triggers periodic sync; bidirectional upload/download via REST API (`/api/v1/records`)
- **Vector-clock conflict resolution** — concurrent edits detected automatically; supervisor can review and resolve in the conflict detail screen
- **GPS capture** — household coordinates recorded with accuracy metadata via `geolocator`
- **Audio questions** — audio prompts playable inline via `audioplayers`
- **Photo capture** — `image_picker` integration for household photos
- **Multi-language support** — `easy_localization` for Tok Pisin and English
- **Role-based access** — enumerator and supervisor roles with separate screens and permissions

---

## Project Structure

```
png_census_app/
├── assets/
│   └── schemas/          # Census form schema (JSON)
├── lib/
│   ├── engine/           # Form engine + expression evaluator (skip logic)
│   ├── models/           # Isar data models (HouseholdRecord, FormSchema, UserModel)
│   ├── screens/          # Login, registration, enumeration, dashboard, supervisor, conflict detail
│   ├── services/         # Isar service, auth service, sync engine, background sync, translation
│   ├── theme/            # App theme (AppColors, AppTheme)
│   └── widgets/          # Reusable UI (QuestionWidget, RepeatGroupWidget, GpsCapture, AudioPlayButton, WiaLogo)
└── pubspec.yaml
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.5`
- Dart SDK `^3.11.5`
- Android Studio / Xcode for device targets

### Install dependencies

```bash
cd png_census_app
flutter pub get
```

### Generate Isar code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run

```bash
flutter run
```

---

## Sync API

The app expects a REST backend at a configurable base URL. Configure `SyncEngine` with:

| Parameter | Description |
|---|---|
| `baseUrl` | Base URL of the sync server (e.g. `https://census-api.example.gov.pg`) |
| `apiKey` | API key sent as `X-Api-Key` header |
| `enumeratorId` | ID of the logged-in enumerator |

**Endpoints used:**

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/api/v1/records` | Upload a household record |
| `GET` | `/api/v1/records?since=<ISO>&enumeratorId=<id>` | Fetch server updates since last sync |

A `409 Conflict` response to `POST` should return the server's version of the record as JSON; the app resolves it automatically using vector clocks.

---

## Key Dependencies

| Package | Purpose |
|---|---|
| `isar` + `isar_flutter_libs` | Local embedded database |
| `workmanager` | Background sync scheduling |
| `connectivity_plus` | Network state detection |
| `geolocator` | GPS coordinate capture |
| `image_picker` | Household photo capture |
| `audioplayers` | Audio question playback |
| `easy_localization` | i18n (English / Tok Pisin) |
| `provider` | State management |
| `google_fonts` | Typography |
| `crypto` | Auth token hashing |

---

## Roles

**Enumerator**
- Log in with assigned credentials
- Work through the census form household by household
- GPS and photo capture per household
- Records queue for sync automatically in the background

**Supervisor**
- View submission counts and enumerator progress
- Review and resolve conflicting records
- Export data (CSV/JSON) from the device

---

## License

Government of Papua New Guinea — WIA (village) Census Programme. Not for public redistribution.
