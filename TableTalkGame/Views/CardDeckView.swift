import SwiftUI

struct CardDeckView: View {
    @State private var viewModel = CardDeckViewModel()
    @AppStorage("selectedTheme") private var themeRawValue: String = AppTheme.halloween.rawValue
    @State private var showThemePicker = false
    @State private var showPackPicker = false
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    // Shuffle animation
    @State private var isShuffling = false
    @State private var shuffleOffsets: [CGSize] = []
    @State private var shuffleRotations: [Double] = []

    private var theme: AppTheme {
        AppTheme(rawValue: themeRawValue) ?? .halloween
    }

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: theme.backgroundGradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: themeRawValue)

            // Canvas animated background
            AnimatedBackgroundView(theme: theme)
                .animation(.easeInOut(duration: 0.5), value: themeRawValue)

            VStack(spacing: 0) {
                // Header
                HStack {
                    // Pack picker button (left)
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showPackPicker.toggle()
                            showThemePicker = false
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.selectedPack.iconName)
                                .font(.body)
                            Text(viewModel.selectedPack.name)
                                .font(.system(.subheadline, design: theme.fontDesign, weight: .medium))
                        }
                        .foregroundStyle(theme.accentColor)
                    }

                    Spacer()

                    // Theme picker button (right)
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showThemePicker.toggle()
                            showPackPicker = false
                        }
                    } label: {
                        Image(systemName: "paintpalette.fill")
                            .font(.title3)
                            .foregroundStyle(theme.accentColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()

                // Card stack or finished state
                if viewModel.isFinished {
                    finishedView
                        .offset(y: -12)
                } else {
                    cardStackView
                        .offset(y: -12)
                }

                Spacer()

                // Bottom bar
                HStack {
                    // Shuffle button
                    Button {
                        performShuffle()
                    } label: {
                        Image(systemName: "shuffle")
                            .font(.title3)
                            .foregroundStyle(theme.accentColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(theme.buttonColor)
                                    .shadow(color: theme.cardShadowColor, radius: 4, y: 2)
                            )
                    }

                    Spacer()

                    // Progress
                    if !viewModel.isFinished {
                        Text("\(viewModel.totalCount - viewModel.remainingCount + 1) / \(viewModel.totalCount)")
                            .font(.system(.subheadline, design: theme.fontDesign, weight: .medium))
                            .foregroundStyle(theme.textColor.opacity(0.6))
                    }

                    Spacer()

                    // Random card button
                    Button {
                        viewModel.showRandom()
                    } label: {
                        Image(systemName: "dice.fill")
                            .font(.title3)
                            .foregroundStyle(theme.accentColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(theme.buttonColor)
                                    .shadow(color: theme.cardShadowColor, radius: 4, y: 2)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }

            // Pack picker overlay
            if showPackPicker {
                PackPickerView(
                    selectedPack: Binding(
                        get: { viewModel.selectedPack },
                        set: { _ in }
                    ),
                    isPresented: $showPackPicker,
                    theme: theme
                ) { pack in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        viewModel.selectPack(pack)
                    }
                }
                .transition(.opacity)
            }

            // Theme picker overlay
            if showThemePicker {
                ThemePickerView(
                    selectedTheme: Binding(
                        get: { theme },
                        set: { themeRawValue = $0.rawValue }
                    ),
                    isPresented: $showThemePicker
                )
                .transition(.opacity)
            }

            // Random card overlay
            if viewModel.showRandomCard, let card = viewModel.randomCard {
                randomCardOverlay(card: card)
            }
        }
        .onShake {
            viewModel.showRandom()
        }
    }

    // MARK: - Card Stack

    private var cardStackView: some View {
        ZStack {
            let cards = viewModel.visibleCards
            ForEach(Array(cards.enumerated().reversed()), id: \.element.id) { index, card in
                let isTop = index == 0
                let stackOffset = CGFloat(index) * 8
                let stackScale = 1.0 - CGFloat(index) * 0.05

                CardView(card: card, theme: theme)
                    .frame(height: 400)
                    .padding(.horizontal, 24)
                    .scaleEffect(stackScale)
                    .offset(y: stackOffset)
                    .zIndex(Double(cards.count - index))
                    .offset(x: isTop ? dragOffset.width : 0, y: isTop ? dragOffset.height : 0)
                    .rotationEffect(isTop ? swipeRotation : .zero)
                    .scaleEffect(isTop ? swipeScale : 1.0)
                    .opacity(index == 0 ? 1.0 : (index == 1 ? 0.6 : 0))
                    .gesture(isTop ? dragGesture : nil)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 25), value: dragOffset)
            }
        }
    }

    // MARK: - Swipe Helpers

    /// true = horizontal swipe, false = vertical swipe
    private var isHorizontalSwipe: Bool {
        abs(dragOffset.width) >= abs(dragOffset.height)
    }

    private var swipeRotation: Angle {
        if isHorizontalSwipe {
            return .degrees(Double(dragOffset.width) / 25)
        }
        return .zero
    }

    private var swipeScale: CGFloat {
        if !isHorizontalSwipe {
            let progress = min(abs(dragOffset.height) / 300, 1.0)
            return 1.0 - progress * 0.15
        }
        return 1.0
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged { value in
                dragOffset = value.translation
                isDragging = true
            }
            .onEnded { value in
                let hDist = abs(value.translation.width)
                let vDist = abs(value.translation.height)
                let hVelocity = abs(value.predictedEndTranslation.width - value.translation.width)
                let vVelocity = abs(value.predictedEndTranslation.height - value.translation.height)
                let threshold: CGFloat = 50

                if hDist >= vDist {
                    // Horizontal swipe — fly out left/right with rotation
                    if hDist > threshold || hVelocity > 200 {
                        let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)) {
                            dragOffset = CGSize(width: direction * 600, height: value.translation.height * 0.5)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            dragOffset = .zero
                            isDragging = false
                            viewModel.swipeCard()
                        }
                    } else {
                        snapBack()
                    }
                } else {
                    // Vertical swipe — shrink & fade out up/down
                    if vDist > threshold || vVelocity > 200 {
                        let direction: CGFloat = value.translation.height > 0 ? 1 : -1
                        withAnimation(.easeIn(duration: 0.2)) {
                            dragOffset = CGSize(width: 0, height: direction * 800)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            dragOffset = .zero
                            isDragging = false
                            viewModel.swipeCard()
                        }
                    } else {
                        snapBack()
                    }
                }
            }
    }

    private func snapBack() {
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 22)) {
            dragOffset = .zero
            isDragging = false
        }
    }

    // MARK: - Finished View

    private var finishedView: some View {
        VStack(spacing: 20) {
            Image(systemName: theme.themeIconName)
                .font(.system(size: 50))
                .foregroundStyle(theme.accentColor)

            Text("모든 카드를 확인했어요!")
                .font(.system(.title2, design: theme.fontDesign, weight: .bold))
                .foregroundStyle(theme.textColor)

            Button {
                performShuffle()
            } label: {
                Text("다시 섞기")
                    .font(.system(.headline, design: theme.fontDesign))
                    .foregroundStyle(theme == .halloween ? .white : theme.cardTextColor)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(theme.accentColor)
                    )
            }
        }
    }

    // MARK: - Random Card Overlay

    private func randomCardOverlay(card: Card) -> some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.showRandomCard = false
                    }
                }

            CardView(card: card, theme: theme)
                .frame(height: 400)
                .padding(.horizontal, 32)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .scale(scale: 0.8).combined(with: .opacity)
                ))
        }
    }

    // MARK: - Shuffle Animation

    private func performShuffle() {
        HapticManager.shuffle()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            viewModel.buildGameDeck()
        }
    }
}

// MARK: - Shake Gesture

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }
}

#Preview {
    CardDeckView()
}
