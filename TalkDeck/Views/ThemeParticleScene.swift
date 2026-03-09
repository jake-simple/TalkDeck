import SwiftUI
import SpriteKit

// MARK: - Canvas-based Animated Background

struct AnimatedBackgroundView: View {
    let theme: AppTheme
    @State private var time: Double = 0

    var body: some View {
        Group {
            if theme == .rainyDay {
                RainSpriteView()
            } else {
                TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
                    Canvas { ctx, size in
                        let t = timeline.date.timeIntervalSinceReferenceDate
                        drawBackground(ctx: ctx, size: size, time: t, theme: theme)
                    }
                }
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
        case .ocean:
            drawOceanBG(ctx: ctx, size: size, time: time)
        case .neonCyber:
            drawNeonCyberBG(ctx: ctx, size: size, time: time)
        case .korean:
            drawKoreanBG(ctx: ctx, size: size, time: time)
        case .rainyDay:
            break // SpriteKit 기반 RainSpriteView로 대체
        case .lavender:
            drawLavenderBG(ctx: ctx, size: size, time: time)
        }
    }

    // MARK: - Halloween

    private func drawHalloweenBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // 유령의 불꽃 (will-o'-wisps)
        for i in 0..<12 {
            let seed = Double(i) * 137.5
            let x = (sin(time * 0.3 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 12.0 * size.height
            let y = baseY + sin(time * 0.5 + seed * 0.7) * 35
            let radius: CGFloat = CGFloat(8 + (i % 4) * 4)
            let opacity = 0.09 + sin(time * 0.8 + seed) * 0.04

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(Color.orange.opacity(opacity)))
            let glowR = radius * 2.8
            let glow = Path(ellipseIn: CGRect(x: x - glowR, y: y - glowR, width: glowR * 2, height: glowR * 2))
            ctx.fill(glow, with: .color(Color.orange.opacity(opacity * 0.25)))

            // 보라빛 내부 코어
            if i % 3 == 0 {
                let coreR = radius * 0.4
                let core = Path(ellipseIn: CGRect(x: x - coreR, y: y - coreR, width: coreR * 2, height: coreR * 2))
                ctx.fill(core, with: .color(Color.purple.opacity(opacity * 0.5)))
            }
        }

        // 안개
        for i in 0..<3 {
            let seed = Double(i) * 97.3
            let x = size.width * (0.2 + CGFloat(i) * 0.3)
            let y = size.height * (0.7 + CGFloat(i) * 0.08)
            let drift = sin(time * 0.15 + seed) * 30
            let r: CGFloat = 60 + sin(time * 0.2 + seed) * 10
            let mist = Path(ellipseIn: CGRect(x: x + drift - r, y: y - r * 0.3, width: r * 2, height: r * 0.6))
            ctx.fill(mist, with: .color(Color.purple.opacity(0.03)))
        }

    }

    // MARK: - Christmas (Snowfall)

    private func drawSnowfallBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        // 알록달록 파티클 색상
        let colors: [Color] = [
            .white,
            Color(red: 1.0, green: 0.95, blue: 0.7),  // warm yellow
            Color(red: 1.0, green: 0.7, blue: 0.8),    // pink
            Color(red: 0.6, green: 0.8, blue: 1.0),    // light blue
            Color(red: 1.0, green: 0.6, blue: 0.3),    // orange
            Color(red: 0.8, green: 1.0, blue: 0.7),    // light green
            Color(red: 0.85, green: 0.15, blue: 0.15),  // red
        ]

        // 눈송이 결정
        for i in 0..<10 {
            let seed = Double(i) * 73.1
            let x = (Double(i) / 10.0) * size.width + sin(time * 0.12 + seed) * 65
            let fallSpeed = 10.0 + fmod(seed * 11.3, 15.0)
            let y = fmod(time * fallSpeed + seed * 47.1, Double(size.height + 50)) - 25
            let radius: CGFloat = CGFloat(7 + fmod(seed * 2.3, 8))
            let opacity = 0.22 + fmod(seed * 0.11, 0.12)
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
                    flakeCtx.stroke(armPath, with: .color(.white), lineWidth: 1.5)

                    let midX = x + cos(angle) * radius * 0.55
                    let midY = y + sin(angle) * radius * 0.55
                    for sign: CGFloat in [-1, 1] {
                        let bAngle = angle + sign * .pi / 5
                        let branchLen = radius * 0.38
                        var branch = Path()
                        branch.move(to: CGPoint(x: midX, y: midY))
                        branch.addLine(to: CGPoint(x: midX + cos(bAngle) * branchLen, y: midY + sin(bAngle) * branchLen))
                        flakeCtx.stroke(branch, with: .color(.white), lineWidth: 0.9)
                    }
                }
                let center = Path(ellipseIn: CGRect(x: x - 2, y: y - 2, width: 4, height: 4))
                flakeCtx.fill(center, with: .color(.white))
            }
        }

        // 눈 입자
        for i in 0..<20 {
            let seed = Double(i) * 97.3
            let x = (Double(i) / 20.0) * size.width + sin(time * 0.2 + seed) * 35
            let fallSpeed = 20.0 + fmod(seed * 17.3, 28.0)
            let y = fmod(time * fallSpeed + seed * 53.1, Double(size.height + 20)) - 10
            let radius: CGFloat = CGFloat(2 + fmod(seed * 3.7, 4))
            let opacity = 0.15 + fmod(seed * 0.13, 0.1)

            let flake = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(flake, with: .color(Color.white.opacity(opacity)))
        }

        // 알록달록 빛 파티클 (눈처럼 떨어짐)
        for i in 0..<25 {
            let seed = Double(i) * 53.7
            let colorIndex = Int(fmod(seed * 3.1, Double(colors.count)))
            let color = colors[colorIndex]

            let x = (Double(i) / 25.0) * size.width + sin(time * 0.15 + seed * 0.8) * 50
            let fallSpeed = 12.0 + fmod(seed * 9.7, 18.0)
            let y = fmod(time * fallSpeed + seed * 31.9, Double(size.height + 40)) - 20
            let baseSize: CGFloat = CGFloat(3 + fmod(seed * 2.9, 5))

            let twinkle = (sin(time * 2.5 + seed * 4.3) + 1) * 0.5
            let finalSize = baseSize * CGFloat(0.7 + twinkle * 0.3)
            let opacity = 0.25 + twinkle * 0.3

            // 글로우
            let glowR = finalSize * 2.2
            let glow = Path(ellipseIn: CGRect(x: x - glowR, y: y - glowR, width: glowR * 2, height: glowR * 2))
            ctx.fill(glow, with: .color(color.opacity(opacity * 0.25)))

            // 코어
            let core = Path(ellipseIn: CGRect(x: x - finalSize, y: y - finalSize, width: finalSize * 2, height: finalSize * 2))
            ctx.fill(core, with: .color(color.opacity(opacity)))

            // 밝은 중심
            let bright = finalSize * 0.4
            let dot = Path(ellipseIn: CGRect(x: x - bright, y: y - bright, width: bright * 2, height: bright * 2))
            ctx.fill(dot, with: .color(.white.opacity(opacity * 0.6)))
        }

        // 반짝이
        for i in 0..<6 {
            let seed = Double(i) * 137.5
            let x = (Double(i) / 6.0) * size.width + sin(seed) * size.width * 0.06
            let y = (Double(i) / 6.0) * size.height * 0.6 + sin(seed * 1.7) * size.height * 0.1
            let twinkle = (sin(time * 2.0 + seed * 3.1) + 1) * 0.5
            let starSize: CGFloat = CGFloat(3 + twinkle * 4)
            let opacity = 0.12 + twinkle * 0.2

            var star = Path()
            star.move(to: CGPoint(x: x - starSize, y: y))
            star.addLine(to: CGPoint(x: x + starSize, y: y))
            star.move(to: CGPoint(x: x, y: y - starSize))
            star.addLine(to: CGPoint(x: x, y: y + starSize))
            ctx.stroke(star, with: .color(Color(red: 1.0, green: 0.95, blue: 0.7).opacity(opacity)), lineWidth: 1.0)
        }
    }

    // MARK: - Space

    private func drawSpaceBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let starColors: [Color] = [
            .white,
            Color(red: 0.8, green: 0.85, blue: 1.0),  // blue-white
            Color(red: 1.0, green: 0.95, blue: 0.8),   // warm white
            Color(red: 0.7, green: 0.8, blue: 1.0),    // light blue
        ]

        // 별 - 그리드 기반 균등 분포
        for i in 0..<45 {
            let cols = 9
            let rows = 5
            let col = i % cols
            let row = i / cols
            let cellW = size.width / CGFloat(cols)
            let cellH = size.height / CGFloat(rows)

            // 셀 내에서 랜덤 위치 (seed 기반)
            let seed = Double(i) * 67.3
            let offsetX = fmod(seed * 17.3, Double(cellW) * 0.8) + Double(cellW) * 0.1
            let offsetY = fmod(seed * 23.1, Double(cellH) * 0.8) + Double(cellH) * 0.1
            let x = CGFloat(col) * cellW + CGFloat(offsetX)
            let y = CGFloat(row) * cellH + CGFloat(offsetY)

            let twinkle = sin(time * (1.5 + fmod(seed * 0.1, 2.0)) + seed) * 0.5 + 0.5
            let radius: CGFloat = CGFloat(1.0 + fmod(seed * 1.3, 2.2))
            let opacity = 0.1 + twinkle * 0.22
            let color = starColors[i % starColors.count]

            let star = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(star, with: .color(color.opacity(opacity)))

            // 밝은 별은 십자 반짝임
            if i < 10 {
                let sparkSize = radius + CGFloat(twinkle) * 4
                var spark = Path()
                spark.move(to: CGPoint(x: x - sparkSize, y: y))
                spark.addLine(to: CGPoint(x: x + sparkSize, y: y))
                spark.move(to: CGPoint(x: x, y: y - sparkSize))
                spark.addLine(to: CGPoint(x: x, y: y + sparkSize))
                ctx.stroke(spark, with: .color(color.opacity(opacity * 0.35)), lineWidth: 0.6)
            }
        }

        // 은하수 띠
        var milkyWay = Path()
        for x in stride(from: 0, through: size.width, by: 3) {
            let y = size.height * 0.45 + sin(Double(x) * 0.008 + time * 0.1) * 35
                + cos(Double(x) * 0.015) * 20
            if x == 0 { milkyWay.move(to: CGPoint(x: x, y: y)) }
            else { milkyWay.addLine(to: CGPoint(x: x, y: y)) }
        }
        ctx.stroke(milkyWay, with: .color(Color(red: 0.5, green: 0.4, blue: 0.8).opacity(0.04)), lineWidth: 30)
        ctx.stroke(milkyWay, with: .color(Color(red: 0.6, green: 0.5, blue: 0.9).opacity(0.025)), lineWidth: 60)

        // 유성 - 여러 개가 연속으로 떨어짐
        for i in 0..<4 {
            let seed = Double(i) * 193.7
            let duration = 2.5 + fmod(seed * 0.3, 1.5)
            let progress = fmod(time * 0.6 + seed * 0.7, duration) / duration

            let startX = (Double(i) / 4.0) * size.width * 0.7 + size.width * 0.1 + sin(seed) * 20
            let startY = fmod(seed * 19.3, size.height * 0.25)
            let length = 100.0 + fmod(seed * 11.3, 60.0)
            let endX = startX + length
            let endY = startY + length * 0.65
            let cx = startX + (endX - startX) * progress
            let cy = startY + (endY - startY) * progress
            let tailLen: CGFloat = CGFloat(35 + fmod(seed * 3.7, 25))
            let fade = 1.0 - progress

            var trail = Path()
            trail.move(to: CGPoint(x: cx, y: cy))
            trail.addLine(to: CGPoint(x: cx - tailLen, y: cy - tailLen * 0.65))
            ctx.stroke(trail, with: .color(Color.white.opacity(0.2 * fade)), lineWidth: 1.2)

            let dot = Path(ellipseIn: CGRect(x: cx - 2, y: cy - 2, width: 4, height: 4))
            ctx.fill(dot, with: .color(Color.white.opacity(0.35 * fade)))
        }
    }

    // MARK: - Cherry Blossom

    private func drawCherryBlossomBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let pink = Color(red: 1.0, green: 0.65, blue: 0.75)
        let lightPink = Color(red: 1.0, green: 0.80, blue: 0.85)

        for i in 0..<15 {
            let seed = Double(i) * 113.7
            let baseX = (Double(i) / 15.0) * size.width + sin(seed * 2.1) * size.width * 0.04
            let fallSpeed = 12.0 + fmod(seed * 11.3, 20.0)
            let y = fmod(time * fallSpeed + seed * 53.7, Double(size.height + 45)) - 22
            let drift = sin(time * 0.3 + seed) * 40 + cos(time * 0.18 + seed * 0.7) * 18
            let x = baseX + drift
            let rotation = time * 0.35 + seed
            let scale = 1.1 + fmod(seed * 0.3, 1.0)
            let color = i % 3 == 0 ? lightPink : pink

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.15 + fmod(seed * 0.03, 0.08)
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

        for i in 0..<6 {
            let seed = Double(i) * 179.3
            let x = (Double(i) / 6.0) * size.width + fmod(time * 10 + seed, 40) - 20
            let y = fmod(seed * 29.3, size.height * 0.5) + sin(time * 0.5 + seed) * 22
            let r: CGFloat = CGFloat(3 + fmod(seed * 1.1, 3))

            let dot = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(dot, with: .color(pink.opacity(0.1)))
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
            ctx.stroke(line, with: .color(green.opacity(0.05)), lineWidth: 0.7)
        }
        for y in stride(from: -gridSpacing + CGFloat(scrollOffset), through: size.height + gridSpacing, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: 0, y: y))
            line.addLine(to: CGPoint(x: size.width, y: y))
            ctx.stroke(line, with: .color(green.opacity(0.05)), lineWidth: 0.7)
        }

        for i in 0..<7 {
            let seed = Double(i) * 79.3
            let x = (Double(i) / 7.0) * size.width + sin(seed * 1.3) * size.width * 0.05
            let speed = 10.0 + fmod(seed * 13.1, 20.0)
            let y = size.height - fmod(time * speed + seed * 37.3, Double(size.height + 30)) + 15
            let blockSize: CGFloat = CGFloat(6 + i % 3 * 3)

            let block = Path(CGRect(x: x, y: y, width: blockSize, height: blockSize))
            ctx.fill(block, with: .color(green.opacity(0.12)))
        }

        let cursorOn = sin(time * 3) > 0
        if cursorOn {
            let cursorRect = Path(CGRect(x: size.width * 0.1, y: size.height * 0.85, width: 10, height: 3))
            ctx.fill(cursorRect, with: .color(green.opacity(0.16)))
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
            let baseX = (Double(i) / 12.0) * size.width + sin(seed * 1.7) * size.width * 0.04
            let fallSpeed = 10.0 + fmod(seed * 9.7, 18.0)
            let y = fmod(time * fallSpeed + seed * 41.3, Double(size.height + 35)) - 18
            let drift = sin(time * 0.2 + seed) * 35 + cos(time * 0.12 + seed * 0.5) * 16
            let x = baseX + drift
            let rotation = time * 0.3 + seed
            let color = colors[i % colors.count]
            let scale = 1.2 + fmod(seed * 0.2, 0.9)

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.16
                let transform = CGAffineTransform(translationX: x, y: y)
                    .rotated(by: rotation)
                    .scaledBy(x: scale, y: scale)

                if i % 3 == 0 {
                    var maple = Path()
                    for arm in 0..<5 {
                        let angle = CGFloat(arm) * .pi * 2 / 5 - .pi / 2
                        let tipX = cos(angle) * 7
                        let tipY = sin(angle) * 7
                        if arm == 0 { maple.move(to: CGPoint(x: tipX, y: tipY)) }
                        else { maple.addLine(to: CGPoint(x: tipX, y: tipY)) }
                        let innerAngle = angle + .pi / 5
                        maple.addLine(to: CGPoint(x: cos(innerAngle) * 3, y: sin(innerAngle) * 3))
                    }
                    maple.closeSubpath()
                    layerCtx.fill(maple.applying(transform), with: .color(color))
                } else {
                    var leaf = Path()
                    leaf.move(to: CGPoint(x: 0, y: -7))
                    leaf.addQuadCurve(to: CGPoint(x: 0, y: 7), control: CGPoint(x: 8, y: 0))
                    leaf.addQuadCurve(to: CGPoint(x: 0, y: -7), control: CGPoint(x: -8, y: 0))
                    layerCtx.fill(leaf.applying(transform), with: .color(color))
                }
            }
        }

        for i in 0..<4 {
            let seed = Double(i) * 193.7
            let x = (Double(i) / 4.0) * size.width + sin(seed * 1.5) * size.width * 0.08
            let y = (Double(i) / 4.0) * size.height * 0.4 + size.height * 0.1
            let r: CGFloat = CGFloat(40 + fmod(seed * 7.1, 35))
            let pulse = sin(time * 0.3 + seed) * 0.012

            let glow = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(glow, with: .color(Color(red: 0.95, green: 0.75, blue: 0.3).opacity(0.03 + pulse)))
        }
    }

    // MARK: - Aurora

    private func drawAuroraBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let colors: [(Color, Double)] = [
            (Color(red: 0.1, green: 0.9, blue: 0.5), 0.08),
            (Color(red: 0.3, green: 0.5, blue: 0.9), 0.07),
            (Color(red: 0.7, green: 0.2, blue: 0.8), 0.055),
            (Color(red: 0.2, green: 0.8, blue: 0.7), 0.045),
        ]

        for (idx, (color, opacity)) in colors.enumerated() {
            let baseY = size.height * (0.1 + CGFloat(idx) * 0.13)
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 3) {
                let wave1 = sin(Double(x) * 0.008 + time * 0.3 + Double(idx) * 2.0) * 50
                let wave2 = sin(Double(x) * 0.015 + time * 0.5 + Double(idx) * 1.5) * 25
                let wave3 = cos(Double(x) * 0.005 + time * 0.2 + Double(idx)) * 15
                let y = baseY + wave1 + wave2 + wave3
                if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(color.opacity(opacity)))
        }

        // 별 - 골고루 분포
        for i in 0..<25 {
            let col = i % 5
            let row = i / 5
            let cellW = size.width / 5
            let cellH = size.height * 0.4 / 5
            let seed = Double(i) * 71.3
            let x = CGFloat(col) * cellW + CGFloat(fmod(seed * 17.1, Double(cellW)))
            let y = CGFloat(row) * cellH + CGFloat(fmod(seed * 23.7, Double(cellH)))
            let twinkle = sin(time * 2.0 + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(1.0 + fmod(seed, 1.8))
            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.1 + twinkle * 0.18)))
        }

    }

    // MARK: - Circus

    private func drawCircusBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        for i in 0..<3 {
            let seed = Double(i) * 131.7
            let baseX = size.width * (0.2 + CGFloat(i) * 0.3)
            let sway = sin(time * 0.4 + seed) * 35
            let beamWidth: CGFloat = 70

            var beam = Path()
            beam.move(to: CGPoint(x: baseX + sway - 6, y: 0))
            beam.addLine(to: CGPoint(x: baseX + sway + 6, y: 0))
            beam.addLine(to: CGPoint(x: baseX + sway + beamWidth, y: size.height))
            beam.addLine(to: CGPoint(x: baseX + sway - beamWidth, y: size.height))
            beam.closeSubpath()

            let beamColor: Color = [Color.yellow, Color.white, Color.red][i]
            ctx.fill(beam, with: .color(beamColor.opacity(0.02)))
        }

        let confettiColors: [Color] = [.red, .yellow, .blue, .green, .orange, .pink]

        for i in 0..<18 {
            let seed = Double(i) * 103.7
            let x = (Double(i) / 18.0) * size.width + sin(seed * 1.9) * size.width * 0.04
            let fallSpeed = 15.0 + fmod(seed * 7.7, 20.0)
            let y = fmod(time * fallSpeed + seed * 59.3, Double(size.height + 20)) - 10
            let rotation = time * 1.5 + seed
            let color = confettiColors[i % confettiColors.count]

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)

                if i % 3 == 0 {
                    let starSize: CGFloat = CGFloat(5 + i % 3)
                    var star = Path()
                    for arm in 0..<5 {
                        let angle = CGFloat(arm) * .pi * 2 / 5 - .pi / 2
                        if arm == 0 { star.move(to: CGPoint(x: cos(angle) * starSize, y: sin(angle) * starSize)) }
                        else { star.addLine(to: CGPoint(x: cos(angle) * starSize, y: sin(angle) * starSize)) }
                        let innerAngle = angle + .pi / 5
                        star.addLine(to: CGPoint(x: cos(innerAngle) * starSize * 0.4, y: sin(innerAngle) * starSize * 0.4))
                    }
                    star.closeSubpath()
                    layerCtx.fill(star.applying(transform), with: .color(color.opacity(0.16)))
                } else if i % 3 == 1 {
                    let r: CGFloat = CGFloat(3 + i % 3)
                    let circle = Path(ellipseIn: CGRect(x: -r, y: -r, width: r * 2, height: r * 2))
                    layerCtx.fill(circle.applying(transform), with: .color(color.opacity(0.14)))
                } else {
                    let w: CGFloat = CGFloat(4 + i % 3)
                    let h: CGFloat = CGFloat(7 + i % 4)
                    let rect = Path(CGRect(x: -w / 2, y: -h / 2, width: w, height: h))
                    layerCtx.fill(rect.applying(transform), with: .color(color.opacity(0.14)))
                }
            }
        }
    }

    // MARK: - Forsythia

    private func drawForsythiaBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let yellow = Color(red: 0.98, green: 0.85, blue: 0.08)
        let darkYellow = Color(red: 0.85, green: 0.65, blue: 0.08)

        for i in 0..<14 {
            let seed = Double(i) * 109.3
            let baseX = (Double(i) / 14.0) * size.width + sin(seed * 2.3) * size.width * 0.04
            let fallSpeed = 12.0 + fmod(seed * 8.7, 16.0)
            let y = fmod(time * fallSpeed + seed * 47.1, Double(size.height + 35)) - 18
            let drift = sin(time * 0.3 + seed) * 30
            let x = baseX + drift
            let rotation = time * 0.35 + seed

            ctx.drawLayer { layerCtx in
                let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)
                var petal = Path()
                petal.addEllipse(in: CGRect(x: -6, y: -4, width: 12, height: 8))
                layerCtx.fill(petal.applying(transform), with: .color(yellow.opacity(0.18)))
            }
        }

        for i in 0..<5 {
            let seed = Double(i) * 193.7
            let x = (Double(i) / 5.0) * size.width + sin(seed * 1.8) * size.width * 0.06
            let floatSpeed = 6.0 + fmod(seed * 5.1, 8.0)
            let y = size.height - fmod(time * floatSpeed + seed * 37.1, Double(size.height + 45)) + 22
            let driftX = sin(time * 0.2 + seed) * 18
            let cx = x + driftX
            let petalR: CGFloat = 8

            for p in 0..<6 {
                let angle = CGFloat(p) * .pi / 3 + CGFloat(time * 0.25 + seed)
                let px = cx + cos(angle) * petalR
                let py = y + sin(angle) * petalR
                let petal = Path(ellipseIn: CGRect(x: px - 4, y: py - 2.5, width: 8, height: 5))
                ctx.fill(petal, with: .color(yellow.opacity(0.15)))
            }
            let center = Path(ellipseIn: CGRect(x: cx - 3, y: y - 3, width: 6, height: 6))
            ctx.fill(center, with: .color(darkYellow.opacity(0.15)))
        }

        for i in 0..<6 {
            let seed = Double(i) * 157.3
            let x = (sin(time * 0.2 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 6.0 * size.height
            let y = baseY + sin(time * 0.4 + seed * 0.6) * 22
            let radius: CGFloat = CGFloat(14 + (i % 3) * 8)
            let opacity = 0.06 + sin(time * 0.6 + seed) * 0.03

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

        for i in 0..<8 {
            let seed = Double(i) * 127.3
            let x = (Double(i) / 8.0) * size.width + sin(time * 0.25 + seed) * 22
            let floatSpeed = 8.0 + fmod(seed * 6.3, 12.0)
            let y = size.height - fmod(time * floatSpeed + seed * 43.7, Double(size.height + 45)) + 22
            let color = candyColors[i % candyColors.count]
            let rotation = time * 0.25 + seed

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.12

                if i % 2 == 0 {
                    let lolliR: CGFloat = CGFloat(9 + i % 3 * 3)
                    let circle = Path(ellipseIn: CGRect(x: x - lolliR, y: y - lolliR, width: lolliR * 2, height: lolliR * 2))
                    layerCtx.fill(circle, with: .color(color))
                    var spiral = Path()
                    spiral.addArc(center: CGPoint(x: x, y: y), radius: lolliR * 0.5, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: false)
                    layerCtx.stroke(spiral, with: .color(.white), lineWidth: 1.2)
                    var stick = Path()
                    stick.move(to: CGPoint(x: x, y: y + lolliR))
                    stick.addLine(to: CGPoint(x: x, y: y + lolliR + 16))
                    layerCtx.stroke(stick, with: .color(Color.brown.opacity(0.5)), lineWidth: 1.5)
                } else {
                    let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)
                    let candy = Path(ellipseIn: CGRect(x: -8, y: -5, width: 16, height: 10))
                    layerCtx.fill(candy.applying(transform), with: .color(color))
                }
            }
        }

        for i in 0..<8 {
            let seed = Double(i) * 89.1
            let x = (Double(i) / 8.0) * size.width + sin(seed * 2.1) * size.width * 0.05
            let y = (Double(i) / 8.0) * size.height * 0.8 + sin(seed * 1.3) * size.height * 0.08
            let twinkle = (sin(time * 2.5 + seed * 2.1) + 1) * 0.5
            let starSize: CGFloat = CGFloat(2.5 + twinkle * 3)
            let color = candyColors[i % candyColors.count]

            var star = Path()
            star.move(to: CGPoint(x: x - starSize, y: y))
            star.addLine(to: CGPoint(x: x + starSize, y: y))
            star.move(to: CGPoint(x: x, y: y - starSize))
            star.addLine(to: CGPoint(x: x, y: y + starSize))
            ctx.stroke(star, with: .color(color.opacity(0.12 + twinkle * 0.12)), lineWidth: 1.0)
        }
    }

    // MARK: - Zen Garden

    private func drawZenGardenBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let stone = Color(red: 0.45, green: 0.48, blue: 0.42)

        let centers: [(CGFloat, CGFloat)] = [
            (size.width * 0.3, size.height * 0.3),
            (size.width * 0.7, size.height * 0.65),
        ]
        for (cx, cy) in centers {
            for ring in 0..<6 {
                let baseR: CGFloat = CGFloat(25 + ring * 20)
                let ripple = sin(time * 0.25 - Double(ring) * 0.4) * 3.5
                let r = baseR + CGFloat(ripple)
                let circle = Path(ellipseIn: CGRect(x: cx - r, y: cy - r * 0.6, width: r * 2, height: r * 1.2))
                ctx.stroke(circle, with: .color(stone.opacity(0.055 - Double(ring) * 0.006)), lineWidth: 0.8)
            }
        }

        let leafX = size.width * 0.6 + sin(time * 0.12) * 35
        let leafY = size.height * 0.2 + cos(time * 0.08) * 12
        let leafRotation = time * 0.08

        ctx.drawLayer { leafCtx in
            leafCtx.opacity = 0.1
            let transform = CGAffineTransform(translationX: leafX, y: leafY).rotated(by: leafRotation)
            var leaf = Path()
            leaf.move(to: CGPoint(x: 0, y: -11))
            leaf.addQuadCurve(to: CGPoint(x: 0, y: 11), control: CGPoint(x: 11, y: 0))
            leaf.addQuadCurve(to: CGPoint(x: 0, y: -11), control: CGPoint(x: -11, y: 0))
            leafCtx.fill(leaf.applying(transform), with: .color(Color(red: 0.4, green: 0.55, blue: 0.35)))
        }

        for i in 0..<5 {
            let seed = Double(i) * 151.3
            let x = fmod((Double(i) / 5.0) * size.width + time * 2 + sin(seed) * 30, size.width)
            let y = (Double(i) / 5.0) * size.height + sin(seed * 1.5) * size.height * 0.08
            let r: CGFloat = CGFloat(28 + fmod(seed * 3.1, 25))
            let opacity = 0.025 + sin(time * 0.3 + seed) * 0.012

            let mist = Path(ellipseIn: CGRect(x: x - r, y: y - r * 0.5, width: r * 2, height: r))
            ctx.fill(mist, with: .color(Color.white.opacity(max(0, opacity))))
        }
    }

    // MARK: - Desert

    private func drawDesertBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let sand = Color(red: 0.9, green: 0.75, blue: 0.35)
        let moonColor = Color(red: 0.95, green: 0.90, blue: 0.70)

        // 모래 언덕
        for dune in 0..<4 {
            let baseY = size.height * (0.62 + CGFloat(dune) * 0.08)
            let offset = Double(dune) * 50
            let drift = sin(time * 0.05 + offset) * 8
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height))
            for x in stride(from: 0, through: size.width, by: 3) {
                let y = baseY + sin(Double(x) * 0.007 + offset + drift) * 30 + cos(Double(x) * 0.013 + offset) * 18
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(sand.opacity(0.045 - Double(dune) * 0.008)))
        }

        // 모래 입자 (바람에 날리는)
        for i in 0..<20 {
            let seed = Double(i) * 89.3
            let baseY = fmod(seed * 37.7, size.height)
            let speed = 10.0 + fmod(seed * 5.3, 18.0)
            let x = fmod(time * speed + seed * 43.1, Double(size.width + 20)) - 10
            let drift = sin(time * 0.4 + seed) * 9
            let y = baseY + drift
            let r: CGFloat = CGFloat(1.2 + fmod(seed * 1.7, 2.5))

            let grain = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(grain, with: .color(sand.opacity(0.08)))
        }

        // 달 (더 크고 디테일)
        let moonX = size.width * 0.78
        let moonY = size.height * 0.1
        let moonR: CGFloat = 28
        // 달 외부 글로우
        let outerGlowR: CGFloat = 65
        let outerGlow = Path(ellipseIn: CGRect(x: moonX - outerGlowR, y: moonY - outerGlowR, width: outerGlowR * 2, height: outerGlowR * 2))
        ctx.fill(outerGlow, with: .color(moonColor.opacity(0.02)))
        let moonGlowR: CGFloat = 45
        let moonGlow = Path(ellipseIn: CGRect(x: moonX - moonGlowR, y: moonY - moonGlowR, width: moonGlowR * 2, height: moonGlowR * 2))
        ctx.fill(moonGlow, with: .color(moonColor.opacity(0.04)))
        let moon = Path(ellipseIn: CGRect(x: moonX - moonR, y: moonY - moonR, width: moonR * 2, height: moonR * 2))
        ctx.fill(moon, with: .color(moonColor.opacity(0.1)))
        // 달 크레이터
        let crater1 = Path(ellipseIn: CGRect(x: moonX - 8, y: moonY - 6, width: 10, height: 8))
        ctx.fill(crater1, with: .color(moonColor.opacity(0.04)))
        let crater2 = Path(ellipseIn: CGRect(x: moonX + 5, y: moonY + 4, width: 7, height: 6))
        ctx.fill(crater2, with: .color(moonColor.opacity(0.03)))

        // 별 - 골고루 분포
        for i in 0..<30 {
            let cols = 6
            let rows = 5
            let col = i % cols
            let row = i / cols
            let cellW = size.width / CGFloat(cols)
            let cellH = size.height * 0.5 / CGFloat(rows)
            let seed = Double(i) * 61.7
            let x = CGFloat(col) * cellW + CGFloat(fmod(seed * 17.3, Double(cellW)))
            let y = CGFloat(row) * cellH + CGFloat(fmod(seed * 27.1, Double(cellH)))
            let twinkle = sin(time * (1.2 + fmod(seed * 0.07, 1.5)) + seed) * 0.5 + 0.5
            let r: CGFloat = CGFloat(1.0 + fmod(seed * 0.9, 1.5))

            let star = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(star, with: .color(Color.white.opacity(0.08 + twinkle * 0.14)))

            if i < 6 {
                let sparkSize: CGFloat = r + CGFloat(twinkle) * 3
                var spark = Path()
                spark.move(to: CGPoint(x: x - sparkSize, y: y))
                spark.addLine(to: CGPoint(x: x + sparkSize, y: y))
                spark.move(to: CGPoint(x: x, y: y - sparkSize))
                spark.addLine(to: CGPoint(x: x, y: y + sparkSize))
                ctx.stroke(spark, with: .color(Color.white.opacity(0.06 + twinkle * 0.1)), lineWidth: 0.7)
            }
        }

        // 사막 열기 아지랑이
        for i in 0..<3 {
            let seed = Double(i) * 157.3
            let x = size.width * (0.2 + CGFloat(i) * 0.3)
            let y = size.height * 0.65
            let shimmer = sin(time * 0.8 + seed) * 5
            let r: CGFloat = 40
            let haze = Path(ellipseIn: CGRect(x: x - r, y: y + shimmer - r * 0.3, width: r * 2, height: r * 0.6))
            ctx.fill(haze, with: .color(sand.opacity(0.025)))
        }
    }

    // MARK: - Ocean

    private func drawOceanBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let blue = Color(red: 0.20, green: 0.60, blue: 0.85)
        let lightBlue = Color(red: 0.40, green: 0.75, blue: 0.95)
        let foam = Color(red: 0.85, green: 0.95, blue: 1.0)

        // Layered waves
        for wave in 0..<4 {
            let baseY = size.height * (0.55 + CGFloat(wave) * 0.10)
            let speed = 0.3 + Double(wave) * 0.1
            let amplitude = 20.0 - Double(wave) * 3
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height))
            for x in stride(from: 0, through: size.width, by: 3) {
                let y = baseY + sin(Double(x) * 0.008 + time * speed + Double(wave) * 1.5) * amplitude
                    + cos(Double(x) * 0.012 + time * speed * 0.7) * amplitude * 0.5
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(blue.opacity(0.04 - Double(wave) * 0.006)))
        }

        // Floating bubbles
        for i in 0..<10 {
            let seed = Double(i) * 97.3
            let x = (Double(i) / 10.0) * size.width + sin(time * 0.3 + seed) * 20
            let floatSpeed = 6.0 + fmod(seed * 5.3, 10.0)
            let y = size.height - fmod(time * floatSpeed + seed * 37.1, Double(size.height + 40)) + 20
            let r: CGFloat = CGFloat(3 + fmod(seed * 2.1, 5))

            let bubble = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.stroke(bubble, with: .color(lightBlue.opacity(0.12)), lineWidth: 0.8)
            // Highlight
            let highlightR = r * 0.3
            let highlight = Path(ellipseIn: CGRect(x: x - r * 0.3, y: y - r * 0.5, width: highlightR, height: highlightR))
            ctx.fill(highlight, with: .color(foam.opacity(0.15)))
        }

        // Light rays from surface
        for i in 0..<3 {
            let seed = Double(i) * 131.7
            let baseX = size.width * (0.2 + CGFloat(i) * 0.3)
            let sway = sin(time * 0.2 + seed) * 25
            var ray = Path()
            ray.move(to: CGPoint(x: baseX + sway - 8, y: 0))
            ray.addLine(to: CGPoint(x: baseX + sway + 8, y: 0))
            ray.addLine(to: CGPoint(x: baseX + sway + 50, y: size.height * 0.7))
            ray.addLine(to: CGPoint(x: baseX + sway - 50, y: size.height * 0.7))
            ray.closeSubpath()
            ctx.fill(ray, with: .color(foam.opacity(0.015)))
        }
    }

    // MARK: - Neon Cyber

    private func drawNeonCyberBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let pink = Color(red: 0.95, green: 0.20, blue: 0.60)
        let cyan = Color(red: 0.0, green: 0.95, blue: 0.90)

        // Perspective grid (bottom half)
        let gridSpacing: CGFloat = 35
        let scrollOffset = fmod(time * 20, Double(gridSpacing))

        // Horizontal grid lines (perspective)
        for i in 0..<10 {
            let y = size.height * 0.6 + CGFloat(i) * gridSpacing * 0.5 + CGFloat(scrollOffset) * 0.5
            if y < size.height {
                var line = Path()
                line.move(to: CGPoint(x: 0, y: y))
                line.addLine(to: CGPoint(x: size.width, y: y))
                let opacity = 0.06 - Double(i) * 0.004
                ctx.stroke(line, with: .color(pink.opacity(max(0, opacity))), lineWidth: 0.6)
            }
        }

        // Vertical grid lines
        for x in stride(from: CGFloat(0), through: size.width, by: gridSpacing) {
            var line = Path()
            line.move(to: CGPoint(x: x, y: size.height * 0.6))
            line.addLine(to: CGPoint(x: x, y: size.height))
            ctx.stroke(line, with: .color(pink.opacity(0.04)), lineWidth: 0.5)
        }

        // Neon light blobs
        for i in 0..<6 {
            let seed = Double(i) * 107.3
            let x = (sin(time * 0.15 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 6.0 * size.height * 0.5
            let y = baseY + sin(time * 0.3 + seed * 0.7) * 25
            let radius: CGFloat = CGFloat(15 + (i % 3) * 10)
            let color = i % 2 == 0 ? pink : cyan
            let opacity = 0.04 + sin(time * 0.5 + seed) * 0.02

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(color.opacity(max(0, opacity))))
        }

        // Digital rain particles
        for i in 0..<12 {
            let seed = Double(i) * 73.1
            let x = (Double(i) / 12.0) * size.width + sin(seed * 1.7) * size.width * 0.03
            let speed = 25.0 + fmod(seed * 9.1, 20.0)
            let y = fmod(time * speed + seed * 41.7, Double(size.height + 20)) - 10
            let h: CGFloat = CGFloat(4 + i % 3 * 3)
            let color = i % 3 == 0 ? cyan : pink

            let drop = Path(CGRect(x: x, y: y, width: 1.5, height: h))
            ctx.fill(drop, with: .color(color.opacity(0.12)))
        }
    }

    // MARK: - Korean Traditional

    private func drawKoreanBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let red = Color(red: 0.78, green: 0.22, blue: 0.28)
        let blue = Color(red: 0.20, green: 0.35, blue: 0.60)
        let warm = Color(red: 0.85, green: 0.65, blue: 0.15)

        // Floating hanji fiber particles
        for i in 0..<10 {
            let seed = Double(i) * 113.7
            let x = (Double(i) / 10.0) * size.width + sin(time * 0.12 + seed) * 18
            let floatSpeed = 4.0 + fmod(seed * 3.7, 6.0)
            let y = size.height - fmod(time * floatSpeed + seed * 47.3, Double(size.height + 35)) + 18
            let rotation = time * 0.1 + seed

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.08
                let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)
                var fiber = Path()
                fiber.move(to: CGPoint(x: -8, y: 0))
                fiber.addQuadCurve(to: CGPoint(x: 8, y: 0), control: CGPoint(x: 0, y: -4))
                layerCtx.stroke(fiber.applying(transform), with: .color(warm), lineWidth: 0.6)
            }
        }

        // Subtle warm glow spots
        for i in 0..<4 {
            let seed = Double(i) * 179.3
            let x = (Double(i) / 4.0) * size.width + sin(seed * 1.5) * size.width * 0.08
            let y = (Double(i) / 4.0) * size.height + sin(seed * 2.1) * size.height * 0.08
            let r: CGFloat = CGFloat(35 + fmod(seed * 5.3, 30))
            let pulse = sin(time * 0.2 + seed) * 0.01

            let glow = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            ctx.fill(glow, with: .color(warm.opacity(0.03 + pulse)))
        }

        // Dancheong-inspired subtle pattern circles at edges
        for i in 0..<3 {
            let seed = Double(i) * 97.1
            let x = (Double(i) / 3.0) * size.width + sin(seed * 1.3) * size.width * 0.06
            let y: CGFloat = i % 2 == 0 ? 15 : size.height - 15
            let colors = [red, blue, warm]

            let dot = Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
            ctx.fill(dot, with: .color(colors[i].opacity(0.06)))
        }
    }

    // MARK: - Rainy Day

    private func drawRainyDayBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let blue = Color(red: 0.50, green: 0.65, blue: 0.80)
        let gray = Color(red: 0.55, green: 0.60, blue: 0.68)

        // Rain drops — evenly distributed, fast, visible
        let dropCount = 50
        for i in 0..<dropCount {
            let ratio = Double(i) / Double(dropCount)
            let seed = Double(i) * 67.3
            let x = ratio * size.width + sin(seed * 3.7) * size.width * 0.04
            let windDrift = sin(time * 0.3 + seed) * 8
            let speed = 80.0 + fmod(seed * 11.3, 60.0)
            let y = fmod(time * speed + seed * 53.1, Double(size.height + 40)) - 20
            let h: CGFloat = CGFloat(12 + fmod(seed * 2.3, 16))
            let opacity = 0.15 + fmod(seed * 0.02, 0.10)

            var drop = Path()
            drop.move(to: CGPoint(x: x + windDrift, y: y))
            drop.addLine(to: CGPoint(x: x + windDrift + 2, y: y + h))
            ctx.stroke(drop, with: .color(blue.opacity(opacity)), lineWidth: 1.2)
        }

        // Puddle ripples at bottom — spread across width
        for i in 0..<8 {
            let cx = size.width * (Double(i) + 0.5) / 8.0
            let cy = size.height * (0.85 + CGFloat(i % 3) * 0.04)
            let seed = Double(i) * 151.7
            let ripplePhase = fmod(time * 1.2 + seed, 2.5) / 2.5
            let r: CGFloat = CGFloat(ripplePhase * 25)
            let opacity = 0.12 * (1.0 - ripplePhase)

            let ripple = Path(ellipseIn: CGRect(x: cx - r, y: cy - r * 0.4, width: r * 2, height: r * 0.8))
            ctx.stroke(ripple, with: .color(blue.opacity(opacity)), lineWidth: 0.8)
        }

        // Mist/fog layers
        for i in 0..<4 {
            let x = size.width * (Double(i) + 0.5) / 4.0
            let y = size.height * (0.25 + CGFloat(i) * 0.15)
            let seed = Double(i) * 127.3
            let drift = sin(time * 0.15 + seed) * 30
            let r: CGFloat = CGFloat(55 + fmod(seed * 3.1, 35))

            let mist = Path(ellipseIn: CGRect(x: x + drift - r, y: y - r * 0.3, width: r * 2, height: r * 0.6))
            ctx.fill(mist, with: .color(gray.opacity(0.05)))
        }
    }

    // MARK: - Lavender

    private func drawLavenderBG(ctx: GraphicsContext, size: CGSize, time: Double) {
        let purple = Color(red: 0.60, green: 0.40, blue: 0.80)
        let lightPurple = Color(red: 0.75, green: 0.60, blue: 0.90)
        let green = Color(red: 0.50, green: 0.65, blue: 0.45)

        // Floating lavender petals — evenly distributed
        let petalCount = 18
        for i in 0..<petalCount {
            let ratio = Double(i) / Double(petalCount)
            let seed = Double(i) * 97.3
            let baseX = ratio * size.width + sin(seed * 2.3) * size.width * 0.05
            let fallSpeed = 10.0 + fmod(seed * 7.3, 15.0)
            let y = fmod(time * fallSpeed + seed * 43.7, Double(size.height + 35)) - 18
            let drift = sin(time * 0.3 + seed) * 35
            let x = baseX + drift
            let rotation = time * 0.25 + seed

            ctx.drawLayer { layerCtx in
                layerCtx.opacity = 0.20
                let transform = CGAffineTransform(translationX: x, y: y).rotated(by: rotation)
                var petal = Path()
                petal.addEllipse(in: CGRect(x: -4, y: -6, width: 8, height: 12))
                let color = i % 3 == 0 ? lightPurple : purple
                layerCtx.fill(petal.applying(transform), with: .color(color))
            }
        }

        // Soft glowing orbs
        for i in 0..<5 {
            let seed = Double(i) * 157.3
            let x = (sin(time * 0.15 + seed) * 0.5 + 0.5) * size.width
            let baseY = CGFloat(i) / 5.0 * size.height
            let y = baseY + sin(time * 0.3 + seed * 0.6) * 20
            let radius: CGFloat = CGFloat(18 + (i % 3) * 10)
            let opacity = 0.04 + sin(time * 0.4 + seed) * 0.02

            let orb = Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            ctx.fill(orb, with: .color(purple.opacity(max(0, opacity))))
        }

        // Sparkle twinkles
        for i in 0..<6 {
            let seed = Double(i) * 137.5
            let x = (Double(i) / 6.0) * size.width + sin(seed * 1.9) * size.width * 0.06
            let y = (Double(i) / 6.0) * size.height * 0.8 + sin(seed * 2.7) * size.height * 0.08
            let twinkle = (sin(time * 2.0 + seed * 3.1) + 1) * 0.5
            let starSize: CGFloat = CGFloat(2 + twinkle * 3)
            let opacity = 0.08 + twinkle * 0.12

            var star = Path()
            star.move(to: CGPoint(x: x - starSize, y: y))
            star.addLine(to: CGPoint(x: x + starSize, y: y))
            star.move(to: CGPoint(x: x, y: y - starSize))
            star.addLine(to: CGPoint(x: x, y: y + starSize))
            ctx.stroke(star, with: .color(lightPurple.opacity(opacity)), lineWidth: 0.8)
        }
    }
}

// MARK: - SpriteKit Rain

private struct RainSpriteView: View {
    @State private var scene: RainScene = {
        let s = RainScene()
        s.scaleMode = .resizeFill
        s.backgroundColor = .clear
        return s
    }()

    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
    }
}

private final class RainScene: SKScene {

    override func didMove(to view: SKView) {
        setupRain()
        setupMist()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        // 화면 크기 바뀌면 이미터 위치 갱신
        enumerateChildNodes(withName: "rain") { node, _ in
            if let emitter = node as? SKEmitterNode {
                emitter.position = CGPoint(x: self.size.width / 2, y: self.size.height + 20)
                emitter.particlePositionRange = CGVector(dx: self.size.width * 1.5, dy: 0)
            }
        }
    }

    private func setupRain() {
        // 앞쪽 빗방울 — 크고 느리게, 은은하게
        let emitter = SKEmitterNode()
        emitter.name = "rain"
        emitter.particleTexture = SKTexture(image: Self.makeRaindropImage())

        emitter.particleBirthRate = 15
        emitter.numParticlesToEmit = 0

        emitter.particleLifetime = 5.0
        emitter.particleLifetimeRange = 1.5

        emitter.position = CGPoint(x: size.width / 2, y: size.height + 30)
        emitter.particlePositionRange = CGVector(dx: size.width * 1.5, dy: 0)

        emitter.particleSpeed = 120
        emitter.particleSpeedRange = 40
        emitter.emissionAngle = -.pi / 2
        emitter.emissionAngleRange = .pi / 25

        emitter.yAcceleration = -20
        emitter.xAcceleration = 8

        emitter.particleScale = 0.28
        emitter.particleScaleRange = 0.10

        emitter.particleAlpha = 0.20
        emitter.particleAlphaRange = 0.08
        emitter.particleAlphaSpeed = -0.02

        emitter.particleColor = UIColor(red: 0.65, green: 0.78, blue: 0.92, alpha: 1.0)
        emitter.particleColorBlendFactor = 1.0
        emitter.particleBlendMode = .add

        emitter.particleRotation = 0
        emitter.particleRotationRange = .pi / 16

        emitter.zPosition = 1
        addChild(emitter)

        // 뒤쪽 빗방울 — 작고 약간 더 빠르게 (깊이감)
        let farRain = SKEmitterNode()
        farRain.name = "rain"
        farRain.particleTexture = SKTexture(image: Self.makeRaindropImage())
        farRain.particleBirthRate = 10
        farRain.numParticlesToEmit = 0
        farRain.particleLifetime = 4.0
        farRain.particleLifetimeRange = 1.0
        farRain.position = CGPoint(x: size.width / 2, y: size.height + 30)
        farRain.particlePositionRange = CGVector(dx: size.width * 1.5, dy: 0)
        farRain.particleSpeed = 180
        farRain.particleSpeedRange = 50
        farRain.emissionAngle = -.pi / 2
        farRain.emissionAngleRange = .pi / 30
        farRain.yAcceleration = -15
        farRain.xAcceleration = 6
        farRain.particleScale = 0.14
        farRain.particleScaleRange = 0.05
        farRain.particleAlpha = 0.10
        farRain.particleAlphaRange = 0.04
        farRain.particleAlphaSpeed = -0.015
        farRain.particleColor = UIColor(red: 0.55, green: 0.68, blue: 0.82, alpha: 1.0)
        farRain.particleColorBlendFactor = 1.0
        farRain.particleBlendMode = .add
        farRain.zPosition = 0
        addChild(farRain)
    }

    private func setupMist() {
        // 안개 파티클 — 느리게 떠다니는 큰 구체
        let mist = SKEmitterNode()
        mist.particleTexture = SKTexture(image: Self.makeMistImage())
        mist.particleBirthRate = 1.5
        mist.numParticlesToEmit = 0
        mist.particleLifetime = 6
        mist.particleLifetimeRange = 2
        mist.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        mist.particlePositionRange = CGVector(dx: size.width, dy: size.height * 0.6)
        mist.particleSpeed = 8
        mist.particleSpeedRange = 5
        mist.emissionAngle = 0
        mist.emissionAngleRange = .pi * 2
        mist.particleScale = 0.8
        mist.particleScaleRange = 0.4
        mist.particleAlpha = 0.04
        mist.particleAlphaRange = 0.02
        mist.particleAlphaSpeed = -0.005
        mist.particleColor = UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1.0)
        mist.particleColorBlendFactor = 1.0
        mist.particleBlendMode = .add
        mist.zPosition = 2
        addChild(mist)
    }

    // MARK: - 텍스처 생성 (이미지 파일 불필요)

    private static func makeRaindropImage() -> UIImage {
        let w: CGFloat = 12
        let h: CGFloat = 28
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: w, height: h))
        return renderer.image { ctx in
            let path = UIBezierPath()
            // 물방울 모양: 위는 뾰족, 아래는 둥근 드롭
            path.move(to: CGPoint(x: w / 2, y: 0))
            path.addQuadCurve(to: CGPoint(x: w, y: h * 0.6),
                              controlPoint: CGPoint(x: w * 0.95, y: h * 0.25))
            path.addQuadCurve(to: CGPoint(x: w / 2, y: h),
                              controlPoint: CGPoint(x: w, y: h * 0.9))
            path.addQuadCurve(to: CGPoint(x: 0, y: h * 0.6),
                              controlPoint: CGPoint(x: 0, y: h * 0.9))
            path.addQuadCurve(to: CGPoint(x: w / 2, y: 0),
                              controlPoint: CGPoint(x: w * 0.05, y: h * 0.25))
            path.close()

            UIColor.white.setFill()
            path.fill()
        }
    }

    private static func makeMistImage() -> UIImage {
        let size: CGFloat = 120
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            let colors = [
                UIColor.white.withAlphaComponent(0.3).cgColor,
                UIColor.white.withAlphaComponent(0.0).cgColor
            ] as CFArray
            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                            colors: colors, locations: [0, 1]) else { return }
            let center = CGPoint(x: size / 2, y: size / 2)
            ctx.cgContext.drawRadialGradient(gradient, startCenter: center, startRadius: 0,
                                            endCenter: center, endRadius: size / 2, options: [])
        }
    }
}
