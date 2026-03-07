import SwiftUI

// MARK: - Theme Card Decoration Overlay

struct CardDecorationOverlay: View {
    let theme: AppTheme

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            switch theme {
            case .minimal:
                minimalFrame(w: w, h: h)
            case .halloween:
                halloweenFrame(w: w, h: h)
            case .christmas:
                christmasFrame(w: w, h: h)
            case .ocean:
                oceanFrame(w: w, h: h)
            case .space:
                spaceFrame(w: w, h: h)
            case .cherryBlossom:
                cherryBlossomFrame(w: w, h: h)
            case .retroGame:
                retroFrame(w: w, h: h)
            case .autumn:
                autumnFrame(w: w, h: h)
            case .aurora:
                auroraFrame(w: w, h: h)
            case .circus:
                circusFrame(w: w, h: h)
            case .desert:
                desertFrame(w: w, h: h)
            case .candy:
                candyFrame(w: w, h: h)
            case .zenGarden:
                zenGardenFrame(w: w, h: h)
            case .forsythia:
                forsythiaFrame(w: w, h: h)
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Minimal Frame

    @ViewBuilder
    private func minimalFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let gray = Color(red: 0.78, green: 0.78, blue: 0.82)
            let inset: CGFloat = 14

            // Corner L-brackets
            let bracketLen: CGFloat = 20
            let positions: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (inset, inset, 1, 1),
                (size.width - inset, inset, -1, 1),
                (size.width - inset, size.height - inset, -1, -1),
                (inset, size.height - inset, 1, -1),
            ]
            for (x, y, dx, dy) in positions {
                var bracket = Path()
                bracket.move(to: CGPoint(x: x + dx * bracketLen, y: y))
                bracket.addLine(to: CGPoint(x: x, y: y))
                bracket.addLine(to: CGPoint(x: x, y: y + dy * bracketLen))
                ctx.stroke(bracket, with: .color(gray.opacity(0.5)), lineWidth: 1.2)
            }

            // Top center dot ornament
            let centerX = size.width / 2
            for i in -2...2 {
                let dotSize: CGFloat = i == 0 ? 4 : 2.5
                let opacity: Double = i == 0 ? 0.4 : 0.25
                let dot = Path(ellipseIn: CGRect(
                    x: centerX + CGFloat(i) * 10 - dotSize / 2,
                    y: inset + 6 - dotSize / 2,
                    width: dotSize, height: dotSize))
                ctx.fill(dot, with: .color(gray.opacity(opacity)))
            }

            // Bottom center line
            var bottomLine = Path()
            bottomLine.move(to: CGPoint(x: centerX - 30, y: size.height - inset - 8))
            bottomLine.addLine(to: CGPoint(x: centerX + 30, y: size.height - inset - 8))
            ctx.stroke(bottomLine, with: .color(gray.opacity(0.25)), lineWidth: 0.8)
        }
        .frame(width: w, height: h)
    }

    // MARK: - Halloween (Yu-Gi-Oh Frame)

    @ViewBuilder
    private func halloweenFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let inset: CGFloat = 10
            let innerInset: CGFloat = 18

            // Outer frame
            let outerRect = CGRect(x: inset, y: inset, width: size.width - inset * 2, height: size.height - inset * 2)
            ctx.stroke(Path(roundedRect: outerRect, cornerRadius: 12),
                      with: .color(Color(red: 0.85, green: 0.55, blue: 0.10).opacity(0.5)),
                      lineWidth: 2)

            // Inner frame
            let innerRect = CGRect(x: innerInset, y: innerInset, width: size.width - innerInset * 2, height: size.height - innerInset * 2)
            ctx.stroke(Path(roundedRect: innerRect, cornerRadius: 8),
                      with: .color(Color(red: 0.85, green: 0.55, blue: 0.10).opacity(0.25)),
                      lineWidth: 1)

            // Corner ornaments (triangular brackets)
            let corners: [(CGFloat, CGFloat, CGFloat)] = [
                (inset + 4, inset + 4, 0),
                (size.width - inset - 4, inset + 4, 90),
                (size.width - inset - 4, size.height - inset - 4, 180),
                (inset + 4, size.height - inset - 4, 270),
            ]
            for (cx, cy, _) in corners {
                let dot = Path(ellipseIn: CGRect(x: cx - 2, y: cy - 2, width: 4, height: 4))
                ctx.fill(dot, with: .color(Color(red: 0.95, green: 0.65, blue: 0.15).opacity(0.6)))
            }

            // "Art frame" horizontal lines
            let artTop = innerInset + 50
            var line1 = Path()
            line1.move(to: CGPoint(x: innerInset + 8, y: artTop))
            line1.addLine(to: CGPoint(x: size.width - innerInset - 8, y: artTop))
            ctx.stroke(line1, with: .color(Color.orange.opacity(0.15)), lineWidth: 0.5)

            let artBottom = size.height - innerInset - 50
            var line2 = Path()
            line2.move(to: CGPoint(x: innerInset + 8, y: artBottom))
            line2.addLine(to: CGPoint(x: size.width - innerInset - 8, y: artBottom))
            ctx.stroke(line2, with: .color(Color.orange.opacity(0.15)), lineWidth: 0.5)
        }
        .frame(width: w, height: h)
    }

    // MARK: - Christmas (Victorian Frame)

    @ViewBuilder
    private func christmasFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let gold = Color(red: 0.80, green: 0.65, blue: 0.20)
            let red = Color(red: 0.85, green: 0.15, blue: 0.15)
            let green = Color(red: 0.15, green: 0.50, blue: 0.20)
            let outer: CGFloat = 12
            let inner: CGFloat = 22

            // Double frame
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 10),
                      with: .color(gold.opacity(0.5)), lineWidth: 2)
            ctx.stroke(Path(roundedRect: CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2), cornerRadius: 6),
                      with: .color(gold.opacity(0.3)), lineWidth: 1)

            // Corner holly decorations
            let corners: [(CGFloat, CGFloat, Bool, Bool)] = [
                (outer + 3, outer + 3, false, false),
                (size.width - outer - 3, outer + 3, true, false),
                (size.width - outer - 3, size.height - outer - 3, true, true),
                (outer + 3, size.height - outer - 3, false, true),
            ]
            for (x, y, flipX, flipY) in corners {
                let dx: CGFloat = flipX ? -1 : 1
                let dy: CGFloat = flipY ? -1 : 1

                // L자 장식
                let fl: CGFloat = 25
                var p = Path()
                p.move(to: CGPoint(x: x, y: y + dy * fl))
                p.addLine(to: CGPoint(x: x, y: y))
                p.addLine(to: CGPoint(x: x + dx * fl, y: y))
                ctx.stroke(p, with: .color(gold.opacity(0.6)), lineWidth: 2)

                // 홀리 잎 (두 잎)
                let leafX = x + dx * 8
                let leafY = y + dy * 8
                let leaf1 = Path(ellipseIn: CGRect(x: leafX - 5, y: leafY - 2.5, width: 10, height: 5))
                let leaf2 = Path(ellipseIn: CGRect(x: leafX - 2.5, y: leafY - 5, width: 5, height: 10))
                ctx.fill(leaf1, with: .color(green.opacity(0.25)))
                ctx.fill(leaf2, with: .color(green.opacity(0.25)))

                // 홀리 열매
                let berry = Path(ellipseIn: CGRect(x: leafX - 2, y: leafY - 2, width: 4, height: 4))
                ctx.fill(berry, with: .color(red.opacity(0.5)))
            }

            // 하단 중앙 크리스마스 트리
            let treeX = size.width / 2
            let treeBaseY = size.height - outer - 8
            let treeTopY = size.height - outer - 50

            // 트리 몸체 (3단 삼각형)
            let layers: [(CGFloat, CGFloat, CGFloat)] = [
                (treeTopY, 6, 14),         // 꼭대기
                (treeTopY + 12, 10, 18),   // 중간
                (treeTopY + 26, 14, 22),   // 아래
            ]
            for (topY, topW, botW) in layers {
                var tri = Path()
                tri.move(to: CGPoint(x: treeX, y: topY))
                tri.addLine(to: CGPoint(x: treeX - botW / 2, y: topY + 14))
                tri.addLine(to: CGPoint(x: treeX + botW / 2, y: topY + 14))
                tri.closeSubpath()
                ctx.fill(tri, with: .color(green.opacity(0.3)))
                ctx.stroke(tri, with: .color(green.opacity(0.15)), lineWidth: 0.5)

                // 트리 위 장식 (반짝이는 오너먼트)
                let ornamentPositions: [(CGFloat, CGFloat)] = [
                    (treeX - topW / 2.5, topY + 8),
                    (treeX + topW / 2.5, topY + 10),
                ]
                for (ox, oy) in ornamentPositions {
                    let ornament = Path(ellipseIn: CGRect(x: ox - 1.5, y: oy - 1.5, width: 3, height: 3))
                    ctx.fill(ornament, with: .color(red.opacity(0.5)))
                }
            }

            // 트리 줄기
            var trunk = Path()
            trunk.addRect(CGRect(x: treeX - 2.5, y: treeBaseY - 6, width: 5, height: 6))
            ctx.fill(trunk, with: .color(Color(red: 0.45, green: 0.30, blue: 0.15).opacity(0.3)))

            // 트리 꼭대기 별
            let starCX = treeX
            let starCY = treeTopY - 4
            for arm in 0..<5 {
                let angle = CGFloat(arm) * .pi * 2 / 5 - .pi / 2
                let outerX = starCX + cos(angle) * 5
                let outerY = starCY + sin(angle) * 5
                var ray = Path()
                ray.move(to: CGPoint(x: starCX, y: starCY))
                ray.addLine(to: CGPoint(x: outerX, y: outerY))
                ctx.stroke(ray, with: .color(gold.opacity(0.7)), lineWidth: 1)
            }
            let starDot = Path(ellipseIn: CGRect(x: starCX - 2, y: starCY - 2, width: 4, height: 4))
            ctx.fill(starDot, with: .color(gold.opacity(0.8)))

            // 상단 중앙 눈송이 장식
            let snowCX = size.width / 2
            let snowCY = outer + 16
            for arm in 0..<6 {
                let angle = CGFloat(arm) * .pi / 3
                let endX = snowCX + cos(angle) * 8
                let endY = snowCY + sin(angle) * 8
                var armPath = Path()
                armPath.move(to: CGPoint(x: snowCX, y: snowCY))
                armPath.addLine(to: CGPoint(x: endX, y: endY))
                ctx.stroke(armPath, with: .color(gold.opacity(0.4)), lineWidth: 0.8)

                // 가지
                let midX = snowCX + cos(angle) * 5
                let midY = snowCY + sin(angle) * 5
                for sign: CGFloat in [-1, 1] {
                    let bAngle = angle + sign * .pi / 4
                    var branch = Path()
                    branch.move(to: CGPoint(x: midX, y: midY))
                    branch.addLine(to: CGPoint(x: midX + cos(bAngle) * 3, y: midY + sin(bAngle) * 3))
                    ctx.stroke(branch, with: .color(gold.opacity(0.3)), lineWidth: 0.6)
                }
            }

            // 프레임 위 작은 눈송이들
            let miniSnowflakes: [(CGFloat, CGFloat, CGFloat)] = [
                (outer + 20, size.height * 0.3, 4),
                (size.width - outer - 20, size.height * 0.25, 3.5),
                (outer + 18, size.height * 0.7, 3),
                (size.width - outer - 18, size.height * 0.75, 4),
            ]
            for (sx, sy, sr) in miniSnowflakes {
                for arm in 0..<6 {
                    let angle = CGFloat(arm) * .pi / 3
                    var armPath = Path()
                    armPath.move(to: CGPoint(x: sx, y: sy))
                    armPath.addLine(to: CGPoint(x: sx + cos(angle) * sr, y: sy + sin(angle) * sr))
                    ctx.stroke(armPath, with: .color(gold.opacity(0.2)), lineWidth: 0.5)
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Ocean (Pokemon Frame)

    @ViewBuilder
    private func oceanFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let blue = Color(red: 0.15, green: 0.55, blue: 0.85)

            // Thick top bar (type indicator)
            var topBar = Path()
            topBar.addRoundedRect(in: CGRect(x: 0, y: 0, width: size.width, height: 50),
                                 cornerSize: CGSize(width: 20, height: 20))
            ctx.fill(topBar, with: .color(blue.opacity(0.06)))

            // Inner card frame
            let frameInset: CGFloat = 12
            ctx.stroke(Path(roundedRect: CGRect(x: frameInset, y: 55, width: size.width - frameInset * 2, height: size.height - 85), cornerRadius: 8),
                      with: .color(blue.opacity(0.15)), lineWidth: 1)

            // Bottom info bar
            var bottomBar = Path()
            bottomBar.addRect(CGRect(x: frameInset, y: size.height - 28, width: size.width - frameInset * 2, height: 1))
            ctx.fill(bottomBar, with: .color(blue.opacity(0.15)))

            // Water wave pattern on bottom edge
            for i in 0..<6 {
                let x = CGFloat(i) * (size.width / 5)
                let wave = Path(ellipseIn: CGRect(x: x - 15, y: size.height - 10, width: 30, height: 12))
                ctx.fill(wave, with: .color(blue.opacity(0.04)))
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Space (MTG Frame)

    @ViewBuilder
    private func spaceFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let purple = Color(red: 0.45, green: 0.25, blue: 0.85)

            // Card frame - MTG style with thick border
            let outer: CGFloat = 8
            let borderWidth: CGFloat = 6
            let outerRect = CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2)
            ctx.stroke(Path(roundedRect: outerRect, cornerRadius: 8),
                      with: .color(purple.opacity(0.2)), lineWidth: borderWidth)

            // Art frame area (upper half)
            let artFrame = CGRect(x: outer + borderWidth + 4, y: outer + borderWidth + 30, width: size.width - (outer + borderWidth + 4) * 2, height: 4)
            ctx.fill(Path(artFrame), with: .color(purple.opacity(0.1)))

            // Text box divider (lower area)
            let textDiv = CGRect(x: outer + borderWidth + 4, y: size.height * 0.68, width: size.width - (outer + borderWidth + 4) * 2, height: 4)
            ctx.fill(Path(textDiv), with: .color(purple.opacity(0.1)))

            // Constellation dots in frame border
            let constellations: [(CGFloat, CGFloat)] = [
                (20, 20), (size.width - 20, 25), (15, size.height / 2),
                (size.width - 18, size.height / 2 + 15),
                (22, size.height - 22), (size.width - 22, size.height - 18)
            ]
            for (x, y) in constellations {
                let star = Path(ellipseIn: CGRect(x: x - 1.5, y: y - 1.5, width: 3, height: 3))
                ctx.fill(star, with: .color(purple.opacity(0.5)))
            }

            // Connect some constellation dots
            var line = Path()
            line.move(to: CGPoint(x: 20, y: 20))
            line.addLine(to: CGPoint(x: 15, y: size.height / 2))
            line.addLine(to: CGPoint(x: 22, y: size.height - 22))
            ctx.stroke(line, with: .color(purple.opacity(0.1)), lineWidth: 0.5)
        }
        .frame(width: w, height: h)
    }

    // MARK: - Cherry Blossom (Hanafuda Frame)

    @ViewBuilder
    private func cherryBlossomFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let pink = Color(red: 0.90, green: 0.50, blue: 0.60)

            // Simple elegant frame
            let inset: CGFloat = 14
            ctx.stroke(Path(roundedRect: CGRect(x: inset, y: inset, width: size.width - inset * 2, height: size.height - inset * 2), cornerRadius: 20),
                      with: .color(pink.opacity(0.2)), lineWidth: 1)

            // Branch with blossoms - top left to center
            var branch = Path()
            branch.move(to: CGPoint(x: 0, y: size.height * 0.15))
            branch.addCurve(to: CGPoint(x: size.width * 0.4, y: size.height * 0.08),
                           control1: CGPoint(x: size.width * 0.1, y: size.height * 0.12),
                           control2: CGPoint(x: size.width * 0.25, y: size.height * 0.05))
            ctx.stroke(branch, with: .color(Color(red: 0.45, green: 0.30, blue: 0.25).opacity(0.15)), lineWidth: 1.5)

            // Small branch
            var twig = Path()
            twig.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.11))
            twig.addQuadCurve(to: CGPoint(x: size.width * 0.15, y: size.height * 0.04),
                             control: CGPoint(x: size.width * 0.12, y: size.height * 0.06))
            ctx.stroke(twig, with: .color(Color(red: 0.45, green: 0.30, blue: 0.25).opacity(0.12)), lineWidth: 1)

            // Blossom petals along branch
            let blossomPositions: [(CGFloat, CGFloat, CGFloat)] = [
                (size.width * 0.12, size.height * 0.13, 10),
                (size.width * 0.22, size.height * 0.09, 12),
                (size.width * 0.35, size.height * 0.07, 11),
                (size.width * 0.15, size.height * 0.05, 8),
            ]
            for (x, y, r) in blossomPositions {
                // 5-petal flower
                for p in 0..<5 {
                    let angle = CGFloat(p) * .pi * 2 / 5 - .pi / 2
                    let px = x + cos(angle) * r * 0.6
                    let py = y + sin(angle) * r * 0.6
                    let petal = Path(ellipseIn: CGRect(x: px - r * 0.4, y: py - r * 0.25, width: r * 0.8, height: r * 0.5))
                    ctx.fill(petal, with: .color(pink.opacity(0.12)))
                }
                // Center
                let center = Path(ellipseIn: CGRect(x: x - 2, y: y - 2, width: 4, height: 4))
                ctx.fill(center, with: .color(Color(red: 0.95, green: 0.75, blue: 0.20).opacity(0.2)))
            }

            // Bottom right branch
            var branch2 = Path()
            branch2.move(to: CGPoint(x: size.width, y: size.height * 0.88))
            branch2.addCurve(to: CGPoint(x: size.width * 0.65, y: size.height * 0.92),
                            control1: CGPoint(x: size.width * 0.9, y: size.height * 0.9),
                            control2: CGPoint(x: size.width * 0.75, y: size.height * 0.95))
            ctx.stroke(branch2, with: .color(Color(red: 0.45, green: 0.30, blue: 0.25).opacity(0.12)), lineWidth: 1.5)

            // Scattered petals (falling)
            let fallingPetals: [(CGFloat, CGFloat, CGFloat)] = [
                (size.width * 0.75, size.height * 0.25, 15),
                (size.width * 0.85, size.height * 0.45, -25),
                (size.width * 0.3, size.height * 0.8, 40),
            ]
            for (x, y, rot) in fallingPetals {
                ctx.drawLayer { layerCtx in
                    let transform = CGAffineTransform(translationX: x, y: y)
                        .rotated(by: rot * .pi / 180)
                    var petal = Path()
                    petal.move(to: CGPoint(x: 0, y: -5))
                    petal.addQuadCurve(to: CGPoint(x: 0, y: 5), control: CGPoint(x: 5, y: 0))
                    petal.addQuadCurve(to: CGPoint(x: 0, y: -5), control: CGPoint(x: -3, y: 0))
                    layerCtx.fill(petal.applying(transform), with: .color(pink.opacity(0.10)))
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Retro (Arcade Frame)

    @ViewBuilder
    private func retroFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let green = Color(red: 0.10, green: 0.95, blue: 0.40)

            // Pixel-style double frame
            let outer: CGFloat = 8
            let inner: CGFloat = 14
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 2),
                      with: .color(green.opacity(0.6)), lineWidth: 2)
            ctx.stroke(Path(roundedRect: CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2), cornerRadius: 1),
                      with: .color(green.opacity(0.2)), lineWidth: 1)

            // Scanline effect
            for y in stride(from: 0, to: size.height, by: 3) {
                var line = Path()
                line.addRect(CGRect(x: 0, y: y, width: size.width, height: 1))
                ctx.fill(line, with: .color(green.opacity(0.015)))
            }

            // Corner brackets
            let bracketLen: CGFloat = 15
            let bPositions: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (outer + 2, outer + 2, 1, 1),
                (size.width - outer - 2, outer + 2, -1, 1),
                (size.width - outer - 2, size.height - outer - 2, -1, -1),
                (outer + 2, size.height - outer - 2, 1, -1),
            ]
            for (x, y, dx, dy) in bPositions {
                var bracket = Path()
                bracket.move(to: CGPoint(x: x + dx * bracketLen, y: y))
                bracket.addLine(to: CGPoint(x: x, y: y))
                bracket.addLine(to: CGPoint(x: x, y: y + dy * bracketLen))
                ctx.stroke(bracket, with: .color(green.opacity(0.5)), lineWidth: 2)
            }

            // "INSERT COIN" blinking effect area at bottom
            var coinArea = Path()
            coinArea.addRect(CGRect(x: size.width * 0.3, y: size.height - 12, width: size.width * 0.4, height: 1))
            ctx.fill(coinArea, with: .color(green.opacity(0.1)))
        }
        .frame(width: w, height: h)
    }

    // MARK: - Autumn (Tarot Frame)

    @ViewBuilder
    private func autumnFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let brown = Color(red: 0.65, green: 0.45, blue: 0.20)

            // Ornate double frame
            let outer: CGFloat = 10
            let inner: CGFloat = 18
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 14),
                      with: .color(brown.opacity(0.4)), lineWidth: 2)
            ctx.stroke(Path(roundedRect: CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2), cornerRadius: 10),
                      with: .color(brown.opacity(0.2)), lineWidth: 1)

            // Frame decoration - diamond pattern between frames
            let midFrame = (outer + inner) / 2
            for i in stride(from: midFrame + 15, to: size.width - midFrame - 15, by: 20) {
                var diamond = Path()
                diamond.move(to: CGPoint(x: i, y: outer + 1))
                diamond.addLine(to: CGPoint(x: i + 4, y: midFrame))
                diamond.addLine(to: CGPoint(x: i, y: inner - 1))
                diamond.addLine(to: CGPoint(x: i - 4, y: midFrame))
                diamond.closeSubpath()
                ctx.fill(diamond, with: .color(brown.opacity(0.15)))
            }

            // Bottom diamonds too
            for i in stride(from: midFrame + 15, to: size.width - midFrame - 15, by: 20) {
                var diamond = Path()
                diamond.move(to: CGPoint(x: i, y: size.height - inner + 1))
                diamond.addLine(to: CGPoint(x: i + 4, y: size.height - midFrame))
                diamond.addLine(to: CGPoint(x: i, y: size.height - outer - 1))
                diamond.addLine(to: CGPoint(x: i - 4, y: size.height - midFrame))
                diamond.closeSubpath()
                ctx.fill(diamond, with: .color(brown.opacity(0.15)))
            }

            // Moon phases at top center
            let moonY: CGFloat = inner + 8
            let phases: [(CGFloat, CGFloat)] = [
                (size.width / 2 - 24, 4), (size.width / 2 - 12, 5),
                (size.width / 2, 6),
                (size.width / 2 + 12, 5), (size.width / 2 + 24, 4)
            ]
            for (x, r) in phases {
                let moon = Path(ellipseIn: CGRect(x: x - r, y: moonY - r, width: r * 2, height: r * 2))
                if r == 6 {
                    ctx.fill(moon, with: .color(brown.opacity(0.25)))
                } else {
                    ctx.stroke(moon, with: .color(brown.opacity(0.2)), lineWidth: 0.8)
                }
            }

            // Corner sun/star symbols
            let cornerSymbols: [(CGFloat, CGFloat)] = [
                (inner + 8, inner + 8),
                (size.width - inner - 8, inner + 8),
                (inner + 8, size.height - inner - 8),
                (size.width - inner - 8, size.height - inner - 8),
            ]
            for (x, y) in cornerSymbols {
                // 8-point star
                for ray in 0..<8 {
                    let angle = CGFloat(ray) * .pi / 4
                    var rayPath = Path()
                    rayPath.move(to: CGPoint(x: x, y: y))
                    rayPath.addLine(to: CGPoint(x: x + cos(angle) * 6, y: y + sin(angle) * 6))
                    ctx.stroke(rayPath, with: .color(brown.opacity(0.2)), lineWidth: 0.8)
                }
                let dot = Path(ellipseIn: CGRect(x: x - 2, y: y - 2, width: 4, height: 4))
                ctx.fill(dot, with: .color(brown.opacity(0.3)))
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Aurora (Holographic Frame)

    @ViewBuilder
    private func auroraFrame(w: CGFloat, h: CGFloat) -> some View {
        // Prismatic rainbow edge glow
        RoundedRectangle(cornerRadius: 24)
            .stroke(
                AngularGradient(
                    colors: [
                        Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.4),
                        Color(red: 0.20, green: 0.60, blue: 0.90).opacity(0.3),
                        Color(red: 0.70, green: 0.20, blue: 0.80).opacity(0.4),
                        Color(red: 0.90, green: 0.40, blue: 0.20).opacity(0.3),
                        Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.4),
                    ],
                    center: .center
                ),
                lineWidth: 2.5
            )
            .blur(radius: 1)
            .frame(width: w, height: h)

        // Outer glow halo
        RoundedRectangle(cornerRadius: 24)
            .stroke(
                AngularGradient(
                    colors: [
                        Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.15),
                        Color(red: 0.70, green: 0.20, blue: 0.80).opacity(0.12),
                        Color(red: 0.10, green: 0.90, blue: 0.50).opacity(0.15),
                    ],
                    center: .center
                ),
                lineWidth: 10
            )
            .blur(radius: 8)
            .frame(width: w, height: h)

        // Inner frame
        Canvas { ctx, size in
            let inset: CGFloat = 16
            ctx.stroke(Path(roundedRect: CGRect(x: inset, y: inset, width: size.width - inset * 2, height: size.height - inset * 2), cornerRadius: 18),
                      with: .color(Color.white.opacity(0.08)), lineWidth: 0.5)

            // Holographic diamond pattern
            for row in 0..<Int(size.height / 30) {
                for col in 0..<Int(size.width / 30) {
                    let x = CGFloat(col) * 30 + (row % 2 == 0 ? 0 : 15)
                    let y = CGFloat(row) * 30
                    let hue = (x + y) / (size.width + size.height)
                    var diamond = Path()
                    diamond.move(to: CGPoint(x: x, y: y - 3))
                    diamond.addLine(to: CGPoint(x: x + 3, y: y))
                    diamond.addLine(to: CGPoint(x: x, y: y + 3))
                    diamond.addLine(to: CGPoint(x: x - 3, y: y))
                    diamond.closeSubpath()
                    ctx.fill(diamond, with: .color(Color(hue: hue, saturation: 0.5, brightness: 1.0).opacity(0.04)))
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Circus (Playing Card Frame)

    @ViewBuilder
    private func circusFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let red = Color(red: 0.85, green: 0.15, blue: 0.20)
            let gold = Color(red: 0.85, green: 0.70, blue: 0.15)

            // Outer ornate frame
            let outer: CGFloat = 10
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 14),
                      with: .color(red.opacity(0.5)), lineWidth: 2.5)

            // Inner frame
            let inner: CGFloat = 18
            ctx.stroke(Path(roundedRect: CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2), cornerRadius: 10),
                      with: .color(red.opacity(0.2)), lineWidth: 1)

            // Corner suit decorations (4 corners with different suits)
            let suits = ["heart.fill", "diamond.fill", "suit.club.fill", "suit.spade.fill"]
            let cornerPositions: [(CGFloat, CGFloat, Int)] = [
                (outer + 6, outer + 6, 0),
                (size.width - outer - 6, outer + 6, 1),
                (outer + 6, size.height - outer - 6, 2),
                (size.width - outer - 6, size.height - outer - 6, 3),
            ]
            for (x, y, idx) in cornerPositions {
                // Background circle for suit
                let bg = Path(ellipseIn: CGRect(x: x - 6, y: y - 6, width: 12, height: 12))
                ctx.fill(bg, with: .color(gold.opacity(0.15)))
                let _ = suits[idx] // suits used conceptually
            }

            // Center line ornament
            let centerY = size.height / 2
            var centerLine = Path()
            centerLine.move(to: CGPoint(x: inner + 10, y: centerY))
            centerLine.addLine(to: CGPoint(x: size.width / 2 - 15, y: centerY))
            ctx.stroke(centerLine, with: .color(red.opacity(0.1)), lineWidth: 0.5)

            var centerLine2 = Path()
            centerLine2.move(to: CGPoint(x: size.width / 2 + 15, y: centerY))
            centerLine2.addLine(to: CGPoint(x: size.width - inner - 10, y: centerY))
            ctx.stroke(centerLine2, with: .color(red.opacity(0.1)), lineWidth: 0.5)

            // Center diamond
            var centerDiamond = Path()
            centerDiamond.move(to: CGPoint(x: size.width / 2, y: centerY - 8))
            centerDiamond.addLine(to: CGPoint(x: size.width / 2 + 8, y: centerY))
            centerDiamond.addLine(to: CGPoint(x: size.width / 2, y: centerY + 8))
            centerDiamond.addLine(to: CGPoint(x: size.width / 2 - 8, y: centerY))
            centerDiamond.closeSubpath()
            ctx.stroke(centerDiamond, with: .color(red.opacity(0.2)), lineWidth: 1)

            // Radiating stripes at very top
            for i in 0..<8 {
                let angle = CGFloat(i) * .pi / 8 + .pi / 16
                var ray = Path()
                ray.move(to: CGPoint(x: size.width / 2, y: 0))
                let endX = size.width / 2 + cos(angle - .pi / 2) * 60
                let endY = sin(angle - .pi / 2) * 60
                ray.addLine(to: CGPoint(x: endX, y: -endY))
                if i % 2 == 0 {
                    ctx.stroke(ray, with: .color(red.opacity(0.04)), lineWidth: 12)
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Desert (Egyptian Frame)

    @ViewBuilder
    private func desertFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let gold = Color(red: 0.90, green: 0.75, blue: 0.35)

            // Egyptian-style frame with stepped pattern
            let outer: CGFloat = 10
            let inner: CGFloat = 20
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 10),
                      with: .color(gold.opacity(0.4)), lineWidth: 2)
            ctx.stroke(Path(roundedRect: CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2), cornerRadius: 6),
                      with: .color(gold.opacity(0.2)), lineWidth: 1)

            // Hieroglyphic pattern along sides
            let symbolSpacing: CGFloat = 22
            for y in stride(from: inner + 20, to: size.height - inner - 20, by: symbolSpacing) {
                // Left side symbols
                let shapes: [[(CGFloat, CGFloat, CGFloat, CGFloat)]] = [
                    // Triangle
                    [],
                    // Circle
                    [],
                    // Ankh-like cross
                    [],
                ]
                let shapeIdx = Int(y / symbolSpacing) % 3
                let x: CGFloat = (outer + inner) / 2

                switch shapeIdx {
                case 0:
                    var tri = Path()
                    tri.move(to: CGPoint(x: x, y: y - 4))
                    tri.addLine(to: CGPoint(x: x + 4, y: y + 4))
                    tri.addLine(to: CGPoint(x: x - 4, y: y + 4))
                    tri.closeSubpath()
                    ctx.stroke(tri, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                case 1:
                    let circle = Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
                    ctx.stroke(circle, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                default:
                    var ankh = Path()
                    ankh.addEllipse(in: CGRect(x: x - 3, y: y - 5, width: 6, height: 5))
                    ankh.move(to: CGPoint(x: x, y: y))
                    ankh.addLine(to: CGPoint(x: x, y: y + 5))
                    ankh.move(to: CGPoint(x: x - 3, y: y + 2))
                    ankh.addLine(to: CGPoint(x: x + 3, y: y + 2))
                    ctx.stroke(ankh, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                }

                // Right side - mirror
                let rx = size.width - (outer + inner) / 2
                switch shapeIdx {
                case 0:
                    var tri = Path()
                    tri.move(to: CGPoint(x: rx, y: y - 4))
                    tri.addLine(to: CGPoint(x: rx + 4, y: y + 4))
                    tri.addLine(to: CGPoint(x: rx - 4, y: y + 4))
                    tri.closeSubpath()
                    ctx.stroke(tri, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                case 1:
                    let circle = Path(ellipseIn: CGRect(x: rx - 3, y: y - 3, width: 6, height: 6))
                    ctx.stroke(circle, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                default:
                    var ankh = Path()
                    ankh.addEllipse(in: CGRect(x: rx - 3, y: y - 5, width: 6, height: 5))
                    ankh.move(to: CGPoint(x: rx, y: y))
                    ankh.addLine(to: CGPoint(x: rx, y: y + 5))
                    ankh.move(to: CGPoint(x: rx - 3, y: y + 2))
                    ankh.addLine(to: CGPoint(x: rx + 3, y: y + 2))
                    ctx.stroke(ankh, with: .color(gold.opacity(0.25)), lineWidth: 0.8)
                }

                let _ = shapes // suppress warning
            }

            // Top center - winged sun disc
            let topCenter = CGPoint(x: size.width / 2, y: inner + 6)
            let disc = Path(ellipseIn: CGRect(x: topCenter.x - 5, y: topCenter.y - 5, width: 10, height: 10))
            ctx.fill(disc, with: .color(gold.opacity(0.3)))

            // Wings
            var leftWing = Path()
            leftWing.move(to: CGPoint(x: topCenter.x - 5, y: topCenter.y))
            leftWing.addQuadCurve(to: CGPoint(x: topCenter.x - 35, y: topCenter.y + 2),
                                 control: CGPoint(x: topCenter.x - 20, y: topCenter.y - 8))
            ctx.stroke(leftWing, with: .color(gold.opacity(0.25)), lineWidth: 1.5)

            var rightWing = Path()
            rightWing.move(to: CGPoint(x: topCenter.x + 5, y: topCenter.y))
            rightWing.addQuadCurve(to: CGPoint(x: topCenter.x + 35, y: topCenter.y + 2),
                                  control: CGPoint(x: topCenter.x + 20, y: topCenter.y - 8))
            ctx.stroke(rightWing, with: .color(gold.opacity(0.25)), lineWidth: 1.5)

            // Bottom scarab
            let botCenter = CGPoint(x: size.width / 2, y: size.height - inner - 6)
            let scarab = Path(ellipseIn: CGRect(x: botCenter.x - 6, y: botCenter.y - 4, width: 12, height: 8))
            ctx.fill(scarab, with: .color(gold.opacity(0.15)))
            // Scarab legs
            for side in [-1.0, 1.0] {
                for leg in 0..<3 {
                    var legPath = Path()
                    let lx = botCenter.x + CGFloat(side) * 6
                    let ly = botCenter.y - 2 + CGFloat(leg) * 3
                    legPath.move(to: CGPoint(x: lx, y: ly))
                    legPath.addLine(to: CGPoint(x: lx + CGFloat(side) * 8, y: ly - 2))
                    ctx.stroke(legPath, with: .color(gold.opacity(0.15)), lineWidth: 0.5)
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Candy Frame

    @ViewBuilder
    private func candyFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let pink = Color(red: 0.95, green: 0.35, blue: 0.55)
            let mint = Color(red: 0.55, green: 0.85, blue: 0.75)
            let yellow = Color(red: 0.98, green: 0.80, blue: 0.25)

            // Rounded outer frame
            let outer: CGFloat = 10
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 24),
                      with: .color(pink.opacity(0.35)), lineWidth: 3)

            // Inner dotted frame
            let inner: CGFloat = 18
            let innerRect = CGRect(x: inner, y: inner, width: size.width - inner * 2, height: size.height - inner * 2)
            ctx.stroke(Path(roundedRect: innerRect, cornerRadius: 20),
                      with: .color(mint.opacity(0.3)), style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))

            // Corner lollipop circles
            let corners: [(CGFloat, CGFloat)] = [
                (outer + 6, outer + 6),
                (size.width - outer - 6, outer + 6),
                (outer + 6, size.height - outer - 6),
                (size.width - outer - 6, size.height - outer - 6),
            ]
            let colors = [pink, mint, yellow, pink]
            for (i, (x, y)) in corners.enumerated() {
                let circle = Path(ellipseIn: CGRect(x: x - 5, y: y - 5, width: 10, height: 10))
                ctx.fill(circle, with: .color(colors[i].opacity(0.3)))
                let innerCircle = Path(ellipseIn: CGRect(x: x - 2.5, y: y - 2.5, width: 5, height: 5))
                ctx.fill(innerCircle, with: .color(colors[i].opacity(0.2)))
            }

            // Scattered sprinkles in border area
            let sprinklePositions: [(CGFloat, CGFloat, CGFloat, Color)] = [
                (size.width * 0.3, outer + 4, 30, mint),
                (size.width * 0.6, outer + 5, -20, yellow),
                (size.width * 0.8, outer + 3, 45, pink),
                (outer + 4, size.height * 0.4, 70, yellow),
                (outer + 5, size.height * 0.7, -15, mint),
                (size.width - outer - 4, size.height * 0.35, -60, pink),
                (size.width - outer - 5, size.height * 0.65, 25, yellow),
                (size.width * 0.25, size.height - outer - 4, -35, pink),
                (size.width * 0.55, size.height - outer - 5, 50, mint),
                (size.width * 0.75, size.height - outer - 3, -10, yellow),
            ]
            for (x, y, rot, color) in sprinklePositions {
                ctx.drawLayer { layerCtx in
                    let transform = CGAffineTransform(translationX: x, y: y)
                        .rotated(by: rot * .pi / 180)
                    var sprinkle = Path()
                    sprinkle.addRoundedRect(in: CGRect(x: -4, y: -1, width: 8, height: 2), cornerSize: CGSize(width: 1, height: 1))
                    layerCtx.fill(sprinkle.applying(transform), with: .color(color.opacity(0.3)))
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Forsythia Frame (개나리)

    @ViewBuilder
    private func forsythiaFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let yellow = Color(red: 0.98, green: 0.85, blue: 0.08)
            let darkYellow = Color(red: 0.85, green: 0.65, blue: 0.08)
            let brown = Color(red: 0.55, green: 0.42, blue: 0.20)
            let green = Color(red: 0.45, green: 0.60, blue: 0.25)

            // Simple frame
            let outer: CGFloat = 12
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 18),
                      with: .color(yellow.opacity(0.35)), lineWidth: 1.5)

            // --- Helper: draw a daisy at (cx, cy) with given radius ---
            func drawDaisy(cx: CGFloat, cy: CGFloat, petalCount: Int, petalW: CGFloat, petalH: CGFloat, opacity: Double) {
                for p in 0..<petalCount {
                    let angle = CGFloat(p) * (.pi * 2 / CGFloat(petalCount))
                    let px = cx + cos(angle) * petalH * 0.55
                    let py = cy + sin(angle) * petalH * 0.55
                    let petal = Path(ellipseIn: CGRect(x: px - petalW / 2, y: py - petalH / 2, width: petalW, height: petalH))
                    ctx.fill(petal, with: .color(yellow.opacity(opacity)))
                }
                let center = Path(ellipseIn: CGRect(x: cx - petalW * 0.4, y: cy - petalW * 0.4, width: petalW * 0.8, height: petalW * 0.8))
                ctx.fill(center, with: .color(darkYellow.opacity(opacity * 0.8)))
            }

            // Top-left branch curving across top
            var branch = Path()
            branch.move(to: CGPoint(x: 0, y: size.height * 0.12))
            branch.addCurve(to: CGPoint(x: size.width * 0.5, y: size.height * 0.06),
                           control1: CGPoint(x: size.width * 0.12, y: size.height * 0.08),
                           control2: CGPoint(x: size.width * 0.3, y: size.height * 0.03))
            ctx.stroke(branch, with: .color(brown.opacity(0.20)), lineWidth: 1.5)

            // Small twig
            var twig = Path()
            twig.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.07))
            twig.addQuadCurve(to: CGPoint(x: size.width * 0.20, y: size.height * 0.02),
                             control: CGPoint(x: size.width * 0.18, y: size.height * 0.04))
            ctx.stroke(twig, with: .color(brown.opacity(0.16)), lineWidth: 1)

            // Forsythia flowers along top branch (4-petal)
            let flowerPositions: [(CGFloat, CGFloat, CGFloat)] = [
                (size.width * 0.10, size.height * 0.10, 9),
                (size.width * 0.22, size.height * 0.065, 11),
                (size.width * 0.38, size.height * 0.05, 10),
                (size.width * 0.18, size.height * 0.03, 7),
            ]
            for (x, y, r) in flowerPositions {
                for p in 0..<4 {
                    let angle = CGFloat(p) * .pi / 2 + .pi / 4
                    let px = x + cos(angle) * r * 0.5
                    let py = y + sin(angle) * r * 0.5
                    let petal = Path(ellipseIn: CGRect(x: px - r * 0.35, y: py - r * 0.2, width: r * 0.7, height: r * 0.4))
                    ctx.fill(petal, with: .color(yellow.opacity(0.22)))
                }
                let center = Path(ellipseIn: CGRect(x: x - 1.5, y: y - 1.5, width: 3, height: 3))
                ctx.fill(center, with: .color(darkYellow.opacity(0.25)))
            }

            // Leaf buds
            let leafPositions: [(CGFloat, CGFloat)] = [
                (size.width * 0.15, size.height * 0.09),
                (size.width * 0.32, size.height * 0.055),
                (size.width * 0.45, size.height * 0.06),
            ]
            for (x, y) in leafPositions {
                var leaf = Path()
                leaf.move(to: CGPoint(x: x, y: y))
                leaf.addQuadCurve(to: CGPoint(x: x + 6, y: y - 4), control: CGPoint(x: x + 4, y: y - 5))
                ctx.stroke(leaf, with: .color(green.opacity(0.18)), lineWidth: 1)
            }

            // --- Daisy flowers in corners ---
            // Top-right daisy
            drawDaisy(cx: size.width - outer - 18, cy: outer + 18, petalCount: 8, petalW: 6, petalH: 11, opacity: 0.20)
            // Bottom-left daisy
            drawDaisy(cx: outer + 20, cy: size.height - outer - 20, petalCount: 8, petalW: 7, petalH: 12, opacity: 0.18)

            // --- Smaller daisies scattered ---
            drawDaisy(cx: size.width * 0.82, cy: size.height * 0.22, petalCount: 6, petalW: 4, petalH: 8, opacity: 0.12)
            drawDaisy(cx: size.width * 0.15, cy: size.height * 0.78, petalCount: 6, petalW: 4, petalH: 8, opacity: 0.12)

            // Bottom-right branch
            var branch2 = Path()
            branch2.move(to: CGPoint(x: size.width, y: size.height * 0.88))
            branch2.addCurve(to: CGPoint(x: size.width * 0.55, y: size.height * 0.94),
                            control1: CGPoint(x: size.width * 0.88, y: size.height * 0.92),
                            control2: CGPoint(x: size.width * 0.70, y: size.height * 0.96))
            ctx.stroke(branch2, with: .color(brown.opacity(0.16)), lineWidth: 1.5)

            // Flowers on bottom branch
            let botFlowers: [(CGFloat, CGFloat, CGFloat)] = [
                (size.width * 0.88, size.height * 0.90, 8),
                (size.width * 0.72, size.height * 0.94, 10),
                (size.width * 0.60, size.height * 0.94, 7),
            ]
            for (x, y, r) in botFlowers {
                for p in 0..<4 {
                    let angle = CGFloat(p) * .pi / 2 + .pi / 4
                    let px = x + cos(angle) * r * 0.5
                    let py = y + sin(angle) * r * 0.5
                    let petal = Path(ellipseIn: CGRect(x: px - r * 0.35, y: py - r * 0.2, width: r * 0.7, height: r * 0.4))
                    ctx.fill(petal, with: .color(yellow.opacity(0.18)))
                }
            }

            // Scattered falling petals
            let fallingPetals: [(CGFloat, CGFloat, CGFloat)] = [
                (size.width * 0.80, size.height * 0.35, 20),
                (size.width * 0.25, size.height * 0.70, -30),
                (size.width * 0.65, size.height * 0.50, 45),
                (size.width * 0.45, size.height * 0.40, -15),
            ]
            for (x, y, rot) in fallingPetals {
                ctx.drawLayer { layerCtx in
                    let transform = CGAffineTransform(translationX: x, y: y)
                        .rotated(by: rot * .pi / 180)
                    var petal = Path()
                    petal.addEllipse(in: CGRect(x: -3, y: -2, width: 6, height: 4))
                    layerCtx.fill(petal.applying(transform), with: .color(yellow.opacity(0.14)))
                }
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - Zen Garden Frame

    @ViewBuilder
    private func zenGardenFrame(w: CGFloat, h: CGFloat) -> some View {
        Canvas { ctx, size in
            let stone = Color(red: 0.40, green: 0.42, blue: 0.38)

            // Simple thin frame
            let outer: CGFloat = 12
            ctx.stroke(Path(roundedRect: CGRect(x: outer, y: outer, width: size.width - outer * 2, height: size.height - outer * 2), cornerRadius: 16),
                      with: .color(stone.opacity(0.2)), lineWidth: 1)

            // Zen sand wave pattern (top area)
            let waveY: CGFloat = outer + 12
            for row in 0..<3 {
                let y = waveY + CGFloat(row) * 8
                var wave = Path()
                wave.move(to: CGPoint(x: outer + 20, y: y))
                let segments = 8
                let segWidth = (size.width - outer * 2 - 40) / CGFloat(segments)
                for s in 0..<segments {
                    let sx = outer + 20 + CGFloat(s) * segWidth
                    wave.addQuadCurve(
                        to: CGPoint(x: sx + segWidth, y: y),
                        control: CGPoint(x: sx + segWidth * 0.5, y: y + (s % 2 == 0 ? -3 : 3))
                    )
                }
                ctx.stroke(wave, with: .color(stone.opacity(0.08 + Double(row) * 0.02)), lineWidth: 0.6)
            }

            // Bottom zen wave pattern
            let botWaveY = size.height - outer - 30
            for row in 0..<3 {
                let y = botWaveY + CGFloat(row) * 8
                var wave = Path()
                wave.move(to: CGPoint(x: outer + 20, y: y))
                let segments = 8
                let segWidth = (size.width - outer * 2 - 40) / CGFloat(segments)
                for s in 0..<segments {
                    let sx = outer + 20 + CGFloat(s) * segWidth
                    wave.addQuadCurve(
                        to: CGPoint(x: sx + segWidth, y: y),
                        control: CGPoint(x: sx + segWidth * 0.5, y: y + (s % 2 == 0 ? -3 : 3))
                    )
                }
                ctx.stroke(wave, with: .color(stone.opacity(0.08 + Double(row) * 0.02)), lineWidth: 0.6)
            }

            // Corner stones (simple circles)
            let stonePositions: [(CGFloat, CGFloat, CGFloat)] = [
                (outer + 14, outer + 14, 6),
                (size.width - outer - 14, size.height - outer - 14, 8),
                (size.width - outer - 16, outer + 16, 5),
            ]
            for (x, y, r) in stonePositions {
                let s = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
                ctx.fill(s, with: .color(stone.opacity(0.1)))
                ctx.stroke(s, with: .color(stone.opacity(0.15)), lineWidth: 0.5)
            }

            // Bamboo accent (left side)
            var bamboo = Path()
            bamboo.move(to: CGPoint(x: outer + 8, y: size.height * 0.35))
            bamboo.addLine(to: CGPoint(x: outer + 8, y: size.height * 0.65))
            ctx.stroke(bamboo, with: .color(Color(red: 0.45, green: 0.55, blue: 0.35).opacity(0.12)), lineWidth: 1.5)

            // Bamboo nodes
            for nodeY in stride(from: size.height * 0.4, to: size.height * 0.6, by: 20) {
                var node = Path()
                node.move(to: CGPoint(x: outer + 5, y: nodeY))
                node.addLine(to: CGPoint(x: outer + 11, y: nodeY))
                ctx.stroke(node, with: .color(Color(red: 0.45, green: 0.55, blue: 0.35).opacity(0.15)), lineWidth: 1)
            }
        }
        .frame(width: w, height: h)
    }
}
