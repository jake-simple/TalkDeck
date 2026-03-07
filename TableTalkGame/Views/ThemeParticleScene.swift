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

        case .forsythia:
            drawForsythiaBG(ctx: ctx, size: size, time: time)

        case .candy:
            drawCandyBG(ctx: ctx, size: size, time: time)

        case .zenGarden:
            drawZenGardenBG(ctx: ctx, size: size, time: time)
        }
    }

    // MARK: - Halloween

    private func drawHalloweenBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // Floating glowing orbs
        for i in 0..<10 {
            let seed = Double(i) * 137.5
            let x = (sin(time * 0.3 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 10.0 * size.height
            let y = baseY + sin(time * 0.5 + seed * 0.7) * 40
            let radius: CGFloat = CGFloat(15 + (i % 3) * 8)
            let opacity = 0.12 + sin(time * 0.8 + seed) * 0.05

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(Color.orange.opacity(opacity)))

            let glowR = radius * 2.5
            let glow = Path(ellipseIn: CGRect(x: x - glowR, y: y - glowR, width: glowR * 2, height: glowR * 2))
            ctx.fill(glow, with: .color(Color.orange.opacity(opacity * 0.3)))
        }

        // 박쥐 실루엣
        for i in 0..<5 {
            let seed = Double(i) * 211.3
            let x = fmod(seed * 37.1 + sin(time * 0.4 + seed) * 60, size.width)
            let y = fmod(seed * 19.7, size.height * 0.6) + sin(time * 0.6 + seed) * 30
            let wingFlap = sin(time * 4.0 + seed) * 0.3
            let scale: CGFloat = CGFloat(1.5 + fmod(seed * 0.3, 1.0))

            ctx.drawLayer { batCtx in
                batCtx.opacity = 0.12
                let body = Path(ellipseIn: CGRect(x: x - 5 * scale, y: y - 3 * scale, width: 10 * scale, height: 6 * scale))
                batCtx.fill(body, with: .color(.white))
                var leftWing = Path()
                leftWing.move(to: CGPoint(x: x - 5 * scale, y: y))
                leftWing.addQuadCurve(to: CGPoint(x: x - 25 * scale, y: y - 8 * scale), control: CGPoint(x: x - 14 * scale, y: y - 16 * scale + wingFlap * 20))
                leftWing.addLine(to: CGPoint(x: x - 5 * scale, y: y + 2 * scale))
                batCtx.fill(leftWing, with: .color(.white))
                var rightWing = Path()
                rightWing.move(to: CGPoint(x: x + 5 * scale, y: y))
                rightWing.addQuadCurve(to: CGPoint(x: x + 25 * scale, y: y - 8 * scale), control: CGPoint(x: x + 14 * scale, y: y - 16 * scale + wingFlap * 20))
                rightWing.addLine(to: CGPoint(x: x + 5 * scale, y: y + 2 * scale))
                batCtx.fill(rightWing, with: .color(.white))
            }
        }
    }

    // MARK: - Christmas (Snowfall)

    private func drawSnowfallBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // 큰 눈송이 결정
        for i in 0..<10 {
            let seed = Double(i) * 73.1
            let x = fmod(seed * 31.7 + sin(time * 0.12 + seed) * 70, size.width)
            let fallSpeed = 10.0 + fmod(seed * 11.3, 15.0)
            let y = fmod(time * fallSpeed + seed * 47.1, Double(size.height + 60)) - 30
            let radius: CGFloat = CGFloat(10 + fmod(seed * 2.3, 12))
            let opacity = 0.25 + fmod(seed * 0.11, 0.15)
            let rotation = time * 0.2 + seed

            ctx.drawLayer { flakeCtx in
                flakeCtx.opacity = opacity
                for arm in 0..<6 {
                    let angle = CGFloat(arm) * .pi / 3 + CGFloat(rotation)
                    let endX = x + cos(angle) * radius
                    let endY = y + sin(angle) * radius
                    var armPath = Path()
                    armPath.move(to: CGPoint(x: x, y: y))
                    armPath.addLine(to: CGPoint(x: endX, y: endY))
                    flakeCtx.stroke(armPath, with: .color(.white), lineWidth: 1.8)

                    let midX = x + cos(angle) * radius * 0.55
                    let midY = y + sin(angle) * radius * 0.55
                    for sign: CGFloat in [-1, 1] {
                        let bAngle = angle + sign * .pi / 5
                        let branchLen = radius * 0.4
                        var branch = Path()
                        branch.move(to: CGPoint(x: midX, y: midY))
                        branch.addLine(to: CGPoint(x: midX + cos(bAngle) * branchLen, y: midY + sin(bAngle) * branchLen))
                        flakeCtx.stroke(branch, with: .color(.white), lineWidth: 1.0)
                    }
                }
                let center = Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
                flakeCtx.fill(center, with: .color(.white))
            }
        }

        // 중간 눈 입자
        for i in 0..<20 {
            let seed = Double(i) * 97.3
            let x = fmod(seed * 41.7 + sin(time * 0.2 + seed) * 40, size.width)
            let fallSpeed = 20.0 + fmod(seed * 17.3, 30.0)
            let y = fmod(time * fallSpeed + seed * 53.1, Double(size.height + 20)) - 10
            let radius: CGFloat = CGFloat(3 + fmod(seed * 3.7, 5))
            let opacity = 0.18 + fmod(seed * 0.13, 0.12)

            let flake = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(flake, with: .color(Color.white.opacity(opacity)))
        }

        // 반짝이는 별
        for i in 0..<6 {
            let seed = Double(i) * 137.5
            let x = fmod(seed * 23.1, size.width)
            let y = fmod(seed * 51.7, size.height)
            let twinkle = (sin(time * 2.0 + seed * 3.1) + 1) * 0.5
            let starSize: CGFloat = CGFloat(4 + twinkle * 5)
            let opacity = 0.15 + twinkle * 0.25

            var star = Path()
            star.move(to: CGPoint(x: x - starSize, y: y))
            star.addLine(to: CGPoint(x: x + starSize, y: y))
            star.move(to: CGPoint(x: x, y: y - starSize))
            star.addLine(to: CGPoint(x: x, y: y + starSize))
            ctx.stroke(star, with: .color(Color(red: 1.0, green: 0.95, blue: 0.7).opacity(opacity)), lineWidth: 1.2)
        }
    }

    // MARK: - Ocean

    private func drawOceanBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let cyan = Color(red: 0.2, green: 0.7, blue: 0.9)

        // 빛줄기 (수면 반사)
        for i in 0..<5 {
            let seed = Double(i) * 97.1
            let x = fmod(seed * 61.3, size.width)
            let sway = sin(time * 0.2 + seed) * 20
            let opacity = 0.04 + sin(time * 0.4 + seed) * 0.02

            var ray = Path()
            ray.move(to: CGPoint(x: x + sway - 10, y: 0))
            ray.addLine(to: CGPoint(x: x + sway + 10, y: 0))
            ray.addLine(to: CGPoint(x: x + sway + 40, y: size.height * 0.6))
            ray.addLine(to: CGPoint(x: x + sway - 20, y: size.height * 0.6))
            ray.closeSubpath()
            ctx.fill(ray, with: .color(Color.white.opacity(max(0, opacity))))
        }

        // 파도
        for w in 0..<4 {
            let waveY = size.height * (0.25 + CGFloat(w) * 0.18)
            let opacity = 0.08 - Double(w) * 0.012
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 3) {
                let y = waveY + sin(Double(x) * 0.01 + time * 0.5 + Double(w) * 1.2) * 25
                    + cos(Double(x) * 0.018 + time * 0.3 + Double(w)) * 12
                if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            ctx.stroke(path, with: .color(cyan.opacity(opacity)), lineWidth: 2.5)
        }

        // 버블
        for i in 0..<12 {
            let seed = Double(i) * 83.7
            let x = fmod(seed * 43.1, size.width) + sin(time * 0.3 + seed) * 15
            let riseSpeed = 10.0 + fmod(seed * 7.3, 18.0)
            let y = size.height - fmod(time * riseSpeed + seed * 29.3, Double(size.height + 30)) + 15
            let radius: CGFloat = CGFloat(5 + fmod(seed * 2.1, 10))

            let bubble = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.stroke(bubble, with: .color(Color.white.opacity(0.18)), lineWidth: 1.2)
            let highlight = Path(ellipseIn: CGRect(x: x - radius * 0.3, y: y - radius * 0.6, width: radius * 0.5, height: radius * 0.4))
            ctx.fill(highlight, with: .color(Color.white.opacity(0.12)))
        }

        // 물고기
        for i in 0..<3 {
            let seed = Double(i) * 173.7
            let speed = 15.0 + fmod(seed * 5.1, 12.0)
            let x = fmod(time * speed + seed * 31.1, Double(size.width + 60)) - 30
            let y = fmod(seed * 47.3, size.height * 0.5) + size.height * 0.35 + sin(time * 0.5 + seed) * 20
            let s: CGFloat = CGFloat(1.5 + fmod(seed * 0.3, 1.0))

            ctx.drawLayer { fishCtx in
                fishCtx.opacity = 0.12
                let body = Path(ellipseIn: CGRect(x: x - 10 * s, y: y - 5 * s, width: 20 * s, height: 10 * s))
                fishCtx.fill(body, with: .color(cyan))
                var tail = Path()
                tail.move(to: CGPoint(x: x - 10 * s, y: y))
                tail.addLine(to: CGPoint(x: x - 18 * s, y: y - 7 * s))
                tail.addLine(to: CGPoint(x: x - 18 * s, y: y + 7 * s))
                tail.closeSubpath()
                fishCtx.fill(tail, with: .color(cyan))
            }
        }
    }

    // MARK: - Space

    private func drawSpaceBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // 별
        for i in 0..<35 {
            let seed = Double(i) * 67.3
            let x = fmod(seed * 53.7, size.width)
            let y = fmod(seed * 31.3, size.height)
            let twinkle = sin(time * (1.5 + fmod(seed * 0.1, 2.0)) + seed) * 0.5 + 0.5
            let radius: CGFloat = CGFloat(1.5 + fmod(seed * 1.3, 2.5))
            let opacity = 0.15 + twinkle * 0.25

            let star = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(star, with: .color(Color.white.opacity(opacity)))

            // 큰 별은 십자 반짝임
            if i < 8 {
                let sparkSize = radius + CGFloat(twinkle) * 4
                var spark = Path()
                spark.move(to: CGPoint(x: x - sparkSize, y: y))
                spark.addLine(to: CGPoint(x: x + sparkSize, y: y))
                spark.move(to: CGPoint(x: x, y: y - sparkSize))
                spark.addLine(to: CGPoint(x: x, y: y + sparkSize))
                ctx.stroke(spark, with: .color(Color.white.opacity(opacity * 0.5)), lineWidth: 0.8)
            }
        }

        // 성운 글로우
        let nebulaPositions: [(CGFloat, CGFloat, Color)] = [
            (size.width * 0.3, size.height * 0.25, Color(red: 0.4, green: 0.2, blue: 0.8)),
            (size.width * 0.7, size.height * 0.6, Color(red: 0.2, green: 0.3, blue: 0.9)),
        ]
        for (nx, ny, color) in nebulaPositions {
            let pulse = sin(time * 0.2) * 10
            let r: CGFloat = 60 + CGFloat(pulse)
            let nebula = Path(ellipseIn: CGRect(x: nx - r, y: ny - r * 0.7, width: r * 2, height: r * 1.4))
            ctx.fill(nebula, with: .color(color.opacity(0.04)))
        }

        // 유성
        let shootIdx = Int(time * 0.15) % 5
        let shootSeed = Double(shootIdx) * 193.7
        let progress = fmod(time * 0.8 + shootSeed, 3.0) / 3.0
        if progress < 1.0 {
            let startX = fmod(shootSeed * 37.1, size.width * 0.6) + size.width * 0.2
            let startY = fmod(shootSeed * 19.3, size.height * 0.3)
            let endX = startX + 120
            let endY = startY + 80
            let cx = startX + (endX - startX) * progress
            let cy = startY + (endY - startY) * progress
            let tailLen: CGFloat = 50

            var trail = Path()
            trail.move(to: CGPoint(x: cx, y: cy))
            trail.addLine(to: CGPoint(x: cx - tailLen, y: cy - tailLen * 0.6))
            ctx.stroke(trail, with: .color(Color.white.opacity(0.25 * (1 - progress))), lineWidth: 1.5)
            let dot = Path(ellipseIn: CGRect(x: cx - 3, y: cy - 3, width: 6, height: 6))
            ctx.fill(dot, with: .color(Color.white.opacity(0.4 * (1 - progress))))
        }
    }

    // MARK: - Cherry Blossom

    private func drawCherryBlossomBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let pink = Color(red: 1.0, green: 0.65, blue: 0.75)
        let lightPink = Color(red: 1.0, green: 0.80, blue: 0.85)

        for i in 0..<15 {
            let seed = Double(i) * 113.7
            let baseX = fmod(seed * 37.1, size.width)
            let fallSpeed = 12.0 + fmod(seed * 11.3, 20.0)
            let y = fmod(time * fallSpeed + seed * 53.7, Double(size.height + 50)) - 25
            let drift = sin(time * 0.3 + seed) * 45 + cos(time * 0.18 + seed * 0.7) * 20
            let x = baseX + drift
            let rotation = time * 0.35 + seed
            let scale = 1.5 + fmod(seed * 0.3, 1.5)
            let color = i % 3 == 0 ? lightPink : pink

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.18 + fmod(seed * 0.03, 0.1)
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)
                    .scaledBy(x: scale, y: scale)

                var petal = Path()
                petal.move(to: .zero)
                petal.addQuadCurve(to: CGPoint(x: 0, y: 10), control: CGPoint(x: 6, y: 5))
                petal.addQuadCurve(to: .zero, control: CGPoint(x: -4, y: 5))
                layerCtx.fill(petal.applying(transform), with: .color(color))
            }
        }

        // 흩날리는 꽃잎 조각
        for i in 0..<6 {
            let seed = Double(i) * 179.3
            let x = fmod(seed * 47.1 + time * 10, size.width + 20) - 10
            let y = fmod(seed * 29.3, size.height * 0.5) + sin(time * 0.5 + seed) * 25
            let r: CGFloat = CGFloat(4 + fmod(seed * 1.1, 4))

            let dot = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(dot, with: .color(pink.opacity(0.12)))
        }
    }

    // MARK: - Retro Game

    private func drawRetroBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let green = Color(red: 0.1, green: 0.95, blue: 0.4)

        let gridSpacing: CGFloat = 40
        let scrollOffset = fmod(time * 15, Double(gridSpacing))

        for x in stride(from: -gridSpacing, through: size.width + gridSpacing, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: x, y: 0))
            line.addLine(to: CGPoint(x: x, y: size.height))
            ctx.stroke(line, with: .color(green.opacity(0.06)), lineWidth: 0.8)
        }
        for y in stride(from: -gridSpacing + CGFloat(scrollOffset), through: size.height + gridSpacing, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: 0, y: y))
            line.addLine(to: CGPoint(x: size.width, y: y))
            ctx.stroke(line, with: .color(green.opacity(0.06)), lineWidth: 0.8)
        }

        // 픽셀 블록
        for i in 0..<8 {
            let seed = Double(i) * 79.3
            let x = fmod(seed * 41.7, size.width)
            let speed = 10.0 + fmod(seed * 13.1, 20.0)
            let y = size.height - fmod(time * speed + seed * 37.3, Double(size.height + 30)) + 15
            let blockSize: CGFloat = CGFloat(8 + i % 3 * 4)

            let block = Path(CGRect(x: x, y: y, width: blockSize, height: blockSize))
            ctx.fill(block, with: .color(green.opacity(0.14)))
        }

        // 깜빡이는 커서
        let cursorOn = sin(time * 3) > 0
        if cursorOn {
            let cursorRect = Path(CGRect(x: size.width * 0.1, y: size.height * 0.85, width: 12, height: 3))
            ctx.fill(cursorRect, with: .color(green.opacity(0.2)))
        }
    }

    // MARK: - Autumn

    private func drawAutumnBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let colors: [Color] = [
            Color(red: 0.85, green: 0.45, blue: 0.15),
            Color(red: 0.80, green: 0.30, blue: 0.10),
            Color(red: 0.90, green: 0.65, blue: 0.20),
            Color(red: 0.75, green: 0.25, blue: 0.15),
        ]

        for i in 0..<12 {
            let seed = Double(i) * 127.3
            let baseX = fmod(seed * 29.7, size.width)
            let fallSpeed = 10.0 + fmod(seed * 9.7, 18.0)
            let y = fmod(time * fallSpeed + seed * 41.3, Double(size.height + 40)) - 20
            let drift = sin(time * 0.2 + seed) * 40 + cos(time * 0.12 + seed * 0.5) * 20
            let x = baseX + drift
            let rotation = time * 0.3 + seed
            let color = colors[i % colors.count]
            let scale = 1.5 + fmod(seed * 0.2, 1.2)

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.2
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)
                    .scaledBy(x: scale, y: scale)

                if i % 3 == 0 {
                    // 단풍잎
                    var maple = Path()
                    for arm in 0..<5 {
                        let angle = CGFloat(arm) * .pi * 2 / 5 - .pi / 2
                        let tipX = cos(angle) * 8
                        let tipY = sin(angle) * 8
                        if arm == 0 { maple.move(to: CGPoint(x: tipX, y: tipY)) }
                        else { maple.addLine(to: CGPoint(x: tipX, y: tipY)) }
                        let innerAngle = angle + .pi / 5
                        maple.addLine(to: CGPoint(x: cos(innerAngle) * 3.5, y: sin(innerAngle) * 3.5))
                    }
                    maple.closeSubpath()
                    layerCtx.fill(maple.applying(transform), with: .color(color))
                } else {
                    var leaf = Path()
                    leaf.move(to: CGPoint(x: 0, y: -8))
                    leaf.addQuadCurve(to: CGPoint(x: 0, y: 8), control: CGPoint(x: 9, y: 0))
                    leaf.addQuadCurve(to: CGPoint(x: 0, y: -8), control: CGPoint(x: -9, y: 0))
                    layerCtx.fill(leaf.applying(transform), with: .color(color))
                }
            }
        }

        // 따뜻한 빛
        for i in 0..<4 {
            let seed = Double(i) * 193.7
            let x = fmod(seed * 31.1, size.width)
            let y = fmod(seed * 47.3, size.height * 0.4) + size.height * 0.1
            let r: CGFloat = CGFloat(50 + fmod(seed * 7.1, 40))
            let pulse = sin(time * 0.3 + seed) * 0.015

            let glow = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(glow, with: .color(Color(red: 0.95, green: 0.75, blue: 0.3).opacity(0.04 + pulse)))
        }
    }

    // MARK: - Aurora

    private func drawAuroraBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let colors: [(Color, Double)] = [
            (Color(red: 0.1, green: 0.9, blue: 0.5), 0.1),
            (Color(red: 0.3, green: 0.5, blue: 0.9), 0.08),
            (Color(red: 0.7, green: 0.2, blue: 0.8), 0.06),
        ]

        for (idx, (color, opacity)) in colors.enumerated() {
            let baseY = size.height * (0.15 + CGFloat(idx) * 0.15)
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 3) {
                let wave1 = sin(Double(x) * 0.008 + time * 0.3 + Double(idx) * 2.0) * 50
                let wave2 = sin(Double(x) * 0.015 + time * 0.5 + Double(idx) * 1.5) * 25
                let y = baseY + wave1 + wave2
                if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(color.opacity(opacity)))
        }

        // 별
        for i in 0..<20 {
            let seed = Double(i) * 71.3
            let x = fmod(seed * 47.1, size.width)
            let y = fmod(seed * 23.7, size.height * 0.4)
            let twinkle = sin(time * 2.0 + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(1.5 + fmod(seed, 2.0))
            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.12 + twinkle * 0.18)))
        }
    }

    // MARK: - Circus

    private func drawCircusBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // 스포트라이트 빔
        for i in 0..<3 {
            let seed = Double(i) * 131.7
            let baseX = size.width * (0.2 + CGFloat(i) * 0.3)
            let sway = sin(time * 0.4 + seed) * 40
            let beamWidth: CGFloat = 80

            var beam = Path()
            beam.move(to: CGPoint(x: baseX + sway - 8, y: 0))
            beam.addLine(to: CGPoint(x: baseX + sway + 8, y: 0))
            beam.addLine(to: CGPoint(x: baseX + sway + beamWidth, y: size.height))
            beam.addLine(to: CGPoint(x: baseX + sway - beamWidth, y: size.height))
            beam.closeSubpath()

            let beamColor: Color = [Color.yellow, Color.white, Color.red][i]
            ctx.fill(beam, with: .color(beamColor.opacity(0.025)))
        }

        // 컨페티
        let confettiColors: [Color] = [.red, .yellow, .blue, .green, .orange, .pink]

        for i in 0..<18 {
            let seed = Double(i) * 103.7
            let x = fmod(seed * 33.1, size.width)
            let fallSpeed = 15.0 + fmod(seed * 7.7, 20.0)
            let y = fmod(time * fallSpeed + seed * 59.3, Double(size.height + 20)) - 10
            let rotation = time * 1.5 + seed
            let color = confettiColors[i % confettiColors.count]

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)

                if i % 3 == 0 {
                    let starSize: CGFloat = CGFloat(6 + i % 4)
                    var star = Path()
                    for arm in 0..<5 {
                        let angle = CGFloat(arm) * .pi * 2 / 5 - .pi / 2
                        let px = cos(angle) * starSize
                        let py = sin(angle) * starSize
                        if arm == 0 { star.move(to: CGPoint(x: px, y: py)) }
                        else { star.addLine(to: CGPoint(x: px, y: py)) }
                        let innerAngle = angle + .pi / 5
                        star.addLine(to: CGPoint(x: cos(innerAngle) * starSize * 0.4, y: sin(innerAngle) * starSize * 0.4))
                    }
                    star.closeSubpath()
                    layerCtx.fill(star.applying(transform), with: .color(color.opacity(0.2)))
                } else if i % 3 == 1 {
                    let r: CGFloat = CGFloat(4 + i % 4)
                    let circle = Path(ellipseIn: CGRect(x: -r, y: -r, width: r * 2, height: r * 2))
                    layerCtx.fill(circle.applying(transform), with: .color(color.opacity(0.18)))
                } else {
                    let w: CGFloat = CGFloat(5 + i % 4)
                    let h: CGFloat = CGFloat(8 + i % 5)
                    let rect = Path(CGRect(x: -w / 2, y: -h / 2, width: w, height: h))
                    layerCtx.fill(rect.applying(transform), with: .color(color.opacity(0.18)))
                }
            }
        }
    }

    // MARK: - Forsythia

    private func drawForsythiaBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let yellow = Color(red: 0.98, green: 0.85, blue: 0.08)
        let darkYellow = Color(red: 0.85, green: 0.65, blue: 0.08)

        // 꽃잎
        for i in 0..<14 {
            let seed = Double(i) * 109.3
            let baseX = fmod(seed * 33.7, size.width)
            let fallSpeed = 12.0 + fmod(seed * 8.7, 16.0)
            let y = fmod(time * fallSpeed + seed * 47.1, Double(size.height + 40)) - 20
            let drift = sin(time * 0.3 + seed) * 35
            let x = baseX + drift
            let rotation = time * 0.35 + seed

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)
                var petal = Path()
                petal.addEllipse(in: CGRect(x: -8, y: -5, width: 16, height: 10))
                layerCtx.fill(petal.applying(transform), with: .color(yellow.opacity(0.22)))
            }
        }

        // 데이지 꽃
        for i in 0..<5 {
            let seed = Double(i) * 193.7
            let x = fmod(seed * 29.3, size.width)
            let floatSpeed = 6.0 + fmod(seed * 5.1, 8.0)
            let y = size.height - fmod(time * floatSpeed + seed * 37.1, Double(size.height + 50)) + 25
            let driftX = sin(time * 0.2 + seed) * 20
            let cx = x + driftX
            let petalR: CGFloat = 10

            for p in 0..<6 {
                let angle = CGFloat(p) * .pi / 3 + CGFloat(time * 0.25 + seed)
                let px = cx + cos(angle) * petalR
                let py = y + sin(angle) * petalR
                let petal = Path(ellipseIn: CGRect(x: px - 5, y: py - 3, width: 10, height: 6))
                ctx.fill(petal, with: .color(yellow.opacity(0.18)))
            }
            let center = Path(ellipseIn: CGRect(x: cx - 4, y: y - 4, width: 8, height: 8))
            ctx.fill(center, with: .color(darkYellow.opacity(0.18)))
        }

        // 빛 점
        for i in 0..<6 {
            let seed = Double(i) * 157.3
            let x = (sin(time * 0.2 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 6.0 * size.height
            let y = baseY + sin(time * 0.4 + seed * 0.6) * 25
            let radius: CGFloat = CGFloat(18 + (i % 3) * 10)
            let opacity = 0.08 + sin(time * 0.6 + seed) * 0.04

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(yellow.opacity(max(0, opacity))))
        }
    }

    // MARK: - Candy

    private func drawCandyBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let candyColors: [Color] = [
            Color(red: 0.95, green: 0.35, blue: 0.55),
            Color(red: 0.55, green: 0.85, blue: 0.75),
            Color(red: 0.98, green: 0.80, blue: 0.25),
            Color(red: 0.65, green: 0.50, blue: 0.90),
            Color(red: 0.95, green: 0.55, blue: 0.35),
        ]

        // 롤리팝 & 사탕
        for i in 0..<8 {
            let seed = Double(i) * 127.3
            let x = fmod(seed * 41.1, size.width) + sin(time * 0.25 + seed) * 25
            let floatSpeed = 8.0 + fmod(seed * 6.3, 12.0)
            let y = size.height - fmod(time * floatSpeed + seed * 43.7, Double(size.height + 50)) + 25
            let color = candyColors[i % candyColors.count]
            let rotation = time * 0.25 + seed

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.16

                if i % 2 == 0 {
                    let lolliR: CGFloat = CGFloat(12 + i % 3 * 4)
                    let circle = Path(ellipseIn: CGRect(x: x - lolliR, y: y - lolliR, width: lolliR * 2, height: lolliR * 2))
                    layerCtx.fill(circle, with: .color(color))
                    var spiral = Path()
                    spiral.addArc(center: CGPoint(x: x, y: y), radius: lolliR * 0.5, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: false)
                    layerCtx.stroke(spiral, with: .color(.white), lineWidth: 1.5)
                    var stick = Path()
                    stick.move(to: CGPoint(x: x, y: y + lolliR))
                    stick.addLine(to: CGPoint(x: x, y: y + lolliR + 20))
                    layerCtx.stroke(stick, with: .color(Color.brown.opacity(0.5)), lineWidth: 2)
                } else {
                    let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)
                    let candy = Path(ellipseIn: CGRect(x: -10, y: -6, width: 20, height: 12))
                    layerCtx.fill(candy.applying(transform), with: .color(color))
                }
            }
        }

        // 반짝이
        for i in 0..<8 {
            let seed = Double(i) * 89.1
            let x = fmod(seed * 47.3, size.width)
            let y = fmod(seed * 31.7, size.height)
            let twinkle = (sin(time * 2.5 + seed * 2.1) + 1) * 0.5
            let starSize: CGFloat = CGFloat(3 + twinkle * 4)
            let color = candyColors[i % candyColors.count]

            var star = Path()
            star.move(to: CGPoint(x: x - starSize, y: y))
            star.addLine(to: CGPoint(x: x + starSize, y: y))
            star.move(to: CGPoint(x: x, y: y - starSize))
            star.addLine(to: CGPoint(x: x, y: y + starSize))
            ctx.stroke(star, with: .color(color.opacity(0.15 + twinkle * 0.15)), lineWidth: 1.2)
        }
    }

    // MARK: - Zen Garden

    private func drawZenGardenBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let stone = Color(red: 0.45, green: 0.48, blue: 0.42)

        // 모래 파문
        let centers: [(CGFloat, CGFloat)] = [
            (size.width * 0.3, size.height * 0.3),
            (size.width * 0.7, size.height * 0.65),
        ]
        for (cx, cy) in centers {
            for ring in 0..<6 {
                let baseR: CGFloat = CGFloat(30 + ring * 25)
                let ripple = sin(time * 0.25 - Double(ring) * 0.4) * 4
                let r = baseR + CGFloat(ripple)
                let circle = Path(ellipseIn: CGRect(x: cx - r, y: cy - r * 0.6, width: r * 2, height: r * 1.2))
                ctx.stroke(circle, with: .color(stone.opacity(0.07 - Double(ring) * 0.008)), lineWidth: 1.0)
            }
        }

        // 나뭇잎
        let leafX = size.width * 0.6 + sin(time * 0.12) * 40
        let leafY = size.height * 0.2 + cos(time * 0.08) * 15
        let leafRotation = time * 0.08

        ctx.drawLayer { leafCtx in
            leafCtx.opacity = 0.12
            let transform = CGAffineTransform(translationX: leafX, y: leafY).rotated(by: leafRotation)
            var leaf = Path()
            leaf.move(to: CGPoint(x: 0, y: -14))
            leaf.addQuadCurve(to: CGPoint(x: 0, y: 14), control: CGPoint(x: 14, y: 0))
            leaf.addQuadCurve(to: CGPoint(x: 0, y: -14), control: CGPoint(x: -14, y: 0))
            leafCtx.fill(leaf.applying(transform), with: .color(Color(red: 0.4, green: 0.55, blue: 0.35)))
        }

        // 안개
        for i in 0..<5 {
            let seed = Double(i) * 151.3
            let x = fmod(seed * 37.1 + time * 2, size.width)
            let y = fmod(seed * 53.7, size.height)
            let r: CGFloat = CGFloat(35 + fmod(seed * 3.1, 30))
            let opacity = 0.03 + sin(time * 0.3 + seed) * 0.015

            let mist = Path(ellipseIn: CGRect(x: x - r, y: y - r * 0.5, width: r * 2, height: r))
            ctx.fill(mist, with: .color(Color.white.opacity(max(0, opacity))))
        }
    }

    // MARK: - Desert

    private func drawDesertBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let sand = Color(red: 0.9, green: 0.75, blue: 0.35)

        // 모래 언덕
        for dune in 0..<3 {
            let baseY = size.height * (0.65 + CGFloat(dune) * 0.1)
            let offset = Double(dune) * 50
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height))
            for x in stride(from: 0, through: size.width, by: 3) {
                let y = baseY + sin(Double(x) * 0.007 + offset) * 35 + cos(Double(x) * 0.013 + offset) * 18
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(sand.opacity(0.05 - Double(dune) * 0.012)))
        }

        // 모래 입자
        for i in 0..<15 {
            let seed = Double(i) * 89.3
            let baseY = fmod(seed * 37.7, size.height)
            let speed = 10.0 + fmod(seed * 5.3, 18.0)
            let x = fmod(time * speed + seed * 43.1, Double(size.width + 20)) - 10
            let drift = sin(time * 0.4 + seed) * 10
            let y = baseY + drift
            let r: CGFloat = CGFloat(2 + fmod(seed * 1.7, 3))

            let grain = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(grain, with: .color(sand.opacity(0.12)))
        }

        // 달
        let moonX = size.width * 0.8
        let moonY = size.height * 0.1
        let moonR: CGFloat = 28
        let moon = Path(ellipseIn: CGRect(x: moonX - moonR, y: moonY - moonR, width: moonR * 2, height: moonR * 2))
        ctx.fill(moon, with: .color(Color(red: 0.95, green: 0.90, blue: 0.70).opacity(0.1)))
        let moonGlowR: CGFloat = 55
        let moonGlow = Path(ellipseIn: CGRect(x: moonX - moonGlowR, y: moonY - moonGlowR, width: moonGlowR * 2, height: moonGlowR * 2))
        ctx.fill(moonGlow, with: .color(Color(red: 0.95, green: 0.90, blue: 0.70).opacity(0.04)))

        // 별
        for i in 0..<25 {
            let seed = Double(i) * 61.7
            let x = fmod(seed * 51.3, size.width)
            let y = fmod(seed * 27.1, size.height * 0.45)
            let twinkle = sin(time * (1.2 + fmod(seed * 0.07, 1.5)) + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(1.2 + fmod(seed * 0.9, 2.0))

            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.1 + twinkle * 0.15)))

            if i < 6 {
                let sparkSize: CGFloat = r + CGFloat(twinkle) * 4
                var spark = Path()
                spark.move(to: CGPoint(x: x - sparkSize, y: y))
                spark.addLine(to: CGPoint(x: x + sparkSize, y: y))
                spark.move(to: CGPoint(x: x, y: y - sparkSize))
                spark.addLine(to: CGPoint(x: x, y: y + sparkSize))
                ctx.stroke(spark, with: .color(Color.white.opacity(0.08 + twinkle * 0.12)), lineWidth: 0.8)
            }
        }
    }
}
