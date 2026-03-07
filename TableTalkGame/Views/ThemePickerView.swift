import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: AppTheme
    @Binding var isPresented: Bool

    @State private var scrollPosition: Int?
    @State private var appeared = false
    @State private var openingTheme: AppTheme? = nil

    private let themes = AppTheme.allCases
    private let repeatCount = 80
    private var totalCount: Int { repeatCount * themes.count }
    private var middleStart: Int { (repeatCount / 2) * themes.count }

    private func themeFor(_ virtualIndex: Int) -> AppTheme {
        themes[((virtualIndex % themes.count) + themes.count) % themes.count]
    }

    private var currentTheme: AppTheme {
        guard let pos = scrollPosition else { return selectedTheme }
        return themeFor(pos)
    }

    var body: some View {
        ZStack {
            // Background
            ZStack {
                Color(red: 0.08, green: 0.06, blue: 0.16)

                TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let accent = currentTheme.accentColor

                    Canvas { context, size in
                        // Central glow
                        let glowCenter = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
                        let glowRadius: CGFloat = size.width * 0.8
                        context.drawLayer { ctx in
                            ctx.opacity = 0.25
                            let gradient = Gradient(colors: [accent, accent.opacity(0.3), .clear])
                            ctx.fill(
                                Path(ellipseIn: CGRect(
                                    x: glowCenter.x - glowRadius / 2,
                                    y: glowCenter.y - glowRadius / 2.5,
                                    width: glowRadius,
                                    height: glowRadius / 1.3
                                )),
                                with: .radialGradient(
                                    gradient,
                                    center: glowCenter,
                                    startRadius: 0,
                                    endRadius: glowRadius / 2
                                )
                            )
                        }

                        // Top secondary glow
                        context.drawLayer { ctx in
                            ctx.opacity = 0.12
                            let topCenter = CGPoint(x: size.width * 0.3, y: size.height * 0.15)
                            let topGradient = Gradient(colors: [accent.opacity(0.6), .clear])
                            ctx.fill(
                                Path(ellipseIn: CGRect(
                                    x: topCenter.x - 150,
                                    y: topCenter.y - 100,
                                    width: 300,
                                    height: 200
                                )),
                                with: .radialGradient(topGradient, center: topCenter, startRadius: 0, endRadius: 150)
                            )
                        }

                        // Floating particles
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

                // Vignetting
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
                Text("테마 선택")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(appeared ? 1 : 0)
                    .padding(.top, 60)

                Spacer()

                // Large center preview card
                ThemeLargePreview(theme: currentTheme)
                    .frame(width: 260, height: 260)
                    .scaleEffect(openingTheme == currentTheme ? 1.15 : (appeared ? 1 : 0.8))
                    .opacity(appeared ? 1 : 0)
                    .offset(y: -28)
                    .animation(.easeOut(duration: 0.2), value: scrollPosition)
                    .onTapGesture {
                        selectTheme(currentTheme)
                    }

                Spacer()

                // Coverflow ScrollView
                fanScrollView
                    .frame(height: 200)
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            if let index = themes.firstIndex(of: selectedTheme) {
                scrollPosition = middleStart + index
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }
    }

    // MARK: - Coverflow ScrollView

    private var fanScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 4) {
                ForEach(0..<totalCount, id: \.self) { virtualIndex in
                    let theme = themeFor(virtualIndex)

                    ThemePreviewCard(theme: theme)
                        .frame(width: 80, height: 120)
                        .rotation3DEffect(
                            .degrees(0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.4 : max(0.75, 1.0 - abs(phase.value) * 0.2))
                                .rotation3DEffect(
                                    .degrees(phase.value * -40),
                                    axis: (x: 0, y: 1, z: 0),
                                    perspective: 0.35
                                )
                                .opacity(max(0.5, 1.0 - abs(phase.value) * 0.4))
                        }
                        .onTapGesture {
                            if scrollPosition == virtualIndex {
                                selectTheme(theme)
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
        .contentMargins(.horizontal, UIScreen.main.bounds.width / 2 - 40, for: .scrollContent)
    }

    // MARK: - Actions

    private func selectTheme(_ theme: AppTheme) {
        openingTheme = theme
        HapticManager.swipe()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            // triggers scale effect on large preview
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedTheme = theme
            }
            openingTheme = nil
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

// MARK: - Theme Large Preview (Center Card)

private struct ThemeLargePreview: View {
    let theme: AppTheme

    var body: some View {
        ZStack {
            // Card background with pattern
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .fill(theme.cardBackgroundColor)
                .overlay(
                    CardBackgroundPattern(theme: theme)
                        .clipShape(RoundedRectangle(cornerRadius: theme.cardCornerRadius))
                )
                .shadow(color: theme.cardShadowColor, radius: 12, x: 0, y: 0)
                .shadow(color: theme.cardShadowColor.opacity(0.4), radius: 30, x: 0, y: 0)

            // Themed border
            ThemedCardBorder(theme: theme)

            // Theme-specific decorations
            CardDecorationOverlay(theme: theme)
                .clipShape(RoundedRectangle(cornerRadius: theme.cardCornerRadius))

            // Theme name & emoji
            VStack(spacing: 12) {
                Text(theme.themeEmoji)
                    .font(.system(size: 48))

                Text(theme.name)
                    .font(.system(.title2, design: theme.fontDesign, weight: .bold))
                    .foregroundStyle(theme.cardTextColor)
            }
        }
    }
}

// MARK: - Theme Preview Card

private struct ThemePreviewCard: View {
    let theme: AppTheme

    private var cornerRadius: CGFloat {
        theme.cardCornerRadius * 0.7
    }

    var body: some View {
        ZStack {
            // Card background with pattern
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(theme.cardBackgroundColor)

            CardBackgroundPattern(theme: theme)

            // Theme-specific decorations
            CardDecorationOverlay(theme: theme)

            // Border stroke
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(theme.accentColor.opacity(0.3), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .drawingGroup()
        .shadow(color: theme.cardShadowColor, radius: 4, x: 0, y: 0)
    }
}
