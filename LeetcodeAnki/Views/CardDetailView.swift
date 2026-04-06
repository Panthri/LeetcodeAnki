import SwiftUI

// MARK: - CardDetailView
struct CardDetailView: View {
    let card: Card

    @State private var isHintExpanded: Bool = false
    @State private var isSolutionExpanded: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: Header Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(card.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            HStack(spacing: 8) {
                                DifficultyBadge(difficulty: card.difficulty)
                                CategoryBadge(category: card.category)
                            }
                        }
                        Spacer()
                        StatusBadge(card: card)
                    }

                    Divider()

                    // Next review info
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.indigo)
                        Text("Next review: \(card.nextReviewFormatted)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if card.repetitions > 0 {
                        HStack(spacing: 16) {
                            SmallStatView(label: "Repetitions", value: "\(card.repetitions)")
                            SmallStatView(label: "Interval", value: "\(card.interval)d")
                            SmallStatView(label: "Ease", value: String(format: "%.2f", card.easeFactor))
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)

                // MARK: Problem Statement
                SectionCard(title: "Problem", icon: "doc.text.fill", iconColor: .blue) {
                    Text(card.problem)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                // MARK: Hint (collapsible)
                CollapsibleSectionCard(
                    title: "Hint",
                    icon: "lightbulb.fill",
                    iconColor: .yellow,
                    isExpanded: $isHintExpanded
                ) {
                    Text(card.hint)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                // MARK: Solution Approach (collapsible)
                CollapsibleSectionCard(
                    title: "Solution Approach",
                    icon: "checkmark.seal.fill",
                    iconColor: .green,
                    isExpanded: $isSolutionExpanded
                ) {
                    Text(card.solution)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                // MARK: Practice Button
                if let url = URL(string: card.leetcodeURL) {
                    Link(destination: url) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.up.right.square.fill")
                                .font(.headline)
                            Text("Practice on LeetCode")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .opacity(0.7)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.5, blue: 0.0), .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                    }
                }

                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let card: Card

    private var color: Color {
        if card.isNew { return .blue }
        if card.isMastered { return .green }
        return .orange
    }

    private var icon: String {
        if card.isNew { return "sparkle" }
        if card.isMastered { return "star.fill" }
        return "arrow.clockwise"
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(card.statusLabel)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .cornerRadius(8)
    }
}

// MARK: - Small Stat View
struct SmallStatView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - Collapsible Section Card
struct CollapsibleSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @Binding var isExpanded: Bool
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }

            if isExpanded {
                Divider()
                    .padding(.horizontal)
                content
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardDetailView(card: SeedCards.all[0])
        }
    }
}
