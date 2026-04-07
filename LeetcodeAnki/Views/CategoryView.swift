import SwiftUI

// MARK: - CategoryView
struct CategoryView: View {
    @EnvironmentObject var cardStore: CardStore
    let category: Category

    @State private var selectedDifficulty: Difficulty? = nil
    @State private var sortOrder: SortOrder = .nextReview
    @State private var showAddCard = false
    @State private var editingCard: Card? = nil

    enum SortOrder: String, CaseIterable {
        case nextReview = "Next Review"
        case difficulty = "Difficulty"
        case title = "Title"
        case status = "Status"
    }

    private var filteredCards: [Card] {
        var cards = cardStore.cards(for: category)

        if let diff = selectedDifficulty {
            cards = cards.filter { $0.difficulty == diff }
        }

        switch sortOrder {
        case .nextReview:
            cards.sort { $0.nextReviewDate < $1.nextReviewDate }
        case .difficulty:
            let order: [Difficulty] = [.easy, .medium, .hard]
            cards.sort { order.firstIndex(of: $0.difficulty)! < order.firstIndex(of: $1.difficulty)! }
        case .title:
            cards.sort { $0.title < $1.title }
        case .status:
            cards.sort { lhs, rhs in
                let lScore = lhs.isNew ? 0 : (lhs.isMastered ? 2 : 1)
                let rScore = rhs.isNew ? 0 : (rhs.isMastered ? 2 : 1)
                return lScore < rScore
            }
        }

        return cards
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: Filter + Sort Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // Difficulty filter chips
                    FilterChip(label: "All", isSelected: selectedDifficulty == nil) {
                        selectedDifficulty = nil
                    }
                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        FilterChip(label: diff.rawValue, isSelected: selectedDifficulty == diff) {
                            selectedDifficulty = (selectedDifficulty == diff) ? nil : diff
                        }
                    }

                    Divider()
                        .frame(height: 20)
                        .padding(.horizontal, 4)

                    // Sort picker
                    Menu {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Button(action: { sortOrder = order }) {
                                Label(order.rawValue, systemImage: sortOrder == order ? "checkmark" : "")
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption)
                            Text(sortOrder.rawValue)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }

            Divider()

            // MARK: Card List
            if filteredCards.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No cards match the filter.")
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(filteredCards) { card in
                        NavigationLink(destination: CardDetailView(card: card)) {
                            CategoryCardRow(card: card)
                        }
                        .listRowBackground(Color(.secondarySystemGroupedBackground))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if card.isCustom {
                                Button(role: .destructive) {
                                    cardStore.deleteCard(card)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    editingCard = card
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("\(category.emoji) \(category.rawValue)")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddCard = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddCard) {
            AddCardView(editingCard: nil)
                .environmentObject(cardStore)
        }
        .sheet(item: $editingCard) { card in
            AddCardView(editingCard: card)
                .environmentObject(cardStore)
        }
    }
}

// MARK: - Card Row in Category List
struct CategoryCardRow: View {
    let card: Card

    var body: some View {
        HStack(spacing: 12) {
            // Status indicator dot
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    DifficultyBadge(difficulty: card.difficulty)
                    Text(card.nextReviewFormatted)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if card.isDue {
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .foregroundColor(.indigo)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        if card.isNew { return .blue }
        if card.isMastered { return .green }
        return .orange
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.indigo : Color(.tertiarySystemFill))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryView(category: .arrays)
                .environmentObject(CardStore())
        }
    }
}
