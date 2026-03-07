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
            // Background — aurora effect
            ZStack {
                Color(red: 0.10, green: 0.08, blue: 0.18)

                TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let accent = currentTheme.accentColor

                    Canvas { context, size in
                        let w = size.width
                        let h = size.height

                        // Draw aurora bands
                        for band in 0..<5 {
                            let seed = Double(band)
                            let baseY = h * (0.15 + seed * 0.15)
                            let speed = 0.25 + seed * 0.08
                            let amplitude: CGFloat = 30 + CGFloat(band) * 12

                            var path = Path()
                            path.move(to: CGPoint(x: -20, y: baseY))

                            // Wavy top edge
                            let steps = 12
                            for s in 0...steps {
                                let t = CGFloat(s) / CGFloat(steps)
                                let x = -20 + (w + 40) * t
                                let wave1 = sin(time * speed + Double(t) * 6 + seed * 2.5) * Double(amplitude)
                                let wave2 = cos(time * speed * 0.7 + Double(t) * 4 + seed * 1.8) * Double(amplitude * 0.5)
                                let y = baseY + CGFloat(wave1 + wave2)
                                if s == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }

                            // Wavy bottom edge (offset down)
                            let bandHeight: CGFloat = 60 + CGFloat(band) * 20
                            for s in stride(from: steps, through: 0, by: -1) {
                                let t = CGFloat(s) / CGFloat(steps)
                                let x = -20 + (w + 40) * t
                                let wave1 = sin(time * speed + Double(t) * 6 + seed * 2.5 + 1.0) * Double(amplitude * 0.8)
                                let wave2 = cos(time * speed * 0.7 + Double(t) * 4 + seed * 1.8 + 0.5) * Double(amplitude * 0.4)
                                let y = baseY + bandHeight + CGFloat(wave1 + wave2)
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                            path.closeSubpath()

                            let bandOpacity = [0.40, 0.30, 0.35, 0.25, 0.20][band]
                            let hueShift = Double(band) * 0.15

                            context.drawLayer { ctx in
                                ctx.opacity = bandOpacity
                                ctx.addFilter(.blur(radius: 25 + CGFloat(band) * 8))
                                ctx.fill(
                                    path,
                                    with: .linearGradient(
                                        Gradient(colors: [
                                            accent.opacity(0.9),
                                            accent.opacity(0.5),
                                            Color(
                                                hue: hueShift,
                                                saturation: 0.6,
                                                brightness: 0.8
                                            ).opacity(0.4),
                                            accent.opacity(0.2)
                                        ]),
                                        startPoint: CGPoint(x: 0, y: baseY),
                                        endPoint: CGPoint(x: w, y: baseY + bandHeight)
                                    )
                                )
                            }
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.8), value: scrollPosition)
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

                Text("테마 선택")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(appeared ? 1 : 0)

                Spacer()

                // Large center preview card
                ThemeLargePreview(theme: currentTheme)
                    .frame(width: 220, height: 220)
                    .scaleEffect(openingTheme == currentTheme ? 1.15 : (appeared ? 1 : 0.8))
                    .opacity(appeared ? 1 : 0)
                    .offset(y: -28)
                    .animation(.easeOut(duration: 0.2), value: scrollPosition)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: openingTheme)
                    .onTapGesture {
                        selectTheme(currentTheme)
                    }

                Spacer()
                    .frame(height: 24)

                // Select button
                Button {
                    selectTheme(currentTheme)
                } label: {
                    HStack(spacing: 8) {
                        if selectedTheme == currentTheme {
                            Image(systemName: "checkmark.circle.fill")
                            Text("선택됨")
                        } else {
                            Image(systemName: "paintbrush.fill")
                            Text("이 테마 적용")
                        }
                    }
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(currentTheme.accentColor)
                            .shadow(color: currentTheme.accentColor.opacity(0.5), radius: 12, y: 4)
                    )
                }
                .padding(.horizontal, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.2), value: scrollPosition)

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
        HapticManager.swipe()
        openingTheme = theme

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
