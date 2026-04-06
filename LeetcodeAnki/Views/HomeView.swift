import SwiftUI

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var cardStore: CardStore
    var onStartReview: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: Streak + Due Banner
                    HStack(spacing: 16) {
                        StreakBadgeView(streak: cardStore.streak)
                        DueBannerView(dueCount: cardStore.dueCards.count)
                    }
                    .padding(.horizontal)

                    // MARK: Start Review Button
                    Button(action: onStartReview) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Review")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("\(cardStore.dueCards.count) cards ready")
                                    .font(.subheadline)
                                    .opacity(0.85)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .opacity(0.7)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                colors: [.indigo, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .indigo.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .disabled(cardStore.dueCards.isEmpty)
                    .padding(.horizontal)

                    // MARK: Quick Stats Row
                    QuickStatsRowView(
                        newCount: cardStore.newCards.count,
                        learningCount: cardStore.learningCards.count,
                        masteredCount: cardStore.masteredCards.count
                    )
                    .padding(.horizontal)

                    // MARK: Category Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(Category.allCases, id: \.self) { category in
                                NavigationLink(destination: CategoryView(category: category)) {
                                    CategoryCardView(
                                        category: category,
                                        totalCount: cardStore.cards(for: category).count,
                                        dueCount: cardStore.dueCount(for: category)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("LeetcodeAnki")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Streak Badge
struct StreakBadgeView: View {
    let streak: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("🔥")
                .font(.largeTitle)
            Text("\(streak)")
                .font(.title2)
                .fontWeight(.bold)
            Text("day streak")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}

// MARK: - Due Banner
struct DueBannerView: View {
    let dueCount: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("📅")
                .font(.largeTitle)
            Text("\(dueCount)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(dueCount > 0 ? .indigo : .secondary)
            Text("due today")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}

// MARK: - Quick Stats Row
struct QuickStatsRowView: View {
    let newCount: Int
    let learningCount: Int
    let masteredCount: Int

    var body: some View {
        HStack(spacing: 10) {
            StatPillView(label: "New", count: newCount, color: .blue)
            StatPillView(label: "Learning", count: learningCount, color: .orange)
            StatPillView(label: "Mastered", count: masteredCount, color: .green)
        }
    }
}

struct StatPillView: View {
    let label: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Category Card
struct CategoryCardView: View {
    let category: Category
    let totalCount: Int
    let dueCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.emoji)
                    .font(.title2)
                Spacer()
                if dueCount > 0 {
                    Text("\(dueCount)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.indigo)
                        .clipShape(Capsule())
                }
            }

            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Text("\(totalCount) cards")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}

// MARK: - Settings View (stub)
struct SettingsView: View {
    @EnvironmentObject var cardStore: CardStore
    @State private var showingResetAlert = false

    var body: some View {
        Form {
            Section(header: Text("Progress")) {
                Button("Reset All Progress", role: .destructive) {
                    showingResetAlert = true
                }
            }
            Section(header: Text("About")) {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Algorithm", value: "SM-2 Spaced Repetition")
                LabeledContent("Total Cards", value: "\(cardStore.allCards.count)")
            }
        }
        .navigationTitle("Settings")
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                cardStore.resetProgress()
            }
        } message: {
            Text("This will reset all card progress and streaks. This cannot be undone.")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(onStartReview: {})
            .environmentObject(CardStore())
    }
}
