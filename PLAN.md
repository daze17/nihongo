# Japanese Learning App – Build Plan

Mobile app that teaches Mongolians Japanese and tracks what they still need before they can
go to Japan. Flutter app inside a Turborepo monorepo, NestJS + Drizzle + Postgres backend,
TypeScript content pipeline.

Work top to bottom. Each phase ends with something runnable. Don't start the next
phase until the checklist for the current one is done.

Legend: `- [ ]` todo · `- [x]` done · **Verify:** lines are the exit criteria for a phase.

---

## Product direction

General Japanese apps are a crowded market (Duolingo, LingoDeer, Busuu, Anki, Renshuu,
WaniKani, Bunpro). This app is not another one of those. It answers two questions for one
group of people:

> **"How good is my Japanese?"** and **"What else do I need before I can go to Japan?"**

- **Who:** Mongolians preparing to work or study in Japan, mostly on the Specified Skilled
  Worker (特定技能) route, plus engineers and students.
- **Learning Japanese (the core):** kana → N5 / A2 → N4, explained in **Mongolian first**
  (English second), with mock **JFT-Basic** and **JLPT N4** tests and job-field vocabulary
  (care, food service, agriculture, aviation).
- **Japan readiness:** the student picks a path (Specified Skilled Worker + field, engineer,
  student). The app shows every requirement for that path – Japanese level, skills test,
  documents, pre-departure training – with their status, and one **"Ready for Japan: N%"** score.
  Teachers confirm items such as a passed exam, so the score can be trusted.
- **Who pays:** organisations that send people to Japan. First pilot target: **GTN Mongolia**'s
  Japanese language school in Ulaanbaatar (GTN runs recruitment, pre-departure training and
  post-arrival support for Mongolians going to Japan). Students use it free through their school.
- **Requirements data:** exact requirements differ by field and change over time. Source them
  from GTN Mongolia's training team and official Japanese government pages, keep them in
  content files (not code), and date-stamp every rule.

**Stages.** Build stage 1 first; the later stages reuse its data and are on the roadmap.

| Stage                     | What the app does                                                               | Status   |
| ------------------------- | ------------------------------------------------------------------------------- | -------- |
| 1. Learn + get ready      | Course, mock tests, requirement checklist, readiness score, school classes      | **MVP**  |
| 2. Get hired              | Verified candidate profile for employers (level, readiness, interview answers)  | Post-MVP |
| 3. Prepare to leave       | Pre-departure training: workplace Japanese, manners, life rules                 | Post-MVP |
| 4. Arrive + live in Japan | Arrival checklist (residence card, housing, SIM, bank) and support in Mongolian | Post-MVP |

Validate stage 1 with the pilot school before building past Milestone 1 (Phase 0 checklist).

---

## At a glance

```mermaid
flowchart LR
    P0[0 Prereqs] --> P1[1 Monorepo]
    P1 --> P2[2 Flutter<br/>foundation]
    P2 --> P3[3 Content<br/>pipeline]
    P3 --> P4[4 Lesson engine<br/>kana → N5]
    P4 --> P5[5 SRS]
    P5 --> P6[6 Mock tests +<br/>Japan readiness]
    P6 --> M1{{🎉 Milestone 1<br/>Learn + readiness,<br/>offline}}
    M1 --> P7[7 Backend<br/>auth · sync · classes]
    P7 --> P8[8 Audio]
    P8 --> P9[9 Polish +<br/>motivators]
    P9 --> P10[10 Release]
    P10 --> M2{{🚀 Milestone 2<br/>Pilot school live}}
    M2 --> P11[Post-MVP:<br/>N4 · hiring · departure · life in Japan]

    style M1 fill:#ffe9a8,stroke:#c9a227
    style M2 fill:#c8f7c5,stroke:#3c9d3c
```

| #      | Phase                        | What you can do when it's done                                      | Rough effort         |
| ------ | ---------------------------- | ------------------------------------------------------------------- | -------------------- |
| 0      | Prerequisites                | Tools installed, accounts created, pilot school found               | 1 day                |
| 1      | Monorepo                     | `pnpm turbo run lint test` passes, empty Flutter app runs           | 1 day                |
| 2      | Flutter foundation           | Navigation, theme, local DB, settings that persist                  | 3–4 days             |
| 3      | Content pipeline             | Lessons, tests and requirement rules generated from content files   | 4–5 days             |
| 4      | Lesson engine + kana → N5    | Play kana and first N5 lessons with 5 exercise types                | 2–3 weeks            |
| 5      | SRS                          | Review tab shows due items, weak ones come back sooner              | 3–4 days             |
| 6      | Mock tests + Japan readiness | Take a mock JFT-Basic; see requirements and "Ready for Japan" score | 1.5–2 weeks          |
| **M1** | **Learn + readiness app**    | **Shippable to the pilot class as a TestFlight / internal build**   | **~8 weeks total**   |
| 7      | Backend                      | Auth0 sign-in, progress sync, classes with join codes, teacher view | 2–3 weeks            |
| 8      | Audio                        | Native-quality TTS for every item, cached offline                   | 2–3 days             |
| 9      | Polish + motivators          | Onboarding, daily goal, streak, reminders, analytics, crash reports | 1 week               |
| 10     | Release                      | Live on App Store + Google Play, pilot class using it               | 1 week + review time |
| **M2** | **Pilot school live**        |                                                                     | **~14 weeks total**  |

Effort assumes evenings/weekends, one person. Halve it if full-time.

### System architecture

```mermaid
flowchart TB
    subgraph device[📱 Flutter app  –  works fully offline]
        UI[Screens & exercise widgets]
        ENG[Lesson engine]
        SRS[FSRS scheduler]
        DB[(Drift / SQLite)]
        SYNC[SyncService]
        UI --> ENG --> SRS --> DB
        DB <--> SYNC
    end

    subgraph cloud[☁️ Backend  –  Docker on Fly.io × 2]
        API[NestJS API<br/>auth · sync · content · health]
        CRON[Cron jobs<br/>streak audit · cleanup]
        API --> PG[(Postgres<br/>Neon)]
        CRON --> PG
    end

    R2[(Cloudflare R2<br/>audio mp3)]
    APPLE[Auth0<br/>Google · Facebook · Apple · email]

    SYNC -- "POST /sync  (JWT)" --> API
    UI -- "stream + cache" --> R2
    UI -- "sign in" --> APPLE -- "access token (RS256)" --> API

    subgraph build[🛠 Build-time  –  Turborepo]
        RAW[JMdict · KanjiVG<br/>KANJIDIC2 · Tatoeba]
        CONTENT[packages/content]
        SCHEMA[packages/schema<br/>zod = source of truth]
        TTS[Azure TTS]
        RAW --> CONTENT
        SCHEMA --> CONTENT
        CONTENT -- "assets/content/*.json" --> DB
        CONTENT -- "seed" --> PG
        CONTENT --> TTS --> R2
        SCHEMA -- "OpenAPI → Dart client" --> SYNC
        SCHEMA -- "DTOs" --> API
    end
```

### How sync works

```mermaid
sequenceDiagram
    participant App as 📱 App (Drift)
    participant API as ☁️ NestJS
    participant PG as 🐘 Postgres

    Note over App: user finishes a lesson<br/>rows written locally first
    App->>API: POST /sync { lastSyncAt, changes[] }
    API->>PG: BEGIN
    API->>PG: upsert changes (updated_at wins, xp = max)
    API->>PG: SELECT rows changed since lastSyncAt
    API->>PG: COMMIT
    API-->>App: { serverChanges[], syncedAt }
    App->>App: apply serverChanges, store syncedAt
    Note over App,API: offline? → skip, retry on next resume<br/>lesson never waits for network
```

### Where every piece lives

```mermaid
flowchart LR
    subgraph repo[japanese_learn  –  Turborepo + pnpm]
        direction TB
        subgraph apps
            MOB[apps/mobile<br/>Flutter]
            APIX[apps/backend/user<br/>NestJS]
        end
        subgraph packages
            SCH[packages/schema<br/>zod]
            DBP[packages/db<br/>Drizzle]
            CNT[packages/content<br/>data pipeline]
        end
        SCH --> DBP --> APIX
        SCH --> CNT --> DBP
        SCH -. generated Dart .-> MOB
        CNT -. JSON assets .-> MOB
    end
```

---

## 0. Stack decisions

| Layer            | Choice                                                                                                              | Why                                                                                                                |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Monorepo         | Turborepo + pnpm 10                                                                                                 | Caches Flutter + TS tasks, one `pnpm turbo run test` for everything                                                |
| Mobile           | Flutter (Dart 3)                                                                                                    | One codebase, strong custom drawing (stroke tracing), great animations                                             |
| State            | Riverpod 2 (code-gen)                                                                                               | Testable, no boilerplate, works well with Drift streams                                                            |
| Routing          | go_router                                                                                                           | Deep links, typed routes                                                                                           |
| Local DB         | Drift (SQLite)                                                                                                      | Offline-first lessons + SRS, reactive queries                                                                      |
| Backend          | NestJS 11 (TypeScript)                                                                                              | Shares zod schemas with content pipeline, first-class in Turborepo                                                 |
| ORM / migrations | Drizzle ORM + drizzle-kit                                                                                           | Typed SQL, migrations in repo, no codegen step                                                                     |
| Database         | Postgres 16 (Docker locally, Neon in prod)                                                                          | Managed backups + PITR, swap provider via connection string                                                        |
| Auth             | Auth0 (Universal Login: Google, Facebook, Apple, email). API verifies Auth0 access tokens against the tenant's JWKS | Social logins and refresh-token rotation without building them; the API stays stateless and only checks signatures |
| Storage          | Cloudflare R2 (S3-compatible)                                                                                       | Zero egress fees for audio                                                                                         |
| Jobs             | @nestjs/schedule (cron) now, BullMQ + Redis when needed                                                             | Streak audits, league rollover                                                                                     |
| API contract     | oRPC (`@orpc/contract` + zod) in `packages/contract`, implemented in Nest via `@orpc/nest`                          | Define each endpoint once. OpenAPI generated from it → Dart client; admin gets a typed oRPC client                 |
| Hosting          | Docker image on Fly.io (2 instances)                                                                                | Portable; move to VPS/k8s later without code changes                                                               |
| Content pipeline | TypeScript package                                                                                                  | Builds lesson JSON from JMdict / KanjiVG / KANJIDIC2                                                               |
| Audio            | Azure Neural TTS (ja-JP Nanami / Keita) → mp3 in R2                                                                 | Cheap, near-native quality                                                                                         |
| CI               | GitHub Actions                                                                                                      | Runs `turbo run lint test build`                                                                                   |

### Backend architecture

Owned backend: **NestJS + Drizzle + Postgres**, living in `apps/backend/user` (user API; a separate `apps/backend/admin` API comes later). Decision made
after weighing Supabase (fastest, but vendor-shaped), Go (cheapest to run), Java/Spring
(most battle-tested) and C++ (no fit). TypeScript wins because the content pipeline and
schemas are already TypeScript, so one zod definition drives lesson JSON, DB seed, API
DTOs and the generated Dart client.

Principles:

- **Offline-first stays.** SRS and lesson engine run on device. The API stores progress
  snapshots and per-item review state for sync. A backend outage never blocks a lesson.
- **Database is the only managed piece.** Postgres on Neon (backups, PITR, branching).
  Everything else is a Docker image you can run anywhere.
- **Stateless API, two instances.** No in-memory sessions; JWTs + Postgres. Either
  instance can die.
- **Schemas shared, not duplicated.** `packages/schema` (zod) → `packages/db` (Drizzle
  tables) and `packages/contract` (oRPC procedures) → `apps/backend/user` implements the contract →
  OpenAPI → Dart client, and `apps/admin` uses the contract directly. Change it once.
- **Boring observability from day one.** Pino structured logs, `/health` via Terminus,
  Sentry, uptime ping.

---

## 1. Monorepo layout

```
japanese_learn/
├── apps/
│   ├── mobile/                 # Flutter app
│   │   ├── lib/
│   │   ├── test/
│   │   ├── pubspec.yaml
│   │   └── package.json        # exposes flutter commands to turbo
│   └── backend/
│       ├── user/               # NestJS API for the mobile app
│       │   ├── src/
│       │   │   ├── content/    # ✓ read-only content (controller → service → repository)
│       │   │   ├── auth/       # Auth0 access-token verification, AuthGuard
│       │   │   ├── profile/    # me, delete account
│       │   │   ├── sync/       # push/pull progress, item_reviews, review_log
│       │   │   ├── jobs/       # cron: streak audit, cleanup
│       │   │   ├── config/ database/ orpc/ common/ health/ docs/
│       │   │   └── main.ts
│       │   ├── test/           # e2e against the docker-compose Postgres
│       │   ├── Dockerfile
│       │   └── package.json    # name: backend-user
│       └── admin/              # (post-MVP) NestJS API for apps/admin, role-guarded
├── packages/
│   ├── schema/                 # TS: zod schemas (source of truth for content + API DTOs)
│   ├── contract/               # TS: oRPC contract (procedures, paths, input/output)
│   ├── db/                     # TS: Drizzle schema, migrations, db client, seed helpers
│   ├── content/                # TS: raw data → lesson JSON + seeds packages/db
│   ├── eslint-config/
│   └── tsconfig/
├── docker-compose.yml          # local postgres + redis + minio (R2 stand-in)
├── .github/workflows/ci.yml
├── turbo.json
├── pnpm-workspace.yaml
├── package.json
└── PLAN.md
```

Turbo cannot run Dart natively; it just runs the `scripts` in `apps/mobile/package.json`
(`flutter analyze`, `flutter test`, `flutter build …`) and caches by input hash.
That's all you need.

---

## 2. Phase 0 – Prerequisites

- [x] Install Flutter stable (`flutter doctor` fully green for iOS + Android)
- [x] Install Xcode + CocoaPods, Android Studio + SDK + emulator
- [x] Install Node 22 LTS (pinned via `.nvmrc`) and pnpm 10
- [x] Install Docker Desktop (local Postgres, Redis, MinIO)
- [ ] Create GitHub repo `japanese_learn` (private)
- [ ] Create accounts (no setup yet, just so they're ready): Neon, Cloudflare (R2), Fly.io, Sentry
- [ ] Register Apple Developer account (needed for TestFlight, takes a few days to approve)
- [ ] Register Google Play developer account

**Market check (in parallel with Phases 1–6)**

- [ ] Interview 5–10 Japanese language schools / sending agencies in Mongolia: what they use, where students fail, would they pay, how much
- [ ] Mongolian landing page with an email / phone sign-up; measure interest
- [ ] Pitch the pilot to GTN Mongolia's language school: one class, one month, Milestone 1 build
- [ ] Get the requirement checklist for the Specified Skilled Worker route (Japanese level, skills test per field, documents, pre-departure training, Mongolian government steps) from GTN Mongolia's training team; cross-check with official pages

---

## 3. Phase 1 – Initialize the monorepo

- [x] `git init`, add `.gitignore` (Node + Flutter + macOS + `.env*`)
- [x] `pnpm init` at root, add `"private": true`, `"packageManager": "pnpm@10.x"`
- [x] Create `pnpm-workspace.yaml` with `apps/*`, `packages/*`
- [x] `pnpm add -D turbo -w`
- [x] Create `turbo.json` with tasks: `lint`, `test`, `build`, `gen`, `format`
  - `build` depends on `^build`, outputs: `build/**`, `dist/**`
  - `gen` (codegen) depends on nothing, outputs: `lib/**/*.g.dart`, `lib/**/*.freezed.dart`
- [x] `flutter create apps/mobile --org com.bilguun --project-name nihongo --platforms ios,android` (bundle id `com.bilguun.nihongo`)
- [x] Add `apps/mobile/package.json`:
  ```json
  {
    "name": "mobile",
    "private": true,
    "scripts": {
      "gen": "dart run build_runner build --delete-conflicting-outputs",
      "lint": "flutter analyze",
      "format": "dart format --set-exit-if-changed lib test",
      "test": "flutter test",
      "build": "flutter build apk --debug",
      "build:ios": "flutter build ipa --release",
      "build:android": "flutter build appbundle --release"
    }
  }
  ```
- [x] Create `packages/tsconfig` with `base.json`, `nestjs.json`, `library.json`
- [x] Create `packages/eslint-config` (typescript-eslint, shared across TS packages)
- [x] Create `packages/schema` (TS, zod, vitest) – empty for now
- [x] Create `packages/db` (TS, drizzle-orm, drizzle-kit, postgres driver) – empty for now
- [x] Create `packages/content` (TS, tsx runner, vitest) – empty for now
- [x] Create `packages/contract` (`@orpc/contract`, `@orpc/openapi`, zod from `packages/schema`)
- [x] Add root `docker-compose.yml`: `postgres:16`, `redis:7`, `minio` (S3 stand-in for R2)
- [x] Add `.env.example` at root; real `.env` git-ignored
- [x] Add root `.prettierrc`, `.editorconfig`
- [x] Add GitHub Actions `ci.yml`: setup pnpm + Flutter, run `pnpm turbo run lint test`
- [x] Verify: `pnpm turbo run lint test` passes from clean clone
- [ ] First commit

---

## 4. Phase 2 – Flutter app foundation

Goal: empty app with navigation, theming, DI, local DB, and a settings screen that persists.

- [ ] Add dependencies (done: `flutter_riverpod`, `go_router`, `google_fonts`, `flutter_localizations`, `intl`; still to add): `riverpod_annotation`, `drift`, `sqlite3_flutter_libs`, `path_provider`, `freezed_annotation`, `json_annotation`, `flutter_animate`
- [ ] Add dev deps (done: `very_good_analysis`; still to add): `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`, `drift_dev`, `mocktail`
- [x] Decide folder structure (feature-first):
  ```
  lib/
  ├── app/            # MaterialApp, router, theme
  ├── core/           # db, utils, extensions, constants
  ├── features/
  │   ├── onboarding/
  │   ├── home/       # learning path
  │   ├── lesson/     # lesson engine + exercise widgets
  │   ├── review/     # SRS practice
  │   ├── profile/
  │   └── settings/
  └── main.dart
  ```
- [x] Set up `go_router` with routes: `/onboarding`, `/home`, `/lesson/:id` (+ `/complete`), `/review`, `/profile` — `/settings` comes with the settings screen
- [x] Bottom nav shell: Learn · Practice · Profile
- [ ] Theme (light done: GTN-style red/black/white, Noto Sans + Noto Sans JP + Montserrat; dark still to do): pick a palette, define `ColorScheme` light + dark, a Japanese-capable font (Noto Sans JP via `google_fonts`)
- [ ] Set up Drift database class with a `schemaVersion` and migration strategy
- [ ] Add a `settings` table (daily goal, sound on/off, furigana mode, theme)
- [ ] Settings screen reads/writes via Riverpod + Drift stream
- [x] Localisation from day one: `flutter_localizations` + ARB files, **`mn` default**, `en` second; no hard-coded UI strings
- [ ] Add a `flavors` setup: `dev` (API on localhost) and `prod` (Fly.io API)
- [ ] Add `flutter_native_splash` + app icon placeholder
- [ ] Write one widget test (done: app flow + lesson controller tests) and one Drift unit test so the test pipeline is proven
- [ ] Verify: app runs on iOS simulator and Android emulator, settings persist across restart

---

## 5. Phase 3 – Content schema & pipeline

Goal: lesson content is generated JSON, not hand-written Dart.

### packages/schema

- [ ] Define zod schemas:
  - `Kana { id, char, romaji, type: hiragana|katakana, row, audio }`
  - `Kanji { id, char, meanings[], onyomi[], kunyomi[], strokes (KanjiVG paths), jlpt, grade }`
  - `Vocab { id, word, reading, meanings[], kanjiIds[], jlpt, audio }`
  - `Sentence { id, ja, reading, en, tokens[], vocabIds[], audio }`
  - `Exercise` discriminated union (see Phase 4 list)
  - `Lesson { id, unitId, title, order, exercises[], newItemIds[] }`
  - `Unit { id, title, order, lessons[] }`
  - `Course { units[] }`
- [ ] Export JSON Schema from zod (`zod-to-json-schema`) → used to generate Dart models
- [ ] Tests: every fixture validates

### packages/content

- [ ] Script `download.ts`: fetch JMdict (JSON build from `scriptin/jmdict-simplified`), KANJIDIC2, KanjiVG, Tatoeba ja-en pairs → `packages/content/raw/` (git-ignored)
- [ ] `build-kana.ts`: hand-authored kana table (46 + dakuten + combos, both scripts) → `kana.json`
- [ ] `build-kanji.ts`: filter N5 kanji (~80), attach KanjiVG stroke paths → `kanji.json`
- [ ] `build-vocab.ts`: curated N5 vocab list (~700) joined to JMdict → `vocab.json`
- [ ] `build-sentences.ts`: pick Tatoeba sentences using only known vocab → `sentences.json`
- [ ] `build-course.ts`: authored YAML course outline → generates `Lesson` JSON with exercises
- [ ] Output everything to `apps/mobile/assets/content/` and `packages/db/seed/`
- [ ] Add `content:build` turbo task; mobile `build` depends on it
- [ ] Author the first course outline aimed at JFT-Basic / N5: Unit 1–5 hiragana rows, Unit 6–10 katakana, Unit 11 greetings & self-introduction. Explanations and mnemonics in Mongolian (English as second language)
- [ ] Verify: `pnpm turbo run content:build` produces valid JSON, Flutter can load it

### Flutter side

- [ ] Generate Dart models (freezed) matching the schema
- [ ] `ContentRepository` loads JSON from assets into Drift on first launch (versioned, re-import on content bump)
- [ ] Unit test: all bundled lessons parse

---

## 6. Phase 4 – Lesson engine + kana → N5 (the MVP core)

Goal: complete hiragana, katakana and the first N5 units start to finish. Grammar and examples
explained in Mongolian.

```
 Home / path                 Lesson                      Complete
┌──────────────┐    ┌──────────────────────┐    ┌──────────────────┐
│ 🔥 3  ⭐120   │    │ ✕  ████████░░░  ❤️❤️❤️ │    │   🎉 Lesson done  │
│──────────────│    │                      │    │                  │
│ Unit 1 あ行   │    │  Which sound is this?│    │   +12 XP         │
│   (✓)        │    │        ┌────┐        │    │   92% accuracy   │
│   (✓)        │ →  │        │ あ │        │ →  │   1m 48s         │
│   (▶) ←tap   │    │        └────┘        │    │                  │
│   (🔒)       │    │  [ a ] [ i ] [ u ] [ e ]│    │  [ CONTINUE ]    │
│ Unit 2 か行   │    │                      │    │                  │
│   (🔒)       │    │ ┌──────────────────┐ │    └──────────────────┘
│              │    │ │ ✓ Correct!       │ │
└──────────────┘    │ └──────────────────┘ │
                    └──────────────────────┘
```

Lesson flow inside the engine:

```mermaid
stateDiagram-v2
    [*] --> Intro: lesson has new items
    [*] --> Exercise: no new items
    Intro --> Exercise
    Exercise --> Feedback: answer submitted
    Feedback --> Exercise: correct, queue not empty
    Feedback --> Requeue: wrong (❤️ -1)
    Requeue --> Exercise: hearts > 0
    Requeue --> Failed: hearts = 0
    Feedback --> Complete: correct, queue empty
    Complete --> [*]: save attempt, award XP, update SRS
    Failed --> [*]: save attempt, no XP
```

### Engine

- [ ] `LessonController` (Riverpod notifier): queue of exercises, current index, hearts, mistakes, result
- [ ] Wrong answers get re-queued at the end of the lesson (Duolingo behaviour)
- [ ] Lesson screen shell: progress bar, hearts, close button with "are you sure" sheet
- [ ] Answer feedback banner (green/red slide-up, correct answer shown, haptic + sound)
- [ ] Lesson complete screen: XP earned, accuracy, time, confetti
- [ ] Persist lesson result to Drift (`lesson_attempts`)

### Exercise widgets (kana MVP)

- [ ] `MatchPairs` – 5 kana ↔ 5 romaji tiles, tap to pair
- [ ] `MultipleChoice` – show kana, pick romaji from 4 (and reverse)
- [ ] `ListenAndSelect` – play audio, pick the kana
- [ ] `ListenAndType` – play audio, type romaji (custom on-screen keyboard, no IME)
- [ ] `TraceStroke` – draw the character over a KanjiVG guide; score by stroke count + per-stroke direction similarity
- [ ] `NewItemIntro` – non-graded card introducing a new kana with audio + mnemonic
- [ ] Exercise picker: lesson JSON decides types; widget factory maps `type` → widget

### Home / path

Home ends up showing the readiness score, today's lesson and the next requirement (Phase 6b).
The course path is one tab, not the whole app.

- [ ] Course screen: vertical list of unit → lesson nodes, locked / available / completed states
- [ ] Unit header with title and colour
- [ ] Tapping an available node starts the lesson
- [ ] Verify: new user can do Unit 1 Lesson 1 → 5 and the path unlocks progressively

---

## 7. Phase 5 – Spaced repetition

```mermaid
flowchart LR
    A[Exercise graded] --> B{grade}
    B -- Again --> C[stability ↓<br/>due = today]
    B -- Hard --> D[stability ~<br/>due = +1–2 d]
    B -- Good --> E[stability ↑<br/>due = ×interval]
    B -- Easy --> F[stability ↑↑<br/>due = ×interval × bonus]
    C & D & E & F --> G[(item_reviews)]
    G --> H[Practice tab:<br/>SELECT WHERE due ≤ now]
```

- [ ] Drift table `item_reviews { itemId, itemType, stability, difficulty, due, lastReview, reps, lapses }`
- [ ] Implement FSRS (port `fsrs.js` scheduler; ~200 lines) as a pure Dart class with unit tests against known vectors
- [ ] Every graded exercise reports `(itemId, grade)` → scheduler updates review row
- [ ] "Practice" tab: shows count of due items, starts a review session built from due items (mixed exercise types)
- [ ] Weak-items session when nothing is due
- [ ] Verify: an item answered wrong appears again sooner than one answered right

---

## 8. Phase 6 – Mock tests + Japan readiness

Goal: a student knows their Japanese level and exactly what is left before they can go.

```
 Home                          Requirements (SSW · Care)
┌────────────────────────┐    ┌──────────────────────────────┐
│ READY FOR JAPAN   45%  │    │ ✓ Passport                   │
│ ███████░░░░░░░░        │    │ ◐ Japanese: JFT-Basic A2     │
│ Next: JFT mock test    │ →  │     mock 182/250 (need 200)  │
│────────────────────────│    │ ○ Care skills test           │
│ Today: N5 Unit 3 ▶     │    │ ○ Care Japanese test         │
│ Exam in 42 days        │    │ ○ Health check               │
└────────────────────────┘    │ ○ Pre-departure training     │
                              └──────────────────────────────┘
```

### 6a. Mock tests

- [ ] Test content schema in `packages/schema`: sections, questions (text, audio, image), timing, scoring
- [ ] Mock **JFT-Basic**: 4 sections (script & vocabulary, conversation & expression, listening,
      reading), timed, score out of 250 with the pass line from content
- [ ] Mock **JLPT N4** (after N5 content exists)
- [ ] Result screen: total, per-section score, weakest topics → "practise these" links into lessons
- [ ] Drift `test_attempts` table; readiness uses the best recent attempt
- [ ] Job-field vocabulary sets (care, food service, agriculture, aviation) with practice questions
- [ ] Verify: a full mock test can be taken offline, resumed after app kill, and scored

### 6b. Japan readiness

- [ ] `packages/content/requirements/*.yaml`: one file per path (SSW + field, engineer, student),
      each item with type (`japanese_level`, `skills_test`, `document`, `training`), how it is
      met, source URL and `checkedAt` date
- [ ] Onboarding: pick a path and field, target departure month, exam date if booked
- [ ] Requirements screen: checklist with status (done / in progress / not started) and what to do next
- [ ] Items the app can measure fill in themselves (Japanese level from mock tests, training from lessons)
- [ ] Items the student reports (documents) are ticked by the student; teacher confirmation comes in Phase 7f
- [ ] Readiness score: weighted progress over the path's requirements; Home shows it with the next step
- [ ] Reminders for exam dates and expiring documents
- [ ] Verify: changing a requirement file changes the checklist without a Dart change

---

## 9. Phase 7 – Backend (NestJS + Drizzle + Postgres)

Goal: accounts, cloud sync, audio hosting. App must still work fully offline.
Done in four sub-steps, each deployable on its own.

### 7a. Database package (`packages/db`)

- [x] Drizzle schema files, one per domain:
  - `users (id uuid pk, auth0_sub unique, email, email_verified, name, picture_url, created_at, updated_at, deleted_at)`. Sessions and refresh tokens live in Auth0, so there is no `refresh_tokens` table
  - `user_stats (user_id pk, total_xp, current_streak, longest_streak, last_active_date, streak_freezes, hearts, hearts_refill_at, updated_at)`
  - `lesson_progress (user_id, lesson_id, completed_at, best_accuracy, attempts, updated_at, pk(user_id, lesson_id))`
  - `item_reviews (user_id, item_id, item_type, stability, difficulty, due, last_review, reps, lapses, updated_at, pk(user_id, item_id))`
  - `achievements_unlocked (user_id, achievement_id, unlocked_at, pk(user_id, achievement_id))`
  - `review_log (id, user_id, item_id, exercise_type, grade, correct, response_ms, reviewed_at, client_tz, app_version)` – append-only history of every answer. Synced with progress. Cheap now, impossible to backfill later; the ML work depends on it
  - `sync_log (user_id, device_id, synced_at)`
  - Content tables: `kana`, `kanji`, `vocab`, `sentences`, `units`, `lessons` (jsonb payload + version) – read-only to clients, lets you ship content without an app release
- [x] Indexes: `item_reviews(user_id, due)`, `item_reviews(user_id, updated_at)`, `lesson_progress(user_id, updated_at)`
- [x] `drizzle.config.ts`, scripts: `db:generate`, `db:migrate`, `db:studio`, `db:seed`
- [ ] Zod ↔ Drizzle bridge with `drizzle-zod` so insert/select types reuse `packages/schema` (when first DTO needs it)
- [x] `seed.ts` imports `packages/content` output into content tables
- [x] Verify: `docker compose up -d && pnpm db:migrate && pnpm db:seed` on a clean DB

### 7b. API skeleton (`apps/backend/user`)

- [x] NestJS 12 (ESM) in `apps/backend/user`, pnpm workspace, strict TS, `@repo/*` workspace deps
- [x] Config module with zod-validated env (base vars and `AUTH0_DOMAIN`, `AUTH0_AUDIENCE` done; add `R2_*`, `SENTRY_DSN` as features land)
- [x] `DrizzleModule`: global provider wrapping `packages/db` client with connection pool
- [x] Pino logger (`nestjs-pino`), request id, redaction of auth headers
- [x] `GET /health` (Terminus: db ping), `GET /ready`
- [x] `ZodValidationPipe` (own, ~20 lines; nestjs-zod doesn't support Nest 12) – DTOs come from `packages/schema`
- [x] Global exception filter → RFC 7807 problem+json
- [ ] Rate limiting (`@nestjs/throttler`) on auth routes
- [x] `@nestjs/swagger` wired, OpenAPI JSON emitted at build (`openapi.json` as turbo output)
- [x] Turbo tasks: `lint`, `test`, `test:e2e`, `build`, `openapi`
- [x] e2e test harness against the docker-compose Postgres (fresh `nihongo_test` DB per run); CI uses a Postgres service container
- [x] Multi-stage `Dockerfile` (pnpm fetch → build → node:22-slim runtime, non-root user)
- [x] Verify: `docker build` + run container → `/health` returns 200

### 7b′. Move the API onto oRPC (do this before 7c, while only 3 endpoints exist)

Why: one contract defines path, input and output for every endpoint. The backend implements it,
the OpenAPI spec is generated from it, the Dart client is generated from that spec, and the
admin app imports the contract for a fully typed client with no codegen.

```
packages/schema (zod) ─▶ packages/contract (oRPC) ─┬─▶ apps/backend/user  @Implement in Nest controllers
                                                   ├─▶ openapi.json  ─▶ Dart client (apps/mobile)
                                                   └─▶ apps/admin    typed oRPC client
```

- [x] `packages/contract`: `content.manifest`, `content.kana` procedures with `openapi.path` meta and zod output schemas
- [x] `apps/backend/user`: add `@orpc/nest`, `@orpc/server`, `@orpc/openapi`; register `ORPCModule`
- [x] Content controller implements the contract with `@Implement(contract.content.*)`; health endpoints stay plain Nest
- [x] Generate `openapi.json` with `@orpc/openapi`'s generator; drop `@nestjs/swagger` decorators and `ZodValidationPipe`
- [x] Serve API reference in dev: Scalar at `/docs`, spec at `/openapi.json`
- [x] problem+json for oRPC errors via `sendResponseInterceptors` (oRPC 1.16 has no Rethrow plugin; that's in the 2.x beta)
- [x] Body size capped by Nest's JSON body parser (100 kb), kept on instead of `bodyParser: false`; oRPC 1.16 has no Request Limit plugin
- [x] Update e2e tests; guards and pipes only run over HTTP, not in `call()` unit tests
- [x] Verify: `/v1/content/*` responses unchanged, `openapi.json` paths unchanged, e2e green

### 7c. Auth (Auth0)

Auth0 hosts sign-in and sessions. The API never sees passwords or social-provider tokens;
it verifies Auth0 access tokens and keeps its own `users` row per Auth0 user.

- [x] Contract `users.me` (`GET /v1/me`), marked with a bearer security scheme in openapi.json
- [x] `AuthGuard` verifies RS256 access tokens with `jose` against `https://AUTH0_DOMAIN/.well-known/jwks.json` (issuer + audience checked); 401 problem+json with `WWW-Authenticate: Bearer`, 503 when Auth0 isn't configured
- [x] `users` keyed by `auth0_sub`; first `GET /v1/me` creates the row, later calls refresh profile fields the token carries
- [x] Post-Login Action adds `email`, `email_verified`, `name`, `picture` as namespaced claims (README, "Auth0 setup")
- [x] Unit tests with a local key pair; e2e tests sign real tokens against the test database
- [x] Flutter: `auth0_flutter` with Google, Facebook, Apple (iOS only) and email buttons on Profile; credentials stored and refreshed by its credentials manager; guest mode when not configured
- [ ] Create the Auth0 tenant, API, native app and social connections (README, "Auth0 setup")
- [ ] Production social apps: Google OAuth client, Meta app + app review, Apple Services ID + key
- [ ] Mobile API client sends `Authorization: Bearer` from `credentialsManager.credentials()` (lands with sync, 7d)
- [ ] `DELETE /v1/me` – soft delete + delete the Auth0 user via the Management API; purge job after 30 days (App Store requirement)
- [ ] Guest → account merge: first sync after sign-in uploads the guest's local progress
- [ ] Prompt to sign in after Unit 1 ("save your progress")
- [ ] Rate limiting (`@nestjs/throttler`) on signed-in routes
- [ ] Verify on devices: each provider signs in, token refresh after expiry, sign-out clears the session

### 7d. Sync

- [ ] Contract `sync.push` in `packages/contract`; zod input/output reused from `packages/schema`
- [ ] `POST /sync` – body `{ deviceId, lastSyncAt, changes: { userStats?, lessonProgress[], itemReviews[], achievements[] } }`
  - server applies pushes with per-row conflict rule: `updated_at` last-write-wins for progress/reviews, `max()` for xp/streak, union for achievements
  - returns rows changed on server since `lastSyncAt` + new `syncedAt`
- [ ] Single transaction per sync call; idempotent (replaying same push is a no-op)
- [ ] `GET /content/manifest` – content version + per-table checksums; `GET /content/:table` – paged rows. App re-imports when version bumps
- [ ] Flutter `SyncService`: runs on login, app resume, lesson complete, review complete; retries with backoff; never blocks UI
- [ ] Generate Dart client from `openapi.json` (`openapi-generator` dart-dio) into `apps/mobile/lib/api/` as a turbo task depending on `backend#openapi`
- [ ] Verify: complete lessons on device A, log in on device B, progress appears; go offline on A, do lessons, come back → merges cleanly

### 7e. Storage, jobs, deploy

- [ ] R2 bucket `nihongo-media` (public read via custom domain), MinIO locally with same bucket name
- [ ] `StorageService` using `@aws-sdk/client-s3`; presigned upload for avatars
- [ ] Cron jobs (`@nestjs/schedule`, leader-elected via Postgres advisory lock so 2 instances don't double-run):
  - 00:05 per timezone bucket: streak audit, consume streak freeze or reset
  - hourly: purge soft-deleted users past 30 days, expire refresh tokens
- [ ] Neon project: `main` branch for prod, `dev` branch for staging; `DATABASE_URL` per env
- [ ] Fly.io app: 2 machines (`shared-cpu-1x`), `fly.toml` with health checks, secrets via `fly secrets`
- [ ] GitHub Actions `deploy-api.yml`: on tag `api-v*` → test → build image → `fly deploy` → run migrations as release command
- [ ] Sentry (`@sentry/nestjs`) + uptime monitor on `/health` (Better Stack free tier)
- [ ] Backups: confirm Neon PITR enabled; test a restore once and write down the steps
- [ ] Verify: prod `/health` green, Flutter prod flavor syncs against it

### 7f. Classes for the pilot school

- [ ] `organizations`, `org_members (role: owner | teacher | student)`, `classes`, `class_members` tables
- [ ] Join a class with a code or QR in the app
- [ ] Teacher web view (in `apps/admin` with an org-scoped role): roster, lessons done, mock test
      scores, readiness per student, weak topics for the class
- [ ] Teachers confirm requirement items (exam passed, documents checked); confirmed items show a badge
- [ ] Homework: assign lessons or a mock test with a due date
- [ ] Verify: a teacher sees a student's mock score and readiness within a minute of a sync

---

## 10. Phase 8 – Audio

- [ ] Script `packages/content/gen-audio.ts`: for every kana/vocab/sentence without audio, call Azure TTS (ja-JP-NanamiNeural), save mp3, upload to R2 via `StorageService` logic (shared S3 helper in `packages/db` or a tiny `packages/storage`), write key back into content JSON
- [ ] Bundle kana audio in app assets (tiny); stream vocab/sentence audio with on-device cache (`just_audio` + `flutter_cache_manager`)
- [ ] Slow-speed replay button (turtle) on listening exercises
- [ ] Correct/incorrect/complete SFX
- [ ] Verify: airplane mode → kana lessons still have audio

---

## 11. Phase 9 – Polish, motivators & instrumentation

Motivators support the course; they are not the product.

- [ ] Daily goal + streak (with a fake-clock test), XP for lessons and tests
- [ ] Daily reminder notification; exam-date and document reminders from Phase 6b
- [ ] Onboarding flow: path + field, daily goal, notification permission, optional sign-in, class code
- [ ] Animations: path node pop, XP count-up, readiness score fill
- [ ] Haptics on answer
- [ ] Empty states, error states, offline banner
- [ ] Accessibility: semantics labels, font scaling, reduce-motion respected
- [ ] Review all Mongolian and English strings with a native speaker / teacher (localisation itself starts in Phase 2)
- [ ] Analytics: PostHog (self-host or cloud), events: lesson_start, lesson_complete, exercise_answer, test_complete, requirement_done
- [ ] Crash reporting: Sentry
- [ ] Performance pass: 60 fps on a mid-range Android device, cold start < 2 s
- [ ] Privacy policy + terms page (required by both stores)

---

## 12. Phase 10 – Release

- [ ] App name, bundle IDs, icons (all sizes), splash
- [ ] iOS: signing, capabilities (Sign in with Apple, Push), `flutter build ipa`, upload to TestFlight
- [ ] Android: upload key, `flutter build appbundle`, Play Console internal testing track
- [ ] Store listings: screenshots (use `screenshots` package or Fastlane), description, keywords
- [ ] Fastlane lanes for both platforms, wired into GitHub Actions on tag
- [ ] Closed beta with 10–20 testers for 2 weeks; fix top issues
- [ ] Public release

---

## 13. Post-MVP roadmap (pick in order of pilot feedback)

**Learning**

- [ ] N4 course and mock JLPT N4; grammar exercises (`WordBank`, `FillParticle`, `Translate`)
- [ ] Kanji track with tracing and stroke-order checking
- [ ] Speaking practice (`speech_to_text`, ja-JP) and AI role-play for interviews and the JFT conversation section
- [ ] Furigana toggle per item based on SRS mastery
- [ ] Short stories and dialogues set in Japanese workplaces

**School tools**

- [ ] QR attendance per lesson, absence flags
- [ ] Progress reports (PDF / CSV, in Mongolian) for schools and sponsors
- [ ] Seat-based licensing per organisation

**Stage 2 – Get hired**

- [ ] Verified candidate profile: Japanese level, readiness, attendance, recorded interview answers
- [ ] Employer view and interview scheduling (with the sending organisation)

**Stage 3 – Prepare to leave**

- [ ] Pre-departure training course: workplace manners, life rules (garbage, trains, city hall), visa steps
- [ ] Completion records the organisation can show

**Stage 4 – Arrive and live in Japan**

- [ ] Arrival checklist: residence card, address registration, housing, SIM, bank account
- [ ] Support chat in Mongolian; regular check-ins for registered-support duties
- [ ] Keep learning: job Japanese, path toward 特定技能2号

**Platform**

- [ ] Other source languages (Vietnamese, Nepali, Indonesian, Myanmar) using the same content pipeline
- [ ] Admin panel (`apps/admin`, Next.js) – see breakdown below
- [ ] Machine learning (`apps/ml`, Python) – see breakdown below
- [ ] Extra game features if pilot data shows they help: hearts, leagues, friends, Blitz mode
- [ ] Move cron jobs to BullMQ + Redis when they need retries/visibility; move audio generation there too
- [ ] Read replicas / connection pooling (PgBouncer or Neon pooler) when sync traffic grows

---

### Admin panel (post-MVP)

One web app in `apps/admin`, talking only to the admin API in `apps/backend/admin` (separate NestJS app, same packages). No direct DB access from the browser.

```
apps/admin (Next.js)  ──HTTPS + admin JWT──▶  apps/backend/admin /v1/admin/*  ──▶  Postgres
```

**Foundation**

- [ ] `role` enum on `users` (`user`, `support`, `admin`) + migration
- [ ] `RolesGuard` + `@Roles('admin')` decorator in backend; all admin routes under `/v1/admin`
- [ ] Admin sign-in through Auth0 with an admin role, separate from student accounts
- [ ] `admin_audit_log (id, admin_id, action, target_user_id, payload jsonb, created_at)` – every admin write is logged
- [ ] Scaffold `apps/admin` with Next.js + typed oRPC client (`@orpc/client`) importing `packages/contract`; admin procedures live under `admin.*`

**User management**

- [ ] User list: search by email / username / id, filter by created date, last active, streak
- [ ] User detail: profile, stats, lesson progress, test scores, readiness, sync log
- [ ] Actions: suspend / unsuspend, block sign-in in Auth0, delete account (with confirm)
- [ ] Support notes on a user (visible to support + admin)

**Content management**

- [ ] Browse / edit kana, kanji, vocab, sentences, lessons (validated by `packages/schema`)
- [ ] Publish flow: draft → preview → bump `content_manifest.version` (apps pick it up on next sync)

**Insights**

- [ ] Dashboard: DAU / WAU, signups, lesson completions, mock test scores, readiness distribution, retention (D1 / D7 / D30)
- [ ] Hardest items: exercises with the highest error rate, to fix content

### Schools (B2B)

Classes, teacher view and homework are in the MVP (Phase 7f). Attendance, reports and
licensing are on the roadmap above.

### Machine learning (post-MVP, `apps/ml`)

Python service, managed with `uv`, FastAPI for the few live endpoints. Lives in the monorepo
with a small `package.json` so Turbo runs its lint/test/build, like `apps/mobile`. Mostly batch
jobs that read Postgres (a read replica later) and write results back to tables the NestJS
backend reads. The mobile app never calls Python directly; live calls go through the oRPC
contract. Models used during lessons run on device so lessons stay offline.

```
review_log ─▶ apps/ml (batch) ─▶ fsrs_params, item_difficulty tables ─▶ backend ─▶ app (via sync)
app ─audio─▶ backend ─▶ apps/ml /score-pronunciation (live)
apps/ml (training) ─▶ .tflite / Core ML ─▶ bundled in apps/mobile (on device)
```

In order of value:

- [ ] **Personal FSRS parameters**: nightly job runs the FSRS optimizer per user from `review_log`, stores `fsrs_params`, app picks them up on sync
- [ ] **Handwriting recognition** for kana/kanji tracing: train in Python, export to TensorFlow Lite / Core ML, run on device
- [ ] **Item difficulty & content quality**: flag exercises with unusual error rates; shown in the admin panel
- [ ] **Churn prediction**: score users at risk of breaking their streak; better-timed reminders
- [ ] **Pronunciation scoring** (server): ASR (e.g. Whisper) + alignment; pitch-accent feedback later
- [ ] **LLM practice** via the Claude API in the NestJS backend (no Python needed): grammar explanations in Mongolian, short role-play dialogues
- [ ] Docker image for `apps/ml`, added to `docker-compose.yml`; separate Fly.io app in prod

Skip until there are many users: custom recommendation engines, training own language models.

## Working rules

- One phase per branch, PR to `main`, CI green before merge.
- Every exercise type gets a widget test with a fake controller.
- Content changes never require Dart changes. If they do, the schema is wrong.
- Keep the app usable with zero network until Phase 7, and after Phase 7 too.
- Requirement rules live in content files with a source and `checkedAt` date, never in code.
- Every API change starts in `packages/contract` (oRPC, with zod from `packages/schema`); regenerate the Dart client, never hand-edit it.
- Backend layers: controller (oRPC contract) → service (business rules, never touches the DB) → repository (`*.repository.ts`, the only code that imports Drizzle). Enforced by ESLint.
- Migrations are forward-only and reviewed; no `drizzle-kit push` against prod.
