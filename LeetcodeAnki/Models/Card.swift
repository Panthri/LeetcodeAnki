import Foundation

// MARK: - Category
enum Category: String, CaseIterable, Codable {
    case arrays = "Arrays"
    case linkedList = "Linked List"
    case treesGraphs = "Trees & Graphs"
    case stacksStrings = "Stacks & Strings"
    case sorting = "Sorting & Searching"
    case dpMath = "DP & Math"
    case dataStructures = "Data Structures"
    case jsFrontend = "JS / Frontend"
    case systemDesign = "System Design"
    case behavioral = "Behavioral"

    var emoji: String {
        switch self {
        case .arrays:         return "🔢"
        case .linkedList:     return "🔗"
        case .treesGraphs:    return "🌲"
        case .stacksStrings:  return "📚"
        case .sorting:        return "🔍"
        case .dpMath:         return "🧮"
        case .dataStructures: return "🏗️"
        case .jsFrontend:     return "🌐"
        case .systemDesign:   return "⚙️"
        case .behavioral:     return "🤝"
        }
    }

    var color: String {
        switch self {
        case .arrays:         return "blue"
        case .linkedList:     return "purple"
        case .treesGraphs:    return "green"
        case .stacksStrings:  return "orange"
        case .sorting:        return "teal"
        case .dpMath:         return "red"
        case .dataStructures: return "indigo"
        case .jsFrontend:     return "yellow"
        case .systemDesign:   return "gray"
        case .behavioral:     return "pink"
        }
    }
}

// MARK: - Difficulty
enum Difficulty: String, CaseIterable, Codable {
    case easy   = "Easy"
    case medium = "Medium"
    case hard   = "Hard"

    var color: String {
        switch self {
        case .easy:   return "green"
        case .medium: return "orange"
        case .hard:   return "red"
        }
    }
}

// MARK: - Rating
enum Rating: Int, Codable, CaseIterable {
    case again = 0
    case hard  = 1
    case good  = 3
    case easy  = 5

    var label: String {
        switch self {
        case .again: return "Again"
        case .hard:  return "Hard"
        case .good:  return "Good"
        case .easy:  return "Easy"
        }
    }

    var colorName: String {
        switch self {
        case .again: return "red"
        case .hard:  return "orange"
        case .good:  return "green"
        case .easy:  return "blue"
        }
    }

    var systemImage: String {
        switch self {
        case .again: return "arrow.counterclockwise"
        case .hard:  return "exclamationmark.circle"
        case .good:  return "checkmark.circle"
        case .easy:  return "star.circle"
        }
    }
}

// MARK: - Card
struct Card: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: Category
    let difficulty: Difficulty
    let problem: String
    let hint: String
    let solution: String
    let leetcodeURL: String

    // SM-2 spaced repetition fields
    var interval: Int       // days until next review
    var repetitions: Int
    var easeFactor: Double  // starts at 2.5
    var nextReviewDate: Date
    var lastRating: Rating?

    init(
        id: UUID = UUID(),
        title: String,
        category: Category,
        difficulty: Difficulty,
        problem: String,
        hint: String,
        solution: String,
        leetcodeURL: String,
        interval: Int = 0,
        repetitions: Int = 0,
        easeFactor: Double = 2.5,
        nextReviewDate: Date = Date(),
        lastRating: Rating? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.difficulty = difficulty
        self.problem = problem
        self.hint = hint
        self.solution = solution
        self.leetcodeURL = leetcodeURL
        self.interval = interval
        self.repetitions = repetitions
        self.easeFactor = easeFactor
        self.nextReviewDate = nextReviewDate
        self.lastRating = lastRating
    }

    var isDue: Bool {
        nextReviewDate <= Date()
    }

    var isMastered: Bool {
        repetitions >= 5 && easeFactor >= 2.0
    }

    var isNew: Bool {
        repetitions == 0
    }

    var statusLabel: String {
        if isNew { return "New" }
        if isMastered { return "Mastered" }
        return "Learning"
    }

    var nextReviewFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: nextReviewDate, relativeTo: Date())
    }
}
