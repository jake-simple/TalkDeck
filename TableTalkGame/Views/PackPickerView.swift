import SwiftUI

struct PackPickerView: View {
    @Binding var selectedPack: CardPack
    @Binding var isPresented: Bool
    let theme: AppTheme
    var onSelect: (CardPack) -> Void

    @State private var scrollPosition: Int?
    @State private var appeared = false
    @State private var openingPack: CardPack? = nil

    private let packs = CardPack.allCases
    // 무한 스크롤을 위해 팩을 여러 번 반복
    private let repeatCount = 80
    private var totalCount: Int { repeatCount * packs.count }
    private var middleStart: Int { (repeatCount / 2) * packs.count }

    private func packFor(_ virtualIndex: Int) -> CardPack {
        packs[((virtualIndex % packs.count) + packs.count) % packs.count]
    }

    private var currentPack: CardPack {
        guard let pos = scrollPosition else { return selectedPack }
        return packFor(pos)
    }

    var body: some View {
        ZStack {
            // Background
            ZStack {
                // Base gradient
                Color(red: 0.08, green: 0.06, blue: 0.16)

                // Canvas로 빛 파티클 & 그라데이션 원 그리기
                TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let accent = currentPack.accentColor

                    Canvas { context, size in
                        // 떠다니는 빛 입자들
                        for i in 0..<18 {
                            let seed = Double(i)
                            let speed = 0.3 + seed * 0.08
                            let phase = seed * 2.4
                            let x = size.width * (0.1 + CGFloat(i % 5) * 0.2) + CGFloat(sin(time * speed + phase)) * 30
                            let y = size.height * (0.1 + CGFloat(i / 5) * 0.25) + CGFloat(cos(time * speed * 0.7 + phase)) * 20
                            let particleSize: CGFloat = CGFloat(3 + (i % 4) * 2)
                            let opacity = 0.15 + sin(time * 0.8 + seed) * 0.1

                            context.drawLayer { ctx in
                                ctx.opacity = max(0.05, opacity)
                                let particleGradient = Gradient(colors: [
                                    .white.opacity(0.8),
                                    accent.opacity(0.4),
                                    .clear
                                ])
                                let rect = CGRect(
                                    x: x - particleSize * 2,
                                    y: y - particleSize * 2,
                                    width: particleSize * 4,
                                    height: particleSize * 4
                                )
                                ctx.fill(
                                    Path(ellipseIn: rect),
                                    with: .radialGradient(particleGradient, center: CGPoint(x: x, y: y), startRadius: 0, endRadius: particleSize * 2)
                                )
                            }
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: scrollPosition)

                // 상단/하단 비네팅
                VStack {
                    LinearGradient(colors: [.black.opacity(0.4), .clear], startPoint: .top, endPoint: .bottom)
                        .frame(height: 120)
                    Spacer()
                    LinearGradient(colors: [.clear, .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                }
            }
            .opacity(appeared ? 1 : 0)
            .ignoresSafeArea()
            .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.4))
                            .frame(width: 32, height: 32)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }
                .opacity(appeared ? 1 : 0)

                // Title area
                VStack(spacing: 12) {
                    Text("카드팩 선택")
                        .font(.system(.title3, design: theme.fontDesign, weight: .bold))
                        .foregroundStyle(.white)

                    VStack(spacing: 6) {
                        Text(currentPack.name)
                            .font(.system(.title, design: theme.fontDesign, weight: .heavy))
                            .foregroundStyle(currentPack.accentColor)
                            .contentTransition(.numericText())

                        Text(currentPack.description)
                            .font(.system(.subheadline, design: theme.fontDesign))
                            .foregroundStyle(.white.opacity(0.6))
                            .contentTransition(.numericText())
                    }
                    .animation(.easeOut(duration: 0.2), value: scrollPosition)
                }
                .padding(.top, 20)
                .opacity(appeared ? 1 : 0)

                Spacer()

                // Select button
                Button {
                    selectPack(currentPack)
                } label: {
                    HStack(spacing: 8) {
                        if selectedPack == currentPack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("선택됨")
                        } else {
                            Image(systemName: "hand.tap.fill")
                            Text("이 팩으로 시작")
                        }
                    }
                    .font(.system(.headline, design: theme.fontDesign, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(currentPack.accentColor)
                            .shadow(color: currentPack.accentColor.opacity(0.5), radius: 12, y: 4)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 24)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.2), value: scrollPosition)

                // Fan ScrollView
                fanScrollView
                    .frame(height: 380)
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            if let index = packs.firstIndex(of: selectedPack) {
                scrollPosition = middleStart + index
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }
    }

    // MARK: - Fan ScrollView

    private var fanScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: -50) {
                ForEach(0..<totalCount, id: \.self) { virtualIndex in
                    let pack = packFor(virtualIndex)

                    FanPackCardView(
                        pack: pack,
                        isSelected: selectedPack == pack,
                        isOpening: openingPack == pack
                    )
                    .frame(width: 140, height: 220)
                    .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1.15 : max(0.75, 1.0 - abs(phase.value) * 0.15))
                            .rotationEffect(.degrees(phase.value * 18))
                            .offset(y: phase.isIdentity ? -10 : abs(phase.value) * 30)
                    }
                    .onTapGesture {
                        if scrollPosition == virtualIndex {
                            selectPack(pack)
                        } else {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                scrollPosition = virtualIndex
                            }
                        }
                    }
                    .id(virtualIndex)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .contentMargins(.horizontal, UIScreen.main.bounds.width / 2 - 70, for: .scrollContent)
    }

    // MARK: - Actions

    private func selectPack(_ pack: CardPack) {
        guard selectedPack != pack else {
            dismiss()
            return
        }

        openingPack = pack
        HapticManager.swipe()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onSelect(pack)
            openingPack = nil
            dismiss()
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            appeared = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Fan Pack Card View

private struct FanPackCardView: View {
    let pack: CardPack
    let isSelected: Bool
    let isOpening: Bool

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            pack.accentColor,
                            pack.accentColor.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 6, y: 3)

            // Shine overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.25), .clear, .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Content
            VStack(spacing: 10) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 54, height: 54)

                    Image(systemName: pack.iconName)
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .symbolEffect(.bounce, value: isOpening)
                }

                Text(pack.name)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()
            }

            // Selected badge
            if isSelected {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white, pack.accentColor)
                            .shadow(radius: 2)
                            .padding(8)
                    }
                    Spacer()
                }
            }
        }
        .scaleEffect(isOpening ? 1.12 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOpening)
    }
}
