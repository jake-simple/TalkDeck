import SwiftUI

enum AppTheme: String, CaseIterable {
    case minimal
    case halloween
    case christmas
    case ocean
    case space
    case cherryBlossom
    case retroGame
    case autumn
    case aurora
    case circus
    case desert
    case candy
    case zenGarden

    var name: String {
        switch self {
        case .minimal: "Minimal"
        case .halloween: "Halloween"
        case .christmas: "Christmas"
        case .ocean: "Deep Ocean"
        case .space: "Galaxy"
        case .cherryBlossom: "Cherry Blossom"
        case .retroGame: "Retro Arcade"
        case .autumn: "Autumn Leaves"
        case .aurora: "Aurora"
        case .circus: "Carnival"
        case .desert: "Desert Night"
        case .candy: "Candy Pop"
        case .zenGarden: "Zen Garden"
        }
    }

    var themeEmoji: String {
        switch self {
        case .minimal: "⬜"
        case .halloween: "🎃"
        case .christmas: "🎄"
        case .ocean: "🌊"
        case .space: "🚀"
        case .cherryBlossom: "🌸"
        case .retroGame: "🕹️"
        case .autumn: "🍂"
        case .aurora: "🌌"
        case .circus: "🎪"
        case .desert: "🏜️"
        case .candy: "🍬"
        case .zenGarden: "🪨"
        }
    }

    var themeIconName: String {
        switch self {
        case .minimal: "square.on.square"
        case .halloween: "moon.fill"
        case .christmas: "gift.fill"
        case .ocean: "water.waves"
        case .space: "sparkles"
        case .cherryBlossom: "leaf.fill"
        case .retroGame: "gamecontroller.fill"
        case .autumn: "wind"
        case .aurora: "moonphase.waxing.gibbous"
        case .circus: "star.circle.fill"
        case .desert: "sun.max.fill"
        case .candy: "birthday.cake.fill"
        case .zenGarden: "leaf.fill"
        }
    }

    // MARK: - Card

    var cardCornerRadius: CGFloat {
        switch self {
        case .minimal: 16
        case .halloween: 16
        case .christmas: 14
        case .ocean: 20
        case .space: 12
        case .cherryBlossom: 28
        case .retroGame: 4
        case .autumn: 18
        case .aurora: 24
        case .circus: 18
        case .desert: 14
        case .candy: 28
        case .zenGarden: 20
        }
    }

    // MARK: - Colors

    var backgroundGradientColors: [Color] {
        switch self {
        case .minimal:
            [Color(red: 0.96, green: 0.96, blue: 0.97), Color(red: 0.92, green: 0.92, blue: 0.94)]
        case .halloween:
            [Color(red: 0.12, green: 0.05, blue: 0.18), Color(red: 0.08, green: 0.02, blue: 0.12)]
        case .christmas:
            [Color(red: 0.08, green: 0.18, blue: 0.10), Color(red: 0.05, green: 0.12, blue: 0.06)]
        case .ocean:
            [Color(red: 0.02, green: 0.12, blue: 0.28), Color(red: 0.01, green: 0.06, blue: 0.18)]
        case .space:
            [Color(red: 0.04, green: 0.02, blue: 0.12), Color(red: 0.02, green: 0.01, blue: 0.06)]
        case .cherryBlossom:
            [Color(red: 1.0, green: 0.94, blue: 0.96), Color(red: 0.98, green: 0.88, blue: 0.92)]
        case .retroGame:
            [Color(red: 0.06, green: 0.06, blue: 0.14), Color(red: 0.03, green: 0.03, blue: 0.08)]
        case .autumn:
            [Color(red: 0.95, green: 0.88, blue: 0.78), Color(red: 0.88, green: 0.78, blue: 0.65)]
        case .aurora:
            [Color(red: 0.04, green: 0.06, blue: 0.14), Color(red: 0.02, green: 0.03, blue: 0.08)]
        case .circus:
            [Color(red: 0.95, green: 0.92, blue: 0.88), Color(red: 0.90, green: 0.85, blue: 0.80)]
        case .desert:
            [Color(red: 0.14, green: 0.10, blue: 0.22), Color(red: 0.08, green: 0.06, blue: 0.14)]
        case .candy:
            [Color(red: 1.0, green: 0.88, blue: 0.92), Color(red: 0.88, green: 0.96, blue: 0.94)]
        case .zenGarden:
            [Color(red: 0.93, green: 0.90, blue: 0.84), Color(red: 0.88, green: 0.86, blue: 0.80)]
        }
    }

    var isDarkTheme: Bool {
        switch self {
        case .minimal, .cherryBlossom, .autumn, .circus, .candy, .zenGarden: false
        default: true
        }
    }

    var textColor: Color {
        isDarkTheme
            ? Color(red: 0.92, green: 0.92, blue: 0.96)
            : Color(red: 0.18, green: 0.18, blue: 0.22)
    }

    var cardTextColor: Color {
        switch self {
        case .minimal:
            Color(red: 0.20, green: 0.20, blue: 0.25)
        case .halloween:
            Color(red: 0.95, green: 0.92, blue: 0.85)
        case .christmas:
            Color(red: 0.15, green: 0.22, blue: 0.15)
        case .ocean:
            Color(red: 0.12, green: 0.20, blue: 0.35)
        case .space:
            Color(red: 0.90, green: 0.88, blue: 0.98)
        case .cherryBlossom:
            Color(red: 0.35, green: 0.18, blue: 0.25)
        case .retroGame:
            Color(red: 0.10, green: 0.95, blue: 0.40)
        case .autumn:
            Color(red: 0.30, green: 0.18, blue: 0.08)
        case .aurora:
            Color(red: 0.88, green: 0.92, blue: 0.98)
        case .circus:
            Color(red: 0.20, green: 0.10, blue: 0.05)
        case .desert:
            Color(red: 0.92, green: 0.85, blue: 0.70)
        case .candy:
            Color(red: 0.45, green: 0.20, blue: 0.35)
        case .zenGarden:
            Color(red: 0.30, green: 0.32, blue: 0.28)
        }
    }

    var accentColor: Color {
        switch self {
        case .minimal: Color(red: 0.30, green: 0.30, blue: 0.35)
        case .halloween: Color(red: 0.95, green: 0.55, blue: 0.10)
        case .christmas: Color(red: 0.85, green: 0.15, blue: 0.15)
        case .ocean: Color(red: 0.10, green: 0.80, blue: 0.85)
        case .space: Color(red: 0.55, green: 0.35, blue: 0.95)
        case .cherryBlossom: Color(red: 0.92, green: 0.45, blue: 0.60)
        case .retroGame: Color(red: 0.10, green: 0.95, blue: 0.40)
        case .autumn: Color(red: 0.85, green: 0.45, blue: 0.15)
        case .aurora: Color(red: 0.20, green: 0.90, blue: 0.60)
        case .circus: Color(red: 0.90, green: 0.20, blue: 0.30)
        case .desert: Color(red: 0.90, green: 0.75, blue: 0.35)
        case .candy: Color(red: 0.95, green: 0.35, blue: 0.55)
        case .zenGarden: Color(red: 0.55, green: 0.65, blue: 0.50)
        }
    }

    var buttonColor: Color {
        switch self {
        case .minimal: Color(red: 0.92, green: 0.92, blue: 0.94)
        case .halloween: Color(red: 0.20, green: 0.10, blue: 0.28)
        case .christmas: Color(red: 0.12, green: 0.25, blue: 0.15)
        case .ocean: Color(red: 0.06, green: 0.18, blue: 0.35)
        case .space: Color(red: 0.10, green: 0.06, blue: 0.22)
        case .cherryBlossom: Color(red: 1.0, green: 0.90, blue: 0.94)
        case .retroGame: Color(red: 0.10, green: 0.10, blue: 0.20)
        case .autumn: Color(red: 0.90, green: 0.82, blue: 0.70)
        case .aurora: Color(red: 0.08, green: 0.12, blue: 0.22)
        case .circus: Color(red: 0.95, green: 0.88, blue: 0.82)
        case .desert: Color(red: 0.20, green: 0.15, blue: 0.30)
        case .candy: Color(red: 1.0, green: 0.85, blue: 0.90)
        case .zenGarden: Color(red: 0.90, green: 0.88, blue: 0.82)
        }
    }

    var cardBackgroundColor: Color {
        switch self {
        case .minimal:
            Color.white
        case .halloween:
            Color(red: 0.15, green: 0.08, blue: 0.22)
        case .christmas:
            Color(red: 0.96, green: 0.94, blue: 0.90)
        case .ocean:
            Color(red: 0.90, green: 0.96, blue: 1.0)
        case .space:
            Color(red: 0.10, green: 0.06, blue: 0.20)
        case .cherryBlossom:
            Color(red: 1.0, green: 0.97, blue: 0.98)
        case .retroGame:
            Color(red: 0.05, green: 0.05, blue: 0.10)
        case .autumn:
            Color(red: 1.0, green: 0.97, blue: 0.92)
        case .aurora:
            Color(red: 0.08, green: 0.10, blue: 0.20)
        case .circus:
            Color(red: 1.0, green: 0.98, blue: 0.95)
        case .desert:
            Color(red: 0.12, green: 0.10, blue: 0.20)
        case .candy:
            Color(red: 1.0, green: 0.96, blue: 0.97)
        case .zenGarden:
            Color(red: 0.96, green: 0.95, blue: 0.91)
        }
    }

    var cardShadowColor: Color {
        switch self {
        case .minimal: Color.black.opacity(0.12)
        case .halloween: Color(red: 0.95, green: 0.55, blue: 0.10).opacity(0.45)
        case .christmas: Color.red.opacity(0.25)
        case .ocean: Color(red: 0.0, green: 0.5, blue: 0.8).opacity(0.40)
        case .space: Color(red: 0.4, green: 0.2, blue: 0.9).opacity(0.50)
        case .cherryBlossom: Color(red: 1.0, green: 0.5, blue: 0.7).opacity(0.30)
        case .retroGame: Color(red: 0.1, green: 0.95, blue: 0.4).opacity(0.55)
        case .autumn: Color(red: 0.6, green: 0.3, blue: 0.1).opacity(0.22)
        case .aurora: Color(red: 0.1, green: 0.8, blue: 0.5).opacity(0.50)
        case .circus: Color.red.opacity(0.22)
        case .desert: Color(red: 0.9, green: 0.7, blue: 0.3).opacity(0.45)
        case .candy: Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.25)
        case .zenGarden: Color(red: 0.4, green: 0.5, blue: 0.3).opacity(0.18)
        }
    }

    var fontDesign: Font.Design {
        switch self {
        case .minimal: .default
        case .halloween: .serif
        case .christmas: .rounded
        case .ocean: .rounded
        case .space: .monospaced
        case .cherryBlossom: .serif
        case .retroGame: .monospaced
        case .autumn: .serif
        case .aurora: .default
        case .circus: .rounded
        case .desert: .default
        case .candy: .rounded
        case .zenGarden: .serif
        }
    }
}
