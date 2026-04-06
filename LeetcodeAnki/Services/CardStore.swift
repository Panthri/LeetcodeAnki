import Foundation
import Combine

// MARK: - CardStore
/// The central data store for all flashcards. Loads seed data and
/// persists SM-2 progress to UserDefaults.
final class CardStore: ObservableObject {

    // MARK: - Published State
    @Published private(set) var allCards: [Card] = []
    @Published private(set) var streak: Int = 0
    @Published private(set) var lastStudiedDate: Date? = nil

    // MARK: - Private Keys
    private let progressKey    = "com.panthri.leetcodeanki.progress"
    private let streakKey      = "com.panthri.leetcodeanki.streak"
    private let lastStudiedKey = "com.panthri.leetcodeanki.lastStudied"

    // MARK: - Init
    init() {
        loadCards()
        loadStreak()
    }

    // MARK: - Computed Properties

    /// Cards whose next review date is today or earlier.
    var dueCards: [Card] {
        allCards.filter { $0.isDue }
    }

    /// Cards that have been reviewed at least once and are not yet mastered.
    var learningCards: [Card] {
        allCards.filter { !$0.isNew && !$0.isMastered }
    }

    /// Cards considered mastered (≥5 successful repetitions, good ease factor).
    var masteredCards: [Card] {
        allCards.filter { $0.isMastered }
    }

    /// Unseen cards.
    var newCards: [Card] {
        allCards.filter { $0.isNew }
    }

    /// Due count grouped by category.
    func dueCount(for category: Category) -> Int {
        allCards.filter { $0.category == category && $0.isDue }.count
    }

    /// All cards for a given category.
    func cards(for category: Category) -> [Card] {
        allCards.filter { $0.category == category }
    }

    /// Cards due within the next N days (used for calendar view).
    func cardsDue(inNext days: Int) -> [Date: Int] {
        var result: [Date: Int] = [:]
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for card in allCards {
            let reviewDay = calendar.startOfDay(for: card.nextReviewDate)
            if let diff = calendar.dateComponents([.day], from: today, to: reviewDay).day,
               diff >= 0 && diff < days {
                result[reviewDay, default: 0] += 1
            }
        }
        return result
    }

    // MARK: - Rating

    /// Apply an SM-2 rating to a card and persist.
    func rate(card: Card, rating: Rating) {
        let updated = SM2Algorithm.calculateNextReview(card: card, rating: rating)
        if let idx = allCards.firstIndex(where: { $0.id == card.id }) {
            allCards[idx] = updated
        }
        saveProgress()
        updateStreak()
    }

    // MARK: - Persistence

    private func loadCards() {
        // Start with seed data
        var cards = SeedCards.all

        // Load any saved progress and overlay it
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let savedProgress = try? JSONDecoder().decode([UUID: CardProgress].self, from: data) {
            cards = cards.map { card in
                if let progress = savedProgress[card.id] {
                    var updated = card
                    updated.interval       = progress.interval
                    updated.repetitions    = progress.repetitions
                    updated.easeFactor     = progress.easeFactor
                    updated.nextReviewDate = progress.nextReviewDate
                    updated.lastRating     = progress.lastRating
                    return updated
                }
                return card
            }
        }

        allCards = cards
    }

    private func saveProgress() {
        var progressMap: [UUID: CardProgress] = [:]
        for card in allCards {
            progressMap[card.id] = CardProgress(from: card)
        }
        if let data = try? JSONEncoder().encode(progressMap) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    private func loadStreak() {
        streak = UserDefaults.standard.integer(forKey: streakKey)
        if let ts = UserDefaults.standard.object(forKey: lastStudiedKey) as? Date {
            lastStudiedDate = ts
        }
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let last = lastStudiedDate {
            let lastDay = calendar.startOfDay(for: last)
            if calendar.isDate(lastDay, inSameDayAs: today) {
                // Same day — no change
                return
            } else if let diff = calendar.dateComponents([.day], from: lastDay, to: today).day, diff == 1 {
                // Consecutive day
                streak += 1
            } else {
                // Streak broken
                streak = 1
            }
        } else {
            streak = 1
        }

        lastStudiedDate = Date()
        UserDefaults.standard.set(streak, forKey: streakKey)
        UserDefaults.standard.set(lastStudiedDate, forKey: lastStudiedKey)
    }

    /// Reset all progress back to seed defaults (useful for testing).
    func resetProgress() {
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: lastStudiedKey)
        allCards = SeedCards.all
        streak = 0
        lastStudiedDate = nil
    }
}

// MARK: - CardProgress (lightweight Codable snapshot for UserDefaults)
private struct CardProgress: Codable {
    let interval: Int
    let repetitions: Int
    let easeFactor: Double
    let nextReviewDate: Date
    let lastRating: Rating?

    init(from card: Card) {
        self.interval       = card.interval
        self.repetitions    = card.repetitions
        self.easeFactor     = card.easeFactor
        self.nextReviewDate = card.nextReviewDate
        self.lastRating     = card.lastRating
    }
}
