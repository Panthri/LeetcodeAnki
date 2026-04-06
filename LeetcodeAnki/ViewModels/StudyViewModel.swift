import Foundation
import Combine
import SwiftUI

// MARK: - StudyViewModel
final class StudyViewModel: ObservableObject {

    // MARK: - Published State
    @Published var currentCard: Card?
    @Published var isShowingAnswer: Bool = false
    @Published var sessionCards: [Card] = []
    @Published var completedCount: Int = 0
    @Published var isSessionComplete: Bool = false
    @Published var flipDegrees: Double = 0.0

    // MARK: - Private
    private var cardStore: CardStore?
    private var fullSession: [Card] = []

    // MARK: - Computed
    var sessionProgress: Double {
        guard !fullSession.isEmpty else { return 0 }
        return Double(completedCount) / Double(fullSession.count)
    }

    var remainingCount: Int {
        fullSession.count - completedCount
    }

    var totalCount: Int {
        fullSession.count
    }

    var estimatedIntervals: [Rating: String] {
        guard let card = currentCard else { return [:] }
        return SM2Algorithm.estimatedIntervals(for: card)
    }

    // MARK: - Session Management

    /// Load a new study session with the given due cards.
    func loadSession(cards: [Card], store: CardStore? = nil) {
        self.cardStore = store
        fullSession = cards.shuffled()
        sessionCards = fullSession
        completedCount = 0
        isSessionComplete = false
        isShowingAnswer = false
        flipDegrees = 0
        currentCard = fullSession.first
    }

    /// Inject a CardStore after initialisation (called from the view).
    func attach(store: CardStore) {
        self.cardStore = store
    }

    // MARK: - Actions

    /// Flip the card to reveal the answer.
    func flip() {
        guard !isShowingAnswer else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            flipDegrees = 180
            isShowingAnswer = true
        }
    }

    /// Reset to front face.
    func resetFlip() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            flipDegrees = 0
            isShowingAnswer = false
        }
    }

    /// Rate the current card and advance to the next.
    func rate(_ rating: Rating) {
        guard let card = currentCard else { return }
        cardStore?.rate(card: card, rating: rating)
        completedCount += 1
        nextCard()
    }

    /// Advance to next card in session.
    func nextCard() {
        if completedCount >= fullSession.count {
            withAnimation {
                isSessionComplete = true
                currentCard = nil
            }
            return
        }
        withAnimation(.easeInOut(duration: 0.25)) {
            flipDegrees = 0
            isShowingAnswer = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            let idx = self.completedCount
            if idx < self.fullSession.count {
                self.currentCard = self.fullSession[idx]
            }
        }
    }

    /// Skip current card without rating (push to end of session — not counted as done).
    func skip() {
        guard let card = currentCard else { return }
        // Move this card to the back of the queue
        if completedCount < fullSession.count - 1 {
            fullSession.remove(at: completedCount)
            fullSession.append(card)
            resetFlip()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.currentCard = self.fullSession[self.completedCount]
            }
        }
    }

    /// Restart the session with the same cards.
    func restart(store: CardStore) {
        loadSession(cards: store.dueCards, store: store)
    }
}
