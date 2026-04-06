import Foundation

// MARK: - SM-2 Spaced Repetition Algorithm
// Based on the SuperMemo SM-2 algorithm by Piotr Wozniak
// Reference: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2

struct SM2Algorithm {

    /// Calculate the next review schedule for a card based on the user's rating.
    ///
    /// - Parameters:
    ///   - card: The card being reviewed.
    ///   - rating: The user's self-assessment rating (Again=0, Hard=1, Good=3, Easy=5).
    /// - Returns: A new Card with updated SM-2 fields.
    static func calculateNextReview(card: Card, rating: Rating) -> Card {
        var updated = card
        let q = rating.rawValue

        if q < 3 {
            // Failed recall: reset to beginning
            updated.repetitions = 0
            updated.interval = 1
            // Ease factor decreases on failure
            updated.easeFactor = max(1.3, card.easeFactor + (0.1 - Double(5 - q) * (0.08 + Double(5 - q) * 0.02)))
        } else {
            // Successful recall: advance the schedule
            // Update ease factor: EF = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
            let newEF = card.easeFactor + (0.1 - Double(5 - q) * (0.08 + Double(5 - q) * 0.02))
            updated.easeFactor = max(1.3, newEF)

            // Calculate new interval
            switch card.repetitions {
            case 0:
                updated.interval = 1
            case 1:
                updated.interval = 6
            default:
                let newInterval = Double(card.interval) * updated.easeFactor
                updated.interval = max(card.interval + 1, Int(newInterval.rounded()))
            }

            updated.repetitions = card.repetitions + 1
        }

        updated.lastRating = rating
        updated.nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: updated.interval,
            to: Date()
        ) ?? Date().addingTimeInterval(Double(updated.interval) * 86400)

        return updated
    }

    /// Returns estimated next review intervals for display purposes.
    static func estimatedIntervals(for card: Card) -> [Rating: String] {
        var result: [Rating: String] = [:]
        for rating in Rating.allCases {
            let projected = calculateNextReview(card: card, rating: rating)
            result[rating] = formatInterval(projected.interval)
        }
        return result
    }

    private static func formatInterval(_ days: Int) -> String {
        switch days {
        case 0:      return "Now"
        case 1:      return "1 day"
        case 2...6:  return "\(days) days"
        case 7...13: return "1 week"
        case 14...29:
            let weeks = days / 7
            return "\(weeks) weeks"
        case 30...:
            let months = days / 30
            return months == 1 ? "1 month" : "\(months) months"
        default:     return "\(days) days"
        }
    }
}
