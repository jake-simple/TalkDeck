import SwiftUI

struct CardView: View {
    let card: Card
    let theme: AppTheme

    private let questionFontSize: CGFloat = 28

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

            // Theme-specific decorations (frame, ornaments)
            CardDecorationOverlay(theme: theme)
                .clipShape(RoundedRectangle(cornerRadius: theme.cardCornerRadius))

            // Card content - theme-aware layout
            cardContent
        }
    }

    @ViewBuilder
    private var cardContent: some View {
        switch theme {
        case .minimal:
            minimalLayout
        case .halloween:
            yugiohLayout
        case .christmas:
            victorianLayout
        case .ocean:
            pokemonLayout
        case .space:
            mtgLayout
        case .cherryBlossom:
            hanafudaLayout
        case .retroGame:
            arcadeLayout
        case .autumn:
            tarotLayout
        case .aurora:
            holoLayout
        case .circus:
            playingCardLayout
        case .desert:
            egyptianLayout
        case .candy:
            candyLayout
        case .zenGarden:
            zenGardenLayout
        case .forsythia:
            forsythiaLayout
        }
    }

    // MARK: - Minimal Style
    private var minimalLayout: some View {
        VStack(spacing: 0) {
            // Subtle top accent
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 20, height: 1)
                Image(systemName: "circle.fill")
                    .font(.system(size: 4))
                    .foregroundStyle(Color.gray.opacity(0.3))
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 20, height: 1)
            }
            .padding(.top, 28)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .default))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 28)

            Spacer()

            // Bottom number
            Text("No.\(card.question.count % 100)")
                .font(.system(size: 9, weight: .light, design: .default))
                .foregroundStyle(Color.gray.opacity(0.3))
                .tracking(2)
                .padding(.bottom, 24)
        }
    }

    // MARK: - Yu-Gi-Oh Style (Halloween)
    private var yugiohLayout: some View {
        VStack(spacing: 0) {
            // Level stars row
            HStack(spacing: 3) {
                Spacer()
                ForEach(0..<min(card.question.count % 8 + 1, 8), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 7))
                        .foregroundStyle(Color(red: 0.95, green: 0.75, blue: 0.15))
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)

            // "Art frame" area
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                .frame(height: 6)
                .padding(.horizontal, 28)
                .padding(.top, 8)

            Spacer()

            // Question text
            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: theme.fontDesign))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 28)

            Spacer()

            // Bottom bar - attribute & category
            HStack {
                // Attribute orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.orange, Color.orange.opacity(0.5)],
                            center: .center, startRadius: 0, endRadius: 10
                        )
                    )
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.white)
                    )

                Spacer()

                Text("ATK/???")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(theme.cardTextColor.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Victorian Style (Christmas)
    private var victorianLayout: some View {
        VStack(spacing: 0) {
            // Ornate header
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.15, green: 0.45, blue: 0.20).opacity(0.5))
                    .rotationEffect(.degrees(-45))

                Image(systemName: "snowflake")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.15).opacity(0.5))

                Image(systemName: "leaf.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.15, green: 0.45, blue: 0.20).opacity(0.5))
                    .rotationEffect(.degrees(45))
            }
            .padding(.top, 24)

            // Divider with diamond
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.3))
                    .frame(height: 1)
                Image(systemName: "diamond.fill")
                    .font(.system(size: 5))
                    .foregroundStyle(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.5))
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 30)
            .padding(.top, 8)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .serif))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .italic()
                .padding(.horizontal, 32)

            Spacer()

            // Bottom ornament
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.3))
                    .frame(height: 1)
                Image(systemName: "diamond.fill")
                    .font(.system(size: 5))
                    .foregroundStyle(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.5))
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.65, blue: 0.20).opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Pokemon Style (Ocean)
    private var pokemonLayout: some View {
        VStack(spacing: 0) {
            // Top type bar
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(red: 0.2, green: 0.6, blue: 0.9).opacity(0.7))
                Spacer()

                // HP badge
                HStack(spacing: 2) {
                    Text("HP")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.9, green: 0.2, blue: 0.2))
                    Text("\(60 + (card.question.count % 200))")
                        .font(.system(.subheadline, design: .rounded, weight: .heavy))
                        .foregroundStyle(theme.cardTextColor)
                }

                // Type energy icon
                Circle()
                    .fill(Color(red: 0.2, green: 0.6, blue: 0.9))
                    .frame(width: 22, height: 22)
                    .overlay(
                        Image(systemName: "drop.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            // Inner frame
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0.2, green: 0.6, blue: 0.9).opacity(0.2), lineWidth: 1)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .frame(height: 8)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 24)

            Spacer()

            // Bottom energy bar
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(
                            [Color.blue, Color.cyan, Color.teal][i].opacity(0.3)
                        )
                        .frame(width: 14, height: 14)
                }
                Spacer()
                Text("weakness   resistance   retreat")
                    .font(.system(size: 7, design: .rounded))
                    .foregroundStyle(theme.cardTextColor.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - MTG Style (Space)
    private var mtgLayout: some View {
        VStack(spacing: 0) {
            // Title bar with mana cost
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.purple.opacity(0.6))
                Spacer()
                // Mana dots
                HStack(spacing: 3) {
                    ForEach(0..<(card.question.count % 4 + 1), id: \.self) { _ in
                        Circle()
                            .fill(Color.purple.opacity(0.6))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            // Art frame line
            Rectangle()
                .fill(Color.purple.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, 18)
                .padding(.top, 10)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .monospaced))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 24)

            Spacer()

            // Text box divider
            Rectangle()
                .fill(Color.purple.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, 18)

            // Flavor text area
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.purple.opacity(0.4))
                Spacer()
                Text("Legendary Question")
                    .font(.system(size: 8, design: .serif))
                    .foregroundStyle(theme.cardTextColor.opacity(0.3))
                    .italic()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Hanafuda Style (Cherry Blossom)
    private var hanafudaLayout: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(Color(red: 0.9, green: 0.55, blue: 0.65).opacity(0.5))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .serif))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 28)

            Spacer()

            // Simple elegant bottom
            HStack {
                Spacer()
                Image(systemName: "leaf.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(red: 0.9, green: 0.55, blue: 0.65).opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 22)
        }
    }

    // MARK: - Arcade Style (Retro)
    private var arcadeLayout: some View {
        VStack(spacing: 0) {
            // Top status bar
            HStack {
                Text("P1")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.95, blue: 0.4))
                Spacer()
                Text("LV.\(card.question.count % 99 + 1)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.95, blue: 0.4).opacity(0.6))
                Spacer()
                Text("STAGE \(card.question.count % 12 + 1)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.95, blue: 0.4))
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // HP bar
            HStack(spacing: 4) {
                Text("HP")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.red)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.3))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.green)
                            .frame(width: geo.size.width * 0.7)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)

            Spacer()

            // Question with "dialog box" feel
            VStack(spacing: 4) {
                Text("▶ " + card.question)
                    .font(.system(size: questionFontSize - 4, weight: .semibold, design: .monospaced))
                    .foregroundStyle(theme.cardTextColor)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 22)

            Spacer()

            // Bottom - category as "command"
            HStack {
                Text("> READY_")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.95, blue: 0.4).opacity(0.5))
                Spacer()
                Text("▼")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.95, blue: 0.4))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Tarot Style (Autumn)
    private var tarotLayout: some View {
        VStack(spacing: 0) {
            // Roman numeral header
            Text(romanNumeral(for: (card.question.count % 22) + 1))
                .font(.system(.caption, design: .serif, weight: .bold))
                .foregroundStyle(Color(red: 0.65, green: 0.45, blue: 0.20))
                .tracking(4)
                .padding(.top, 20)

            Spacer()

            // Central question with mystical frame feel
            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .serif))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 30)

            Spacer()

            // Bottom ornament
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 6))
                Image(systemName: "moon.fill")
                    .font(.system(size: 8))
                Image(systemName: "star.fill")
                    .font(.system(size: 6))
            }
            .foregroundStyle(Color(red: 0.65, green: 0.45, blue: 0.20).opacity(0.5))
            .padding(.bottom, 20)
        }
    }

    // MARK: - Holographic Style (Aurora)
    private var holoLayout: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { _ in
                        Image(systemName: "sparkle")
                            .font(.system(size: 7))
                            .foregroundStyle(theme.accentColor.opacity(0.5))
                    }
                }
                Spacer()

                // Rarity indicator
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { _ in
                        Image(systemName: "sparkle")
                            .font(.system(size: 7))
                            .foregroundStyle(Color(red: 0.2, green: 0.9, blue: 0.6).opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 20)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .default))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 26)

            Spacer()

            HStack {
                Spacer()
                Text("ULTRA RARE")
                    .font(.system(size: 7, weight: .bold, design: .default))
                    .foregroundStyle(theme.accentColor.opacity(0.3))
                    .tracking(2)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 18)
        }
    }

    // MARK: - Playing Card Style (Circus)
    private var playingCardLayout: some View {
        VStack(spacing: 0) {
            // Top-left corner value
            HStack(alignment: .top) {
                VStack(spacing: 1) {
                    Text("Q")
                        .font(.system(.title3, design: .rounded, weight: .heavy))
                        .foregroundStyle(Color(red: 0.85, green: 0.15, blue: 0.20))
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color(red: 0.85, green: 0.15, blue: 0.20))
                }
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 28)

            Spacer()

            // Bottom-right corner (inverted)
            HStack(alignment: .bottom) {
                Spacer()
                VStack(spacing: 1) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color(red: 0.85, green: 0.15, blue: 0.20))
                    Text("Q")
                        .font(.system(.title3, design: .rounded, weight: .heavy))
                        .foregroundStyle(Color(red: 0.85, green: 0.15, blue: 0.20))
                }
                .rotationEffect(.degrees(180))
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 14)
        }
    }

    // MARK: - Egyptian Style (Desert)
    private var egyptianLayout: some View {
        VStack(spacing: 0) {
            // Eye of Horus header
            HStack {
                Image(systemName: "eye.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.5))
                Spacer()
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.4))
                Spacer()
                Image(systemName: "eye.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.5))
            }
            .padding(.horizontal, 22)
            .padding(.top, 20)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .default))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 26)

            Spacer()

            // Bottom hieroglyphic-like symbols
            HStack(spacing: 8) {
                Image(systemName: "triangle.fill")
                    .font(.system(size: 8))
                Image(systemName: "circle.fill")
                    .font(.system(size: 5))
                Image(systemName: "diamond.fill")
                    .font(.system(size: 6))
                Image(systemName: "circle.fill")
                    .font(.system(size: 5))
                Image(systemName: "triangle.fill")
                    .font(.system(size: 8))
            }
            .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.3))
            .padding(.bottom, 20)
        }
    }

    // MARK: - Candy Style
    private var candyLayout: some View {
        VStack(spacing: 0) {
            // Sprinkle dots row
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { i in
                    Circle()
                        .fill([
                            Color(red: 0.95, green: 0.35, blue: 0.55),
                            Color(red: 0.55, green: 0.85, blue: 0.75),
                            Color(red: 0.98, green: 0.80, blue: 0.25),
                            Color(red: 0.65, green: 0.50, blue: 0.90),
                            Color(red: 0.95, green: 0.55, blue: 0.35),
                            Color(red: 0.50, green: 0.80, blue: 0.95),
                            Color(red: 0.95, green: 0.35, blue: 0.55),
                        ][i].opacity(0.5))
                        .frame(width: CGFloat(4 + (i % 3) * 2), height: CGFloat(4 + (i % 3) * 2))
                }
            }
            .padding(.top, 20)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 28)

            Spacer()

            // Bottom ribbon
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.4))
                Rectangle()
                    .fill(Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.15))
                    .frame(height: 1)
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Zen Garden Style
    private var zenGardenLayout: some View {
        VStack(spacing: 0) {
            // Enso circle (top)
            Circle()
                .stroke(Color(red: 0.35, green: 0.38, blue: 0.32).opacity(0.2), lineWidth: 1.5)
                .frame(width: 24, height: 24)
                .padding(.top, 24)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .serif))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 30)

            Spacer()

            // Zen wave lines (bottom)
            VStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    ZenWaveLine()
                        .stroke(Color(red: 0.55, green: 0.58, blue: 0.50).opacity(0.15), lineWidth: 0.8)
                        .frame(height: 6)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 22)
        }
    }

    // MARK: - Forsythia Style (개나리)
    private var forsythiaLayout: some View {
        let yellow = Color(red: 0.98, green: 0.85, blue: 0.08)

        return VStack(spacing: 0) {
            // Divider with small flowers
            HStack(spacing: 6) {
                Rectangle()
                    .fill(yellow.opacity(0.3))
                    .frame(height: 1)
                // Mini daisy
                ZStack {
                    ForEach(0..<6, id: \.self) { i in
                        Ellipse()
                            .fill(yellow.opacity(0.35))
                            .frame(width: 4, height: 7)
                            .offset(y: -5)
                            .rotationEffect(.degrees(Double(i) * 60))
                    }
                    Circle()
                        .fill(Color(red: 0.85, green: 0.65, blue: 0.08).opacity(0.5))
                        .frame(width: 5, height: 5)
                }
                Rectangle()
                    .fill(yellow.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 28)
            .padding(.top, 24)

            Spacer()

            Text(card.question)
                .font(.system(size: questionFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.cardTextColor)
                .multilineTextAlignment(.center)
                .lineSpacing(7)
                .padding(.horizontal, 28)

            Spacer()

            // Bottom: row of mini daisies
            HStack(spacing: 14) {
                ForEach(0..<3, id: \.self) { i in
                    ZStack {
                        ForEach(0..<6, id: \.self) { p in
                            Ellipse()
                                .fill(yellow.opacity(0.3 - Double(i) * 0.05))
                                .frame(width: 3.5, height: 6)
                                .offset(y: -4.5)
                                .rotationEffect(.degrees(Double(p) * 60))
                        }
                        Circle()
                            .fill(Color(red: 0.85, green: 0.65, blue: 0.08).opacity(0.4))
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .padding(.bottom, 22)
        }
    }

    // MARK: - Helpers

    private struct ZenWaveLine: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let waveCount = 6
            let stepX = rect.width / CGFloat(waveCount)
            p.move(to: CGPoint(x: 0, y: rect.midY))
            for i in 0..<waveCount {
                let x1 = stepX * CGFloat(i) + stepX * 0.5
                let x2 = stepX * CGFloat(i + 1)
                p.addQuadCurve(
                    to: CGPoint(x: x1, y: rect.midY - rect.height * 0.4),
                    control: CGPoint(x: stepX * CGFloat(i) + stepX * 0.25, y: rect.midY - rect.height * 0.4)
                )
                p.addQuadCurve(
                    to: CGPoint(x: x2, y: rect.midY),
                    control: CGPoint(x: x1 + stepX * 0.25, y: rect.midY + rect.height * 0.4)
                )
            }
            return p
        }
    }

    private func romanNumeral(for n: Int) -> String {
        let values = [(10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        var result = ""
        var remaining = n
        for (value, numeral) in values {
            while remaining >= value {
                result += numeral
                remaining -= value
            }
        }
        return result
    }
}
