import SwiftUI

// MARK: - Canvas-based Animated Background

struct AnimatedBackgroundView: View {
    let theme: AppTheme
    @State private var time: Double = 0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                drawBackground(ctx: ctx, size: size, time: t, theme: theme)
            }
        }
        .ignoresSafeArea()
    }

    private func drawBackground(ctx: GraphicsContext, size: CGSize, time: Double, theme: AppTheme) {
        switch theme {
        case .minimal:
            break

        case .halloween:
            drawHalloweenBG(ctx: ctx, size: size, time: time)

        case .christmas:
            drawSnowfallBG(ctx: ctx, size: size, time: time)

        case .ocean:
            drawOceanBG(ctx: ctx, size: size, time: time)

        case .space:
            drawSpaceBG(ctx: ctx, size: size, time: time)

        case .cherryBlossom:
            drawCherryBlossomBG(ctx: ctx, size: size, time: time)

        case .retroGame:
            drawRetroBG(ctx: ctx, size: size, time: time)

        case .autumn:
            drawAutumnBG(ctx: ctx, size: size, time: time)

        case .aurora:
            drawAuroraBG(ctx: ctx, size: size, time: time)

        case .circus:
            drawCircusBG(ctx: ctx, size: size, time: time)

        case .desert:
            drawDesertBG(ctx: ctx, size: size, time: time)
        }
    }

    // MARK: - Halloween

    private func drawHalloweenBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Floating glowing orbs
        for i in 0..<12 {
            let seed = Double(i) * 137.5
            let x = (sin(time * 0.3 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 12.0 * size.height
            let y = baseY + sin(time * 0.5 + seed * 0.7) * 30
            let radius: CGFloat = CGFloat(6 + (i % 3) * 3)
            let opacity = 0.06 + sin(time * 0.8 + seed) * 0.03

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(Color.orange.opacity(opacity)))

            // Glow
            let glowR = radius * 2.5
            let glow = Path(ellipseIn: CGRect(x: x - glowR, y: y - glowR, width: glowR * 2, height: glowR * 2))
            ctx.fill(glow, with: .color(Color.orange.opacity(opacity * 0.3)))
        }
    }

    // MARK: - Christmas (Snowfall)

    private func drawSnowfallBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        for i in 0..<30 {
            let seed = Double(i) * 97.3
            let x = fmod(seed * 31.7 + sin(time * 0.2 + seed) * 40, size.width)
            let fallSpeed = 30.0 + fmod(seed * 17.3, 40.0)
            let y = fmod(time * fallSpeed + seed * 47.1, Double(size.height + 20)) - 10
            let radius: CGFloat = CGFloat(1.5 + fmod(seed * 3.7, 3.0))
            let opacity = 0.15 + fmod(seed * 0.13, 0.15)

            let flake = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(flake, with: .color(Color.white.opacity(opacity)))
        }
    }

    // MARK: - Ocean

    private func drawOceanBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Gentle wave lines
        for w in 0..<4 {
            let waveY = size.height * (0.3 + CGFloat(w) * 0.18)
            let opacity = 0.04 - Double(w) * 0.005
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 4) {
                let y = waveY + sin(Double(x) * 0.015 + time * 0.6 + Double(w) * 1.2) * 15
                if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            ctx.stroke(path, with: .color(Color.cyan.opacity(opacity)), lineWidth: 1.5)
        }

        // Floating bubbles
        for i in 0..<10 {
            let seed = Double(i) * 83.7
            let x = fmod(seed * 43.1, size.width)
            let riseSpeed = 15.0 + fmod(seed * 7.3, 20.0)
            let y = size.height - fmod(time * riseSpeed + seed * 29.3, Double(size.height + 20)) + 10
            let radius: CGFloat = CGFloat(2.0 + fmod(seed * 2.1, 4.0))

            let bubble = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.stroke(bubble, with: .color(Color.white.opacity(0.1)), lineWidth: 0.8)
        }
    }

    // MARK: - Space

    private func drawSpaceBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Twinkling stars
        for i in 0..<40 {
            let seed = Double(i) * 67.3
            let x = fmod(seed * 53.7, size.width)
            let y = fmod(seed * 31.3, size.height)
            let twinkle = sin(time * (1.5 + fmod(seed * 0.1, 2.0)) + seed) * 0.5 + 0.5
            let radius: CGFloat = CGFloat(0.8 + fmod(seed * 1.3, 1.5))
            let opacity = 0.1 + twinkle * 0.2

            let star = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(star, with: .color(Color.white.opacity(opacity)))
        }

        // Shooting star
        let shootIdx = Int(time * 0.15) % 5
        let shootSeed = Double(shootIdx) * 193.7
        let progress = fmod(time * 0.8 + shootSeed, 3.0) / 3.0
        if progress < 1.0 {
            let startX = fmod(shootSeed * 37.1, size.width * 0.6) + size.width * 0.2
            let startY = fmod(shootSeed * 19.3, size.height * 0.3)
            let endX = startX + 80
            let endY = startY + 50
            let cx = startX + (endX - startX) * progress
            let cy = startY + (endY - startY) * progress
            let tailLen: CGFloat = 30

            var trail = Path()
            trail.move(to: CGPoint(x: cx, y: cy))
            trail.addLine(to: CGPoint(x: cx - tailLen, y: cy - tailLen * 0.6))
            ctx.stroke(trail, with: .color(Color.white.opacity(0.15 * (1 - progress))), lineWidth: 1)
            let dot = Path(ellipseIn: CGRect(x: cx - 1.5, y: cy - 1.5, width: 3, height: 3))
            ctx.fill(dot, with: .color(Color.white.opacity(0.3 * (1 - progress))))
        }
    }

    // MARK: - Cherry Blossom

    private func drawCherryBlossomBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let pink = Color(red: 1.0, green: 0.65, blue: 0.75)

        for i in 0..<15 {
            let seed = Double(i) * 113.7
            let baseX = fmod(seed * 37.1, size.width)
            let fallSpeed = 20.0 + fmod(seed * 11.3, 25.0)
            let y = fmod(time * fallSpeed + seed * 53.7, Double(size.height + 40)) - 20
            let drift = sin(time * 0.4 + seed) * 30
            let x = baseX + drift
            let rotation = time * 0.5 + seed

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)

                // Petal shape
                var petal = Path()
                petal.move(to: .zero)
                petal.addQuadCurve(to: CGPoint(x: 0, y: 8), control: CGPoint(x: 5, y: 4))
                petal.addQuadCurve(to: .zero, control: CGPoint(x: -3, y: 4))
                layerCtx.fill(petal.applying(transform), with: .color(pink.opacity(0.12)))
            }
        }
    }

    // MARK: - Retro Game

    private func drawRetroBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let green = Color(red: 0.1, green: 0.95, blue: 0.4)

        // Scrolling grid
        let gridSpacing: CGFloat = 40
        let scrollOffset = fmod(time * 15, Double(gridSpacing))

        for x in stride(from: -gridSpacing, through: size.width + gridSpacing, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: x, y: 0))
            line.addLine(to: CGPoint(x: x, y: size.height))
            ctx.stroke(line, with: .color(green.opacity(0.03)), lineWidth: 0.5)
        }
        for y in stride(from: -gridSpacing + CGFloat(scrollOffset), through: size.height + gridSpacing, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: 0, y: y))
            line.addLine(to: CGPoint(x: size.width, y: y))
            ctx.stroke(line, with: .color(green.opacity(0.03)), lineWidth: 0.5)
        }

        // Floating pixel blocks
        for i in 0..<6 {
            let seed = Double(i) * 79.3
            let x = fmod(seed * 41.7, size.width)
            let speed = 10.0 + fmod(seed * 13.1, 20.0)
            let y = size.height - fmod(time * speed + seed * 37.3, Double(size.height + 30)) + 15
            let blockSize: CGFloat = CGFloat(4 + i % 3 * 2)

            let block = Path(CGRect(x: x, y: y, width: blockSize, height: blockSize))
            ctx.fill(block, with: .color(green.opacity(0.08)))
        }
    }

    // MARK: - Autumn

    private func drawAutumnBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let colors: [Color] = [
            Color(red: 0.85, green: 0.45, blue: 0.15),
            Color(red: 0.80, green: 0.30, blue: 0.10),
            Color(red: 0.90, green: 0.65, blue: 0.20),
        ]

        for i in 0..<12 {
            let seed = Double(i) * 127.3
            let baseX = fmod(seed * 29.7, size.width)
            let fallSpeed = 18.0 + fmod(seed * 9.7, 22.0)
            let y = fmod(time * fallSpeed + seed * 41.3, Double(size.height + 30)) - 15
            let drift = sin(time * 0.3 + seed) * 25
            let x = baseX + drift
            let rotation = time * 0.4 + seed
            let color = colors[i % 3]

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)

                // Leaf shape
                var leaf = Path()
                leaf.move(to: CGPoint(x: 0, y: -6))
                leaf.addQuadCurve(to: CGPoint(x: 0, y: 6), control: CGPoint(x: 7, y: 0))
                leaf.addQuadCurve(to: CGPoint(x: 0, y: -6), control: CGPoint(x: -7, y: 0))
                layerCtx.fill(leaf.applying(transform), with: .color(color.opacity(0.1)))
            }
        }
    }

    // MARK: - Aurora

    private func drawAuroraBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Aurora wave bands
        let colors: [(Color, Double)] = [
            (Color(red: 0.1, green: 0.9, blue: 0.5), 0.06),
            (Color(red: 0.3, green: 0.5, blue: 0.9), 0.05),
            (Color(red: 0.7, green: 0.2, blue: 0.8), 0.04),
        ]

        for (idx, (color, opacity)) in colors.enumerated() {
            let baseY = size.height * (0.2 + CGFloat(idx) * 0.15)
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 3) {
                let wave1 = sin(Double(x) * 0.008 + time * 0.3 + Double(idx) * 2.0) * 40
                let wave2 = sin(Double(x) * 0.015 + time * 0.5 + Double(idx) * 1.5) * 20
                let y = baseY + wave1 + wave2
                if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            // Close to fill
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(color.opacity(opacity)))
        }

        // Stars
        for i in 0..<20 {
            let seed = Double(i) * 71.3
            let x = fmod(seed * 47.1, size.width)
            let y = fmod(seed * 23.7, size.height * 0.5)
            let twinkle = sin(time * 2.0 + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(0.8 + fmod(seed, 1.0))
            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.08 + twinkle * 0.12)))
        }
    }

    // MARK: - Circus

    private func drawCircusBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Confetti
        let confettiColors: [Color] = [.red, .yellow, .blue, .green, .orange, .pink]

        for i in 0..<18 {
            let seed = Double(i) * 103.7
            let x = fmod(seed * 33.1, size.width)
            let fallSpeed = 22.0 + fmod(seed * 7.7, 18.0)
            let y = fmod(time * fallSpeed + seed * 59.3, Double(size.height + 20)) - 10
            let rotation = time * 1.5 + seed
            let color = confettiColors[i % confettiColors.count]
            let w: CGFloat = CGFloat(3 + i % 3)
            let h: CGFloat = CGFloat(5 + i % 4)

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)
                let rect = Path(CGRect(x: -w / 2, y: -h / 2, width: w, height: h))
                layerCtx.fill(rect.applying(transform), with: .color(color.opacity(0.1)))
            }
        }
    }

    // MARK: - Desert

    private func drawDesertBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Drifting sand particles
        for i in 0..<15 {
            let seed = Double(i) * 89.3
            let baseY = fmod(seed * 37.7, size.height)
            let speed = 8.0 + fmod(seed * 5.3, 15.0)
            let x = fmod(time * speed + seed * 43.1, Double(size.width + 20)) - 10
            let drift = sin(time * 0.4 + seed) * 8
            let y = baseY + drift
            let r: CGFloat = CGFloat(1.0 + fmod(seed * 1.7, 1.5))

            let grain = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(grain, with: .color(Color(red: 0.9, green: 0.75, blue: 0.35).opacity(0.08)))
        }

        // Twinkling stars (desert night)
        for i in 0..<25 {
            let seed = Double(i) * 61.7
            let x = fmod(seed * 51.3, size.width)
            let y = fmod(seed * 27.1, size.height * 0.5)
            let twinkle = sin(time * (1.2 + fmod(seed * 0.07, 1.5)) + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(0.6 + fmod(seed * 0.9, 1.2))

            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.06 + twinkle * 0.1)))
        }
    }
}
