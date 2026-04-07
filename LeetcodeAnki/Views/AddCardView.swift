import SwiftUI

struct AddCardView: View {
    @EnvironmentObject var store: CardStore
    @Environment(\.dismiss) private var dismiss

    // If card is passed in, we're editing an existing custom card
    var editingCard: Card? = nil

    @State private var title: String = ""
    @State private var problem: String = ""
    @State private var hint: String = ""
    @State private var solution: String = ""
    @State private var leetcodeURL: String = ""
    @State private var category: Category = .arrays
    @State private var difficulty: Difficulty = .medium
    @State private var showValidationError = false

    private var isEditing: Bool { editingCard != nil }

    var body: some View {
        NavigationStack {
            Form {
                // Title
                Section("Card Title") {
                    TextField("e.g. Two Sum", text: $title)
                }

                // Category & Difficulty
                Section("Classification") {
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: categoryIcon(cat))
                                .tag(cat)
                        }
                    }

                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { diff in
                            Text(diff.rawValue).tag(diff)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Problem
                Section("Problem Statement") {
                    TextEditor(text: $problem)
                        .frame(minHeight: 80)
                        .overlay(
                            Group {
                                if problem.isEmpty {
                                    Text("Describe the problem...")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                // Hint
                Section("Hint / Pattern") {
                    TextEditor(text: $hint)
                        .frame(minHeight: 60)
                        .overlay(
                            Group {
                                if hint.isEmpty {
                                    Text("e.g. Use a hash map for O(n) lookup")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                // Solution
                Section("Solution Approach") {
                    TextEditor(text: $solution)
                        .frame(minHeight: 80)
                        .overlay(
                            Group {
                                if solution.isEmpty {
                                    Text("Explain the approach, not the full code...")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                // LeetCode URL (optional)
                Section("LeetCode URL (optional)") {
                    TextField("https://leetcode.com/problems/...", text: $leetcodeURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }

                if showValidationError {
                    Section {
                        Label("Title, Problem, and Solution are required.", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Card" : "New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        saveCard()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear { prefillIfEditing() }
        }
    }

    // MARK: - Helpers

    private func prefillIfEditing() {
        guard let card = editingCard else { return }
        title      = card.title
        problem    = card.problem
        hint       = card.hint
        solution   = card.solution
        leetcodeURL = card.leetcodeURL
        category   = card.category
        difficulty = card.difficulty
    }

    private func saveCard() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !problem.trimmingCharacters(in: .whitespaces).isEmpty,
              !solution.trimmingCharacters(in: .whitespaces).isEmpty else {
            showValidationError = true
            return
        }

        if isEditing, let existing = editingCard {
            var updated = existing
            updated.title      = title
            updated.problem    = problem
            updated.hint       = hint
            updated.solution   = solution
            updated.leetcodeURL = leetcodeURL
            updated.category   = category
            updated.difficulty = difficulty
            store.updateCard(updated)
        } else {
            let card = Card(
                title:      title.trimmingCharacters(in: .whitespaces),
                category:   category,
                difficulty: difficulty,
                problem:    problem.trimmingCharacters(in: .whitespaces),
                hint:       hint.trimmingCharacters(in: .whitespaces),
                solution:   solution.trimmingCharacters(in: .whitespaces),
                leetcodeURL: leetcodeURL.trimmingCharacters(in: .whitespaces),
                isCustom:   true
            )
            store.addCard(card)
        }
        dismiss()
    }

    private func categoryIcon(_ cat: Category) -> String {
        switch cat {
        case .arrays:         return "square.grid.2x2"
        case .linkedList:     return "link"
        case .treesGraphs:    return "tree"
        case .stacksStrings:  return "books.vertical"
        case .sorting:        return "arrow.up.arrow.down"
        case .dpMath:         return "function"
        case .dataStructures: return "archivebox"
        case .jsFrontend:     return "globe"
        case .systemDesign:   return "gearshape.2"
        case .behavioral:     return "person.2"
        }
    }
}
