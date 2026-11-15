# MedStory 🌟

**AI-powered study companion for medical students**

Turn PDFs and lecture notes into clear summaries, smart flashcards (FSRS), and memorable story-mnemonics — all in one place.

Built for MBBS / MD students who want to study smarter and remember high-yield concepts longer.

---

## Features (MVP)

- 📄 Upload PDFs / notes → AI summary (exam-focused)
- 📚 Generate high-quality flashcards
- 🧠 **FSRS** spaced repetition (modern algorithm, better than SM-2)
- 📝 Story-line / narrative mnemonics for hard concepts
- ⏰ Smart reminders for forgettable high-yield facts
- 🗂️ Organized by Subject → Topic → Chapter
- Offline-first local storage

---

## Tech Stack

| Layer              | Choice                          |
|--------------------|---------------------------------|
| Framework          | Flutter (Android + iOS)         |
| Spaced Repetition  | `fsrs` package (FSRS algorithm) |
| Local Storage      | Hive / Isar (planned)           |
| State Management   | Riverpod                        |
| AI Summaries       | Gemini / OpenAI (via secure backend or Firebase AI) |
| Backend (later)    | Firebase or Supabase            |

---

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   ├── constants/
│   └── utils/
├── features/
│   ├── home/
│   ├── upload/
│   ├── flashcards/
│   ├── stories/
│   ├── review/
│   └── subjects/
└── shared/
    ├── models/
    └── widgets/
```

---

## Getting Started

### 1. Prerequisites
- Flutter SDK 3.24+ (stable)
- Android Studio / VS Code + Flutter extensions
- A physical device or emulator

### 2. Clone & Run

```bash
git clone https://github.com/jajajjsksksksisk/medstory.git
cd medstory
flutter pub get
flutter run
```

### 3. Important next steps for you

1. **AI API Key**  
   For real PDF summarization and story generation you need either:
   - Google Gemini API key (free tier available), or
   - OpenAI API key  
   Store it securely (never hard-code in the app). Best practice: use Firebase AI Logic or a small backend proxy.

2. **Firebase (recommended)**  
   ```bash
   flutterfire configure
   ```
   Enable Authentication + Firestore / Storage if you want cloud sync later.

3. **PDF text extraction**  
   Packages like `syncfusion_flutter_pdf` or `pdf_text` can be added.

---

## Roadmap

### Phase 1 (Current foundation)
- [x] Project structure
- [x] FSRS integration
- [x] Basic navigation & screens
- [ ] Local storage of cards & notes
- [ ] Simple AI summary placeholder

### Phase 2
- Real PDF upload + text extraction
- Working AI summarization + flashcard generation
- Story mnemonic generator
- Spaced repetition review session

### Phase 3
- Weak spots / forgettable facts dashboard
- Exam countdown mode
- Dark mode polish + medical UI theme
- Export to Anki

### Phase 4 (Monetization)
- Free tier + Premium subscription
- Exam packs

---

## Deployment Guide (High-level)

### Android (Google Play)
1. Create a Google Play Console account
2. `flutter build appbundle --release`
3. Upload the `.aab` file
4. Fill store listing, screenshots, privacy policy

### iOS (App Store)
1. Apple Developer account ($99/year)
2. Open `ios/Runner.xcworkspace` in Xcode
3. Configure signing & capabilities
4. `flutter build ipa`
5. Upload via Transporter or Xcode

### Recommended free hosting for backend
- Firebase (Auth + Firestore + Storage + AI)
- Supabase (open-source alternative)

---

## Contributing

This is currently a solo student project. Feel free to open issues or PRs.

---

Made with ❤️ for medical students who want to learn more with less stress.
