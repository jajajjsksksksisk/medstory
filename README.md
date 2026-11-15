# MedStory 🌟

**AI-powered study companion for medical students**

Turn PDFs and lecture notes into:
- Clear exam-focused **summaries**
- **Flashcards** with modern **FSRS** spaced repetition
- Memorable **story mnemonics**
- **Last-day revision** ultra-short notes

All organized by Subject → Topic.

---

## Features (v0.2)

| Feature | Status |
|---------|--------|
| Paste notes → AI summary | ✅ |
| Auto-generate flashcards | ✅ |
| FSRS spaced repetition | ✅ |
| Story-line mnemonics | ✅ |
| Subject / Topic organization | ✅ |
| **Last Day Revision** mode | ✅ |
| Local storage (Hive) | ✅ |
| Gemini AI (optional) | ✅ |
| Offline demo mode (no key needed) | ✅ |
| PDF upload | Coming next |

---

## Quick Start

```bash
git clone https://github.com/jajajjsksksksisk/medstory.git
cd medstory
flutter pub get
flutter run
```

### Enable real AI (recommended)

1. Get a free Gemini API key: https://aistudio.google.com/app/apikey
2. Run with the key:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

Or put the key in `lib/core/constants/app_constants.dart` (do **not** commit real keys to public repos).

Without a key the app still works in **demo mode** so you can test the full flow.

---

## How to use

1. **Upload / Paste Notes** → choose Subject + optional Topic → paste text → Generate
2. App creates:
   - Summary
   - Flashcards (immediately due for review)
   - Story mnemonics
   - Last-day high-yield notes
3. **Review** → rate cards (Again / Hard / Good / Easy) → FSRS schedules next review
4. **Last Day Revision** → open condensed notes by subject before exams
5. **Subjects** → browse cards by Anatomy, Pharma, Patho, etc.

---

## Project structure

```
lib/
├── core/
│   ├── constants/
│   └── services/          # Storage, AI, FSRS
├── features/
│   ├── home/
│   ├── upload/
│   ├── review/
│   ├── last_day/          # Last-day revision
│   ├── subjects/
│   ├── flashcards/
│   └── stories/
└── shared/models/
```

---

## Roadmap

- [ ] Real PDF text extraction
- [ ] Cloud sync (Firebase / Supabase)
- [ ] Export to Anki
- [ ] Better FSRS state persistence
- [ ] Exam countdown intensifier
- [ ] Premium / monetization

---

Made for MBBS students who want to learn more with less stress.
