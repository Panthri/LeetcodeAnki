import SwiftUI

// MARK: - StudyView
struct StudyView: View {
    @EnvironmentObject var cardStore: CardStore
    @ObservedObject var viewModel: StudyViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isSessionComplete {
                    SessionCompleteView(viewModel: viewModel)
                } else if cardStore.dueCards.isEmpty && viewModel.currentCard == nil {
                    NoDueCardsView()
                } else if let card = viewModel.currentCard {
                    StudyContentView(card: card, viewModel: viewModel)
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.currentCard != nil && !viewModel.isSessionComplete {
                        Button("Skip") {
                            viewModel.skip()
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .onAppear {
            viewModel.attach(store: cardStore)
            if viewModel.currentCard == nil && !viewModel.isSessionComplete {
                viewModel.loadSession(cards: cardStore.dueCards, store: cardStore)
            }
        }
    }
}

// MARK: - Study Content (card + buttons)
struct StudyContentView: View {
    let card: Card
    @ObservedObject var viewModel: StudyViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            SessionProgressBar(
                completed: viewModel.completedCount,
                total: viewModel.totalCount
            )
            .padding(.horizontal)
            .padding(.top, 8)

            Text("\(viewModel.completedCount + 1) / \(viewModel.totalCount)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)

            Spacer(minLength: 12)

            // Flashcard
            FlashCardView(card: card, isShowingAnswer: viewModel.isShowingAnswer)
                .padding(.horizontal)
                .onTapGesture {
                    if !viewModel.isShowingAnswer {
                        viewModel.flip()
                    }
                }

            Spacer(minLength: 16)

            // Action buttons
            if viewModel.isShowingAnswer {
                RatingButtonsView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                ShowAnswerButton {
                    viewModel.flip()
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                .transition(.opacity)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .gesture(
            DragGesture(minimumDistance: 60)
                .onEnded { value in
                    if value.translation.width < -60 && !viewModel.isShowingAnswer {
                        viewModel.flip()
                    }
                }
        )
    }
}

// MARK: - Flashcard
struct FlashCardView: View {
    let card: Card
    let isShowingAnswer: Bool

    @State private var flipDegrees: Double = 0

    var body: some View {
        ZStack {
            CardFrontView(card: card)
                .opacity(isShowingAnswer ? 0 : 1)
                .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0, y: 1, z: 0))

            CardBackView(card: card)
                .opacity(isShowingAnswer ? 1 : 0)
                .rotation3DEffect(.degrees(flipDegrees - 180), axis: (x: 0, y: 1, z: 0))
        }
        .onChange(of: isShowingAnswer) { showing in
            withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
                flipDegrees = showing ? 180 : 0
            }
        }
    }
}

// MARK: - Card Front
struct CardFrontView: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                DifficultyBadge(difficulty: card.difficulty)
                Spacer()
                CategoryBadge(category: card.category)
            }

            Divider()

            // Title
            Text(card.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Divider()

            // Problem statement
            ScrollView {
                Text(card.problem)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 8)

            // Tap to reveal hint
            HStack {
                Spacer()
                Label("Tap card or swipe left to reveal", systemImage: "hand.tap")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
        .frame(maxHeight: 480)
    }
}

// MARK: - Card Back
struct CardBackView: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                DifficultyBadge(difficulty: card.difficulty)
                Spacer()
                CategoryBadge(category: card.category)
            }

            Text(card.title)
                .font(.title3)
                .fontWeight(.bold)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Hint", systemImage: "lightbulb.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                        Text(card.hint)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .background(Color.yellow.opacity(0.08))
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Solution Approach", systemImage: "checkmark.seal.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        Text(card.solution)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.08))
                    .cornerRadius(10)
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
        .frame(maxHeight: 480)
    }
}

// MARK: - Show Answer Button
struct ShowAnswerButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "eye.fill")
                Text("Show Answer")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.indigo)
            .foregroundColor(.white)
            .cornerRadius(14)
            .shadow(color: .indigo.opacity(0.3), radius: 6, x: 0, y: 3)
        }
    }
}

// MARK: - Rating Buttons
struct RatingButtonsView: View {
    @ObservedObject var viewModel: StudyViewModel

    var body: some View {
        VStack(spacing: 10) {
            Text("How well did you know this?")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                ForEach(Rating.allCases, id: \.self) { rating in
                    RatingButton(
                        rating: rating,
                        interval: viewModel.estimatedIntervals[rating] ?? ""
                    ) {
                        viewModel.rate(rating)
                    }
                }
            }
        }
    }
}

struct RatingButton: View {
    let rating: Rating
    let interval: String
    let action: () -> Void

    private var color: Color {
        switch rating {
        case .again: return .red
        case .hard:  return .orange
        case .good:  return .green
        case .easy:  return .blue
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: rating.systemImage)
                    .font(.title3)
                Text(rating.label)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(interval)
                    .font(.caption2)
                    .opacity(0.75)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Session Progress Bar
struct SessionProgressBar: View {
    let completed: Int
    let total: Int

    var progress: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemFill))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [.indigo, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * progress, height: 8)
                    .animation(.easeInOut(duration: 0.4), value: progress)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Session Complete
struct SessionCompleteView: View {
    @ObservedObject var viewModel: StudyViewModel
    @EnvironmentObject var cardStore: CardStore

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            VStack(spacing: 8) {
                Text("Session Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("You reviewed \(viewModel.totalCount) cards.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 10) {
                HStack {
                    Text("🔥 Current streak:")
                    Spacer()
                    Text("\(cardStore.streak) days")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                HStack {
                    Text("Cards remaining today:")
                    Spacer()
                    Text("\(cardStore.dueCards.count)")
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(14)
            .padding(.horizontal)

            if cardStore.dueCards.count > 0 {
                Button("Continue Reviewing") {
                    viewModel.restart(store: cardStore)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            } else {
                Text("All caught up for today! Come back tomorrow.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - No Due Cards
struct NoDueCardsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)
            Text("All caught up!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("No cards are due right now.\nCheck back tomorrow to keep your streak.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - Shared Badge Views
struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var color: Color {
        switch difficulty {
        case .easy:   return .green
        case .medium: return .orange
        case .hard:   return .red
        }
    }

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

struct CategoryBadge: View {
    let category: Category

    var body: some View {
        HStack(spacing: 4) {
            Text(category.emoji)
                .font(.caption)
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.tertiarySystemFill))
        .clipShape(Capsule())
    }
}

struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        let store = CardStore()
        let vm = StudyViewModel()
        vm.loadSession(cards: store.dueCards, store: store)
        return StudyView(viewModel: vm)
            .environmentObject(store)
    }
}
