import SwiftUI
import Charts

// MARK: - AppProgressView
struct AppProgressView: View {
    @EnvironmentObject var cardStore: CardStore

    private var totalCards: Int { cardStore.allCards.count }
    private var masteredCards: Int { cardStore.masteredCards.count }
    private var learningCards: Int { cardStore.learningCards.count }
    private var newCards: Int { cardStore.newCards.count }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: Overview Row
                    OverviewRow(
                        total: totalCards,
                        mastered: masteredCards,
                        learning: learningCards,
                        newCount: newCards
                    )
                    .padding(.horizontal)

                    // MARK: Progress Ring
                    ProgressRingCard(
                        mastered: masteredCards,
                        learning: learningCards,
                        newCount: newCards,
                        total: totalCards
                    )
                    .padding(.horizontal)

                    // MARK: Streak Card
                    StreakCard(streak: cardStore.streak, lastStudied: cardStore.lastStudiedDate)
                        .padding(.horizontal)

                    // MARK: Category Breakdown Chart
                    CategoryBreakdownChart(cardStore: cardStore)
                        .padding(.horizontal)

                    // MARK: Upcoming Reviews Calendar
                    UpcomingReviewsCard(cardStore: cardStore)
                        .padding(.horizontal)

                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// MARK: - Overview Row
struct OverviewRow: View {
    let total: Int
    let mastered: Int
    let learning: Int
    let newCount: Int

    var body: some View {
        HStack(spacing: 10) {
            OverviewTile(value: total,    label: "Total",    color: .indigo,  icon: "rectangle.stack.fill")
            OverviewTile(value: mastered, label: "Mastered", color: .green,   icon: "star.fill")
            OverviewTile(value: learning, label: "Learning", color: .orange,  icon: "arrow.clockwise")
            OverviewTile(value: newCount, label: "New",      color: .blue,    icon: "sparkle")
        }
    }
}

struct OverviewTile: View {
    let value: Int
    let label: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Progress Ring
struct ProgressRingCard: View {
    let mastered: Int
    let learning: Int
    let newCount: Int
    let total: Int

    private var masteredFraction: Double {
        total > 0 ? Double(mastered) / Double(total) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Progress")
                .font(.headline)
                .fontWeight(.semibold)

            HStack(spacing: 24) {
                // Ring
                ZStack {
                    Circle()
                        .stroke(Color(.systemFill), lineWidth: 16)
                    Circle()
                        .trim(from: 0, to: masteredFraction)
                        .stroke(
                            LinearGradient(colors: [.indigo, .green], startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: masteredFraction)

                    VStack(spacing: 2) {
                        Text("\(Int(masteredFraction * 100))%")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("mastered")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 110, height: 110)

                // Legend
                VStack(alignment: .leading, spacing: 10) {
                    LegendRow(color: .green,  label: "Mastered",  count: mastered)
                    LegendRow(color: .orange, label: "Learning",  count: learning)
                    LegendRow(color: .blue,   label: "New",       count: newCount)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct LegendRow: View {
    let color: Color
    let label: String
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Streak Card
struct StreakCard: View {
    let streak: Int
    let lastStudied: Date?

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Study Streak")
                    .font(.headline)
                    .fontWeight(.semibold)
                if let last = lastStudied {
                    Text("Last studied \(last, style: .relative) ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Start studying to build your streak!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            HStack(spacing: 6) {
                Text("🔥")
                    .font(.title)
                Text("\(streak)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Text(streak == 1 ? "day" : "days")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - Category Breakdown Chart
struct CategoryBreakdownChart: View {
    let cardStore: CardStore

    struct CategoryStat: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let mastered: Int
        let learning: Int
        let newCount: Int
    }

    private var stats: [CategoryStat] {
        Category.allCases.map { cat in
            let cards = cardStore.cards(for: cat)
            return CategoryStat(
                name: cat.rawValue,
                emoji: cat.emoji,
                mastered: cards.filter { $0.isMastered }.count,
                learning: cards.filter { !$0.isNew && !$0.isMastered }.count,
                newCount: cards.filter { $0.isNew }.count
            )
        }
        .filter { $0.mastered + $0.learning + $0.newCount > 0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Breakdown")
                .font(.headline)
                .fontWeight(.semibold)

            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(stats) { stat in
                        BarMark(
                            x: .value("Mastered", stat.mastered),
                            y: .value("Category", stat.emoji)
                        )
                        .foregroundStyle(.green)
                        .annotation(position: .overlay, alignment: .center) {
                            if stat.mastered > 0 {
                                Text("\(stat.mastered)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }

                        BarMark(
                            x: .value("Learning", stat.learning),
                            y: .value("Category", stat.emoji)
                        )
                        .foregroundStyle(.orange)

                        BarMark(
                            x: .value("New", stat.newCount),
                            y: .value("Category", stat.emoji)
                        )
                        .foregroundStyle(.blue)
                    }
                }
                .chartForegroundStyleScale([
                    "Mastered": Color.green,
                    "Learning": Color.orange,
                    "New": Color.blue
                ])
                .frame(height: 280)
            } else {
                // Fallback for iOS < 16 (shouldn't happen with deployment target 16+)
                ForEach(stats) { stat in
                    CategoryBarFallback(stat: stat)
                }
            }

            // Legend
            HStack(spacing: 16) {
                ChartLegendItem(color: .green,  label: "Mastered")
                ChartLegendItem(color: .orange, label: "Learning")
                ChartLegendItem(color: .blue,   label: "New")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct ChartLegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct CategoryBarFallback: View {
    let stat: CategoryBreakdownChart.CategoryStat

    private var total: Int { stat.mastered + stat.learning + stat.newCount }

    var body: some View {
        HStack(spacing: 8) {
            Text(stat.emoji)
                .frame(width: 24)
            GeometryReader { geo in
                HStack(spacing: 2) {
                    if stat.mastered > 0 {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geo.size.width * CGFloat(stat.mastered) / CGFloat(total))
                    }
                    if stat.learning > 0 {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: geo.size.width * CGFloat(stat.learning) / CGFloat(total))
                    }
                    if stat.newCount > 0 {
                        Rectangle()
                            .fill(Color.blue)
                    }
                }
                .cornerRadius(4)
            }
            .frame(height: 18)
            Text("\(total)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 28, alignment: .trailing)
        }
    }
}

// MARK: - Upcoming Reviews Calendar
struct UpcomingReviewsCard: View {
    let cardStore: CardStore

    private var weekDays: [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueCounts = cardStore.cardsDue(inNext: 7)
        return (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: offset, to: today) ?? today
            return (day, dueCounts[day] ?? 0)
        }
    }

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "E"
        return f
    }()

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Cards Due This Week")
                .font(.headline)
                .fontWeight(.semibold)

            HStack(spacing: 6) {
                ForEach(weekDays, id: \.date) { item in
                    VStack(spacing: 6) {
                        Text(dayFormatter.string(from: item.date))
                            .font(.caption2)
                            .foregroundColor(.secondary)

                        ZStack {
                            Circle()
                                .fill(
                                    Calendar.current.isDateInToday(item.date)
                                        ? Color.indigo
                                        : (item.count > 0 ? Color.indigo.opacity(0.15) : Color(.systemFill))
                                )
                                .frame(width: 36, height: 36)

                            Text(dateFormatter.string(from: item.date))
                                .font(.caption)
                                .fontWeight(Calendar.current.isDateInToday(item.date) ? .bold : .regular)
                                .foregroundColor(
                                    Calendar.current.isDateInToday(item.date) ? .white : .primary
                                )
                        }

                        if item.count > 0 {
                            Text("\(item.count)")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.indigo)
                        } else {
                            Text(" ")
                                .font(.caption2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct AppProgressView_Previews: PreviewProvider {
    static var previews: some View {
        AppProgressView()
            .environmentObject(CardStore())
    }
}
