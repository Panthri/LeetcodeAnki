# LeetcodeAnki

A spaced repetition flashcard app for LeetCode interview prep, built with SwiftUI for iOS. Study smarter, not harder — the SM-2 algorithm schedules each card at the optimal moment for long-term retention.

---

## Screenshots

| Home | Study | Progress |
|------|-------|----------|
| *(screenshot placeholder)* | *(screenshot placeholder)* | *(screenshot placeholder)* |

---

## Features

- **SM-2 Spaced Repetition** — Cards are scheduled based on how well you know them. Easy cards come back less often; hard cards repeat sooner.
- **37 Curated Problems** — Real LeetCode problems covering Arrays, Linked Lists, Trees & Graphs, Stacks & Strings, Sorting & Searching, DP & Math, Data Structures, JS/Frontend, System Design, and Behavioral.
- **Flashcard Flip Animation** — Smooth 3D card-flip reveals hints and solution approaches.
- **4-Level Rating** — Rate each card Again / Hard / Good / Easy. The algorithm adjusts future intervals accordingly.
- **Streak Tracking** — Daily study streak counter keeps you accountable.
- **Category Browser** — Browse all cards by topic. Filter by difficulty. Sort by next review, title, or status.
- **Progress Dashboard** — Bar chart breakdown by category, mastery ring, and a 7-day upcoming review calendar.
- **Full Card Detail** — Collapsible hint and solution sections, SM-2 stats, and a one-tap link to the LeetCode problem page.
- **Offline-First** — All card data and progress is stored locally (UserDefaults + CoreData). No account required.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Persistence | UserDefaults (progress), CoreData (future expansion) |
| Algorithm | SM-2 Spaced Repetition |
| Charts | Swift Charts (iOS 16+) |
| Minimum iOS | 16.0 |
| Language | Swift 5.9 |

---

## Installation / Build

### Requirements

- Xcode 15 or later
- iOS 16.0+ device or simulator
- macOS Ventura (13.0) or later

### Steps

1. Clone the repository:
   ```
   git clone https://github.com/yourhandle/LeetcodeAnki.git
   cd LeetcodeAnki
   ```

2. Open the Xcode project:
   ```
   open LeetcodeAnki.xcodeproj
   ```

3. Select your target device or simulator in Xcode.

4. Press **Cmd+R** to build and run.

> No third-party dependencies. No CocoaPods, no Swift Package Manager packages required.

---

## Project Structure

```
LeetcodeAnki/
├── App/
│   ├── LeetcodeAnkiApp.swift       # @main entry point, CoreData setup
│   └── ContentView.swift           # Root TabView
├── Models/
│   └── Card.swift                  # Card struct, Category, Difficulty, Rating enums
├── Services/
│   ├── SM2Algorithm.swift          # SM-2 spaced repetition implementation
│   └── CardStore.swift             # ObservableObject: state, persistence, rating
├── Data/
│   └── SeedCards.swift             # 37 curated LeetCode problem cards
├── ViewModels/
│   └── StudyViewModel.swift        # Study session state machine
└── Views/
    ├── HomeView.swift              # Dashboard with due count, category grid, streak
    ├── StudyView.swift             # Flashcard flip + rating buttons
    ├── CardDetailView.swift        # Full card with collapsible hint/solution
    ├── ProgressView.swift          # Stats, charts, upcoming reviews calendar
    └── CategoryView.swift          # Per-category card list with filter/sort
```

---

## Spaced Repetition Algorithm (SM-2)

LeetcodeAnki implements the SuperMemo SM-2 algorithm:

- **Again (0)**: Reset repetitions to 0, review tomorrow. Ease factor decreases.
- **Hard (1)**: Reset repetitions, review tomorrow. Slight ease factor decrease.
- **Good (3)**: Normal progression. Interval × ease factor. EF unchanged.
- **Easy (5)**: Fastest progression. EF increases, longer future intervals.

**Ease Factor formula:**
```
EF_new = max(1.3, EF + 0.1 - (5 - q) × (0.08 + (5 - q) × 0.02))
```

**Interval schedule:**
- Repetition 0 → 1 day
- Repetition 1 → 6 days
- Repetition n → prev_interval × EF

---

## Card Categories

| Category | Count | Topics |
|----------|-------|--------|
| Arrays | 6 | Two Sum, 3Sum, Kadane's, Trapping Rain Water, Merge Intervals, Meeting Rooms II |
| Linked List | 3 | Merge Sorted Lists, Reverse K-Group, Cycle Detection II |
| Trees & Graphs | 4 | Number of Islands, Clone Graph, Word Ladder, Level Order Traversal |
| Stacks & Strings | 4 | Min Stack, Decode String, Generate Parentheses, Valid Parentheses |
| Sorting & Searching | 2 | Search in Rotated Array, Merge K Sorted Lists |
| DP & Math | 5 | N-Queens, Coin Change, LIS, Word Break, Climbing Stairs |
| Data Structures | 2 | LRU Cache, Trie |
| JS / Frontend | 2 | Debounce, Flatten Nested Array |
| System Design | 3 | URL Shortener, News Feed, Distributed Cache |
| Behavioral | 4 | Tell Me About Yourself, Conflict, Technical Failure, Why This Company |

---

## Monetization Model (Planned)

- **Free tier**: All 37 seed cards, unlimited reviews, progress tracking.
- **Pro (one-time $4.99)**: Unlock custom card creation, iCloud sync, export progress.
- **No subscriptions.** No ads. No data collection.

StoreKit 2 integration is scaffolded and ready for the Pro unlock flow.

---

## Contributing

Contributions are welcome! Ideas for new cards, bug fixes, and UI improvements are all appreciated.

1. Fork the repo and create a feature branch.
2. Add your changes (follow existing code style).
3. Submit a pull request with a clear description.

To add new seed cards, edit `LeetcodeAnki/Data/SeedCards.swift` and add a new `Card(...)` entry to the `all` array.

---

## License

MIT License. See LICENSE for details.
