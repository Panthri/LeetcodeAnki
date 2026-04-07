import Foundation
import Combine

// MARK: - CardStore
final class CardStore: ObservableObject {

    // MARK: - Published State
    @Published private(set) var allCards: [Card] = []
    @Published private(set) var streak: Int = 0
    @Published private(set) var lastStudiedDate: Date? = nil

    // MARK: - Private Keys
    private let progressKey    = "com.panthri.leetcodeanki.progress"
    private let streakKey      = "com.panthri.leetcodeanki.streak"
    private let lastStudiedKey = "com.panthri.leetcodeanki.lastStudied"
    private let customCardsKey = "com.panthri.leetcodeanki.customCards"

    // MARK: - Init
    init() {
        loadCards()
        loadStreak()
    }

    // MARK: - Computed Properties

    var dueCards: [Card] {
        allCards.filter { $0.isDue }
    }

    var learningCards: [Card] {
        allCards.filter { !$0.isNew && !$0.isMastered }
    }

    var masteredCards: [Card] {
        allCards.filter { $0.isMastered }
    }

    var newCards: [Card] {
        allCards.filter { $0.isNew }
    }

    var customCards: [Card] {
        allCards.filter { $0.isCustom }
    }

    func dueCount(for category: Category) -> Int {
        allCards.filter { $0.category == category && $0.isDue }.count
    }

    func cards(for category: Category) -> [Card] {
        allCards.filter { $0.category == category }
    }

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

    func rate(card: Card, rating: Rating) {
        let updated = SM2Algorithm.calculateNextReview(card: card, rating: rating)
        if let idx = allCards.firstIndex(where: { $0.id == card.id }) {
            allCards[idx] = updated
        }
        saveProgress()
        saveCustomCards()
        updateStreak()
    }

    // MARK: - Custom Card CRUD

    func addCard(_ card: Card) {
        var newCard = card
        newCard.isCustom = true
        allCards.append(newCard)
        saveCustomCards()
        saveProgress()
    }

    func updateCard(_ card: Card) {
        guard card.isCustom, let idx = allCards.firstIndex(where: { $0.id == card.id }) else { return }
        allCards[idx] = card
        saveCustomCards()
        saveProgress()
    }

    func deleteCard(_ card: Card) {
        guard card.isCustom else { return }
        allCards.removeAll { $0.id == card.id }
        saveCustomCards()
        saveProgress()
    }

    // MARK: - Persistence

    private func loadCards() {
        var cards = SeedCards.all

        // Load custom cards
        if let data = UserDefaults.standard.data(forKey: customCardsKey),
           let custom = try? JSONDecoder().decode([Card].self, from: data) {
            cards.append(contentsOf: custom)
        }

        // Overlay saved progress
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

    private func saveCustomCards() {
        let custom = allCards.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(custom) {
            UserDefaults.standard.set(data, forKey: customCardsKey)
        }
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
                return
            } else if let diff = calendar.dateComponents([.day], from: lastDay, to: today).day, diff == 1 {
                streak += 1
            } else {
                streak = 1
            }
        } else {
            streak = 1
        }
        lastStudiedDate = Date()
        UserDefaults.standard.set(streak, forKey: streakKey)
        UserDefaults.standard.set(lastStudiedDate, forKey: lastStudiedKey)
    }

    func resetProgress() {
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: lastStudiedKey)
        UserDefaults.standard.removeObject(forKey: customCardsKey)
        allCards = SeedCards.all
        streak = 0
        lastStudiedDate = nil
    }
}

// MARK: - CardProgress
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
