import SwiftUI

// MARK: - Themed Card Border Styles

struct ThemedCardBorder: View {
    let theme: AppTheme

    var body: some View {
        switch theme {
        case .minimal:
            // Clean double border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(Color(red: 0.75, green: 0.75, blue: 0.78), lineWidth: 1.5)
            RoundedRectangle(cornerRadius: theme.cardCornerRadius - 5)
                .stroke(Color(red: 0.82, green: 0.82, blue: 0.85), lineWidth: 0.8)
                .padding(6)

        case .halloween:
            // Double border - orange inner, dark outer
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(Color(red: 0.95, green: 0.55, blue: 0.10).opacity(0.5), lineWidth: 2)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius + 4)
                        .stroke(Color(red: 0.95, green: 0.55, blue: 0.10).opacity(0.2), lineWidth: 1)
                )

        case .christmas:
            // Gold ornate border with inner glow
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.70, blue: 0.20),
                            Color(red: 0.95, green: 0.85, blue: 0.40),
                            Color(red: 0.85, green: 0.70, blue: 0.20),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )

        case .ocean:
            // Soft blue gradient border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.20, green: 0.70, blue: 0.90).opacity(0.5),
                            Color(red: 0.10, green: 0.50, blue: 0.80).opacity(0.3),
                            Color(red: 0.20, green: 0.70, blue: 0.90).opacity(0.5),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )

        case .space:
            // Glowing purple dotted border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.4),
                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                )
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                        .stroke(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.15), lineWidth: 6)
                        .blur(radius: 4)
                )

        case .cherryBlossom:
            // Delicate pink border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    Color(red: 0.95, green: 0.70, blue: 0.80).opacity(0.5),
                    lineWidth: 1.5
                )

        case .retroGame:
            // Neon green pixel border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(Color(red: 0.10, green: 0.95, blue: 0.40), lineWidth: 2.5)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                        .stroke(Color(red: 0.10, green: 0.95, blue: 0.40).opacity(0.3), lineWidth: 8)
                        .blur(radius: 6)
                )

        case .autumn:
            // Warm brown natural border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.75, green: 0.50, blue: 0.20).opacity(0.4),
                            Color(red: 0.85, green: 0.60, blue: 0.25).opacity(0.3),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )

        case .aurora:
            // Rainbow glow border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.5),
                            Color(red: 0.30, green: 0.50, blue: 0.90).opacity(0.4),
                            Color(red: 0.70, green: 0.20, blue: 0.80).opacity(0.5),
                            Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.5),
                        ],
                        center: .center
                    ),
                    lineWidth: 2.5
                )
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                        .stroke(
                            AngularGradient(
                                colors: [
                                    Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.2),
                                    Color(red: 0.70, green: 0.20, blue: 0.80).opacity(0.15),
                                    Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.2),
                                ],
                                center: .center
                            ),
                            lineWidth: 8
                        )
                        .blur(radius: 5)
                )

        case .circus:
            // Red & white striped feel border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(Color(red: 0.90, green: 0.20, blue: 0.30), lineWidth: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                        .stroke(Color(red: 0.95, green: 0.80, blue: 0.15).opacity(0.5), lineWidth: 1)
                        .padding(5)
                )

        case .desert:
            // Sand-colored subtle border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.5),
                            Color(red: 0.80, green: 0.65, blue: 0.30).opacity(0.3),
                            Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.5),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )

        case .candy:
            // Multi-color candy border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.6),
                            Color(red: 0.55, green: 0.85, blue: 0.75).opacity(0.5),
                            Color(red: 0.98, green: 0.80, blue: 0.25).opacity(0.6),
                            Color(red: 0.65, green: 0.50, blue: 0.90).opacity(0.5),
                            Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.6),
                        ],
                        center: .center
                    ),
                    lineWidth: 3
                )

        case .zenGarden:
            // Minimal thin charcoal border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(Color(red: 0.40, green: 0.42, blue: 0.38).opacity(0.25), lineWidth: 1)

        case .forsythia:
            // Vivid yellow gradient border
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.85, blue: 0.08).opacity(0.6),
                            Color(red: 0.90, green: 0.75, blue: 0.05).opacity(0.4),
                            Color(red: 0.98, green: 0.85, blue: 0.08).opacity(0.6),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
        }
    }
}

// MARK: - Card Background Patterns

struct CardBackgroundPattern: View {
    let theme: AppTheme

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            switch theme {
            case .minimal:
                // Subtle radial gradient
                RadialGradient(
                    colors: [
                        Color.white,
                        Color(red: 0.96, green: 0.96, blue: 0.97),
                    ],
                    center: .center,
                    startRadius: 30,
                    endRadius: max(w, h) * 0.7
                )

            case .halloween:
                // Subtle dark gradient with vignette
                RadialGradient(
                    colors: [
                        theme.cardBackgroundColor,
                        theme.cardBackgroundColor.opacity(0.85),
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: max(w, h) * 0.8
                )

            case .christmas:
                // Warm ivory with subtle diamond pattern
                ZStack {
                    theme.cardBackgroundColor
                    DiamondPattern(spacing: 30)
                        .stroke(Color(red: 0.85, green: 0.70, blue: 0.20).opacity(0.06), lineWidth: 0.5)
                }

            case .ocean:
                // Gradient from light to slightly deeper blue
                LinearGradient(
                    colors: [
                        theme.cardBackgroundColor,
                        Color(red: 0.82, green: 0.92, blue: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

            case .space:
                // Dark with tiny star dots
                ZStack {
                    theme.cardBackgroundColor
                    Canvas { context, size in
                        for i in 0..<15 {
                            let x = CGFloat((i * 37 + 13) % Int(size.width))
                            let y = CGFloat((i * 53 + 7) % Int(size.height))
                            let r = CGFloat(i % 3 == 0 ? 1.5 : 1.0)
                            let rect = CGRect(x: x, y: y, width: r, height: r)
                            context.fill(Path(ellipseIn: rect),
                                        with: .color(.white.opacity(0.15)))
                        }
                    }
                }

            case .cherryBlossom:
                // Soft gradient pink to white
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.95, blue: 0.97),
                        theme.cardBackgroundColor,
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

            case .retroGame:
                // Dark with grid lines
                ZStack {
                    theme.cardBackgroundColor
                    GridPattern(spacing: 20)
                        .stroke(Color(red: 0.10, green: 0.95, blue: 0.40).opacity(0.06), lineWidth: 0.5)
                }

            case .autumn:
                // Warm parchment gradient
                LinearGradient(
                    colors: [
                        theme.cardBackgroundColor,
                        Color(red: 0.98, green: 0.94, blue: 0.88),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

            case .aurora:
                // Dark with subtle color wash
                ZStack {
                    theme.cardBackgroundColor
                    LinearGradient(
                        colors: [
                            Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.04),
                            Color(red: 0.50, green: 0.20, blue: 0.80).opacity(0.04),
                            .clear,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }

            case .circus:
                // White with subtle radiating stripes from top
                ZStack {
                    theme.cardBackgroundColor
                    Canvas { context, size in
                        for i in 0..<12 {
                            let angle = CGFloat(i) * .pi / 6
                            var path = Path()
                            path.move(to: CGPoint(x: size.width / 2, y: 0))
                            let endX = size.width / 2 + cos(angle) * max(size.width, size.height)
                            let endY = sin(angle) * max(size.width, size.height)
                            let endX2 = size.width / 2 + cos(angle + .pi / 12) * max(size.width, size.height)
                            let endY2 = sin(angle + .pi / 12) * max(size.width, size.height)
                            path.addLine(to: CGPoint(x: endX, y: endY))
                            path.addLine(to: CGPoint(x: endX2, y: endY2))
                            path.closeSubpath()
                            if i % 2 == 0 {
                                context.fill(path, with: .color(Color.red.opacity(0.03)))
                            }
                        }
                    }
                }

            case .desert:
                // Dark with warm gradient
                ZStack {
                    theme.cardBackgroundColor
                    LinearGradient(
                        colors: [
                            Color(red: 0.90, green: 0.75, blue: 0.35).opacity(0.05),
                            .clear,
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }

            case .candy:
                // Soft pastel gradient
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.94, blue: 0.96),
                        theme.cardBackgroundColor,
                        Color(red: 0.94, green: 1.0, blue: 0.98),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

            case .zenGarden:
                // Warm sand texture gradient
                ZStack {
                    theme.cardBackgroundColor
                    RadialGradient(
                        colors: [
                            Color(red: 0.96, green: 0.95, blue: 0.91),
                            theme.cardBackgroundColor,
                        ],
                        center: .center,
                        startRadius: 30,
                        endRadius: max(w, h) * 0.7
                    )
                }

            case .forsythia:
                // Warm yellow gradient
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.96, blue: 0.82),
                        theme.cardBackgroundColor,
                        Color(red: 1.0, green: 0.94, blue: 0.78),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

// MARK: - Pattern Shapes

struct DiamondPattern: Shape {
    let spacing: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let half = spacing / 2
        var y: CGFloat = 0
        var row = 0
        while y < rect.height + spacing {
            var x: CGFloat = row % 2 == 0 ? 0 : half
            while x < rect.width + spacing {
                p.move(to: CGPoint(x: x, y: y - half))
                p.addLine(to: CGPoint(x: x + half, y: y))
                p.addLine(to: CGPoint(x: x, y: y + half))
                p.addLine(to: CGPoint(x: x - half, y: y))
                p.closeSubpath()
                x += spacing
            }
            y += half
            row += 1
        }
        return p
    }
}

struct GridPattern: Shape {
    let spacing: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        var x: CGFloat = 0
        while x <= rect.width {
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x, y: rect.height))
            x += spacing
        }
        var y: CGFloat = 0
        while y <= rect.height {
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: rect.width, y: y))
            y += spacing
        }
        return p
    }
}
