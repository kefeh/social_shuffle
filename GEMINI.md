# Project: SocialShuffle AI

## Project Overview

**SocialShuffle AI** is a mobile party game application built with Flutter. It functions as a "digital party kit," consolidating multiple social game types like Trivia, Charades, and Truth or Dare into a single app.

The core of the application is the **"Bookshelf Strategy"**:
*   **Stable Engines:** The app provides hard-coded UI templates for specific game mechanics (e.g., Quiz, Flip Card, Task, Voting).
*   **Infinite Content:** Game content is delivered via "Decks." The app includes pre-packaged offline "Seed Decks" and allows users to generate their own custom "Gen Decks" using the Google Gemini API.

### Key Technologies
*   **Framework:** Flutter (Dart)
*   **State Management:** Riverpod
*   **Local Database:** Hive or Isar for storing user-generated decks.
*   **AI Provider:** `google_generative_ai` SDK (Gemini 1.5 Flash).
*   **Navigation:** Navigator 1.0.
*   **Assets:** Offline content is stored as JSON files in `assets/decks/`.

### Architecture
*   **Engine-Content Separation:** A core architectural principle is the separation of game logic (Engines) from the game content (Decks).
*   **Offline First:** The app is designed to be fully functional offline using the pre-installed System Decks. An internet connection is only required for generating new decks.

## Building and Running

### Prerequisites
*   Flutter SDK installed.
*   An connected device or running emulator.

### Running the App
```bash
flutter pub get
flutter run
```

### Running Tests
```bash
flutter test
```

## Development Conventions

### Theming
*   The app uses **Dark Mode only**.
*   Theming should be configured in the `MaterialApp` `theme` property rather than hard-coding styles in individual widgets.

### Coding Style
*   **Separation of Concerns:** Maintain a clear folder structure to separate different parts of the application.
*   **Composable Widgets:** Prefer creating smaller, reusable widgets over large, monolithic ones.
*   **Widget Classes:** Use standard `StatelessWidget` or `StatefulWidget` classes over functions that return widgets.
*   **Logging:** Use `log` from `dart:developer` for logging. Avoid using `print` or `debugPrint`.

### AI Content Generation
*   **Generator Dialog:** A modal will be used to get a `Topic` and optional `Vibe` from the user.
*   **API Interaction:** The app will send a prompt to the Gemini 1.5 Flash model and expect a structured JSON response.
*   **Error Handling:** API failures should be handled gracefully with a user-friendly toast message.

### Data Schemas

**Deck Object:**
```json
{
  "id": "uuid_v4",
  "title": "90s Hip Hop",
  "game_engine_id": "quiz",
  "is_system": false,
  "created_at": "timestamp",
  "cards": [ ... ]
}
```

**Card Object (Polymorphic example for Quiz):**
```json
{
  "content": "Who released Illmatic?",
  "options": ["Nas", "Jay-Z", "Biggie", "Tupac"],
  "correct_index": 0,
  "meta": { "timer": 15, "forfeit": "Take 1 sip" }
}
```
