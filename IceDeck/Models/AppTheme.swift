import SwiftUI

enum AppTheme: String, CaseIterable {
    case minimal
    case halloween
    case christmas
    case space
    case cherryBlossom
    case retroGame
    case autumn
    case aurora
    case circus
    case desert
    case candy
    case zenGarden
    case forsythia
    case ocean
    case neonCyber
    case korean
    case rainyDay
    case lavender

    var name: String {
        switch self {
        case .minimal: String(localized: "theme_minimal")
        case .halloween: String(localized: "theme_halloween")
        case .christmas: String(localized: "theme_christmas")
        case .space: String(localized: "theme_space")
        case .cherryBlossom: String(localized: "theme_cherryBlossom")
        case .retroGame: String(localized: "theme_retroGame")
        case .autumn: String(localized: "theme_autumn")
        case .aurora: String(localized: "theme_aurora")
        case .circus: String(localized: "theme_circus")
        case .desert: String(localized: "theme_desert")
        case .candy: String(localized: "theme_candy")
        case .zenGarden: String(localized: "theme_zenGarden")
        case .forsythia: String(localized: "theme_forsythia")
        case .ocean: String(localized: "theme_ocean")
        case .neonCyber: String(localized: "theme_neonCyber")
        case .korean: String(localized: "theme_korean")
        case .rainyDay: String(localized: "theme_rainyDay")
        case .lavender: String(localized: "theme_lavender")
        }
    }

    var themeEmoji: String {
        switch self {
        case .minimal: "⬜"
        case .halloween: "🎃"
        case .christmas: "🎄"
        case .space: "🚀"
        case .cherryBlossom: "🌸"
        case .retroGame: "🕹️"
        case .autumn: "🍂"
        case .aurora: "🌌"
        case .circus: "🎪"
        case .desert: "🏜️"
        case .candy: "🍬"
        case .zenGarden: "🪨"
        case .forsythia: "🌼"
        case .ocean: "🌊"
        case .neonCyber: "🌃"
        case .korean: "🏮"
        case .rainyDay: "🌧️"
        case .lavender: "💜"
        }
    }

    var themeIconName: String {
        switch self {
        case .minimal: "square.on.square"
        case .halloween: "moon.fill"
        case .christmas: "gift.fill"
        case .space: "sparkles"
        case .cherryBlossom: "leaf.fill"
        case .retroGame: "gamecontroller.fill"
        case .autumn: "wind"
        case .aurora: "moonphase.waxing.gibbous"
        case .circus: "star.circle.fill"
        case .desert: "sun.max.fill"
        case .candy: "birthday.cake.fill"
        case .zenGarden: "leaf.fill"
        case .forsythia: "camera.macro"
        case .ocean: "water.waves"
        case .neonCyber: "building.2.fill"
        case .korean: "scroll.fill"
        case .rainyDay: "cloud.rain.fill"
        case .lavender: "sparkle"
        }
    }

    // MARK: - Card

    var cardCornerRadius: CGFloat {
        switch self {
        case .minimal: 16
        case .halloween: 16
        case .christmas: 14
        case .space: 12
        case .cherryBlossom: 28
        case .retroGame: 4
        case .autumn: 18
        case .aurora: 24
        case .circus: 18
        case .desert: 14
        case .candy: 28
        case .zenGarden: 20
        case .forsythia: 22
        case .ocean: 20
        case .neonCyber: 8
        case .korean: 12
        case .rainyDay: 18
        case .lavender: 24
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
        case .forsythia:
            [Color(red: 1.0, green: 0.95, blue: 0.70), Color(red: 0.98, green: 0.88, blue: 0.58)]
        case .ocean:
            [Color(red: 0.85, green: 0.95, blue: 1.0), Color(red: 0.65, green: 0.85, blue: 0.95)]
        case .neonCyber:
            [Color(red: 0.06, green: 0.02, blue: 0.12), Color(red: 0.03, green: 0.01, blue: 0.08)]
        case .korean:
            [Color(red: 0.96, green: 0.92, blue: 0.84), Color(red: 0.92, green: 0.87, blue: 0.78)]
        case .rainyDay:
            [Color(red: 0.12, green: 0.14, blue: 0.18), Color(red: 0.08, green: 0.10, blue: 0.14)]
        case .lavender:
            [Color(red: 0.92, green: 0.88, blue: 0.98), Color(red: 0.88, green: 0.82, blue: 0.95)]
        }
    }

    var isDarkTheme: Bool {
        switch self {
        case .minimal, .cherryBlossom, .autumn, .circus, .candy, .zenGarden, .forsythia, .ocean, .korean, .lavender: false
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
        case .forsythia:
            Color(red: 0.40, green: 0.32, blue: 0.12)
        case .ocean:
            Color(red: 0.12, green: 0.30, blue: 0.45)
        case .neonCyber:
            Color(red: 0.90, green: 0.85, blue: 0.95)
        case .korean:
            Color(red: 0.25, green: 0.18, blue: 0.12)
        case .rainyDay:
            Color(red: 0.82, green: 0.85, blue: 0.90)
        case .lavender:
            Color(red: 0.32, green: 0.22, blue: 0.42)
        }
    }

    var accentColor: Color {
        switch self {
        case .minimal: Color(red: 0.30, green: 0.30, blue: 0.35)
        case .halloween: Color(red: 0.95, green: 0.55, blue: 0.10)
        case .christmas: Color(red: 0.90, green: 0.25, blue: 0.25)
        case .space: Color(red: 0.55, green: 0.35, blue: 0.95)
        case .cherryBlossom: Color(red: 0.92, green: 0.45, blue: 0.60)
        case .retroGame: Color(red: 0.10, green: 0.95, blue: 0.40)
        case .autumn: Color(red: 0.85, green: 0.45, blue: 0.15)
        case .aurora: Color(red: 0.20, green: 0.90, blue: 0.60)
        case .circus: Color(red: 0.90, green: 0.20, blue: 0.30)
        case .desert: Color(red: 0.90, green: 0.75, blue: 0.35)
        case .candy: Color(red: 0.95, green: 0.35, blue: 0.55)
        case .zenGarden: Color(red: 0.55, green: 0.65, blue: 0.50)
        case .forsythia: Color(red: 0.72, green: 0.58, blue: 0.02)
        case .ocean: Color(red: 0.20, green: 0.60, blue: 0.85)
        case .neonCyber: Color(red: 0.95, green: 0.20, blue: 0.60)
        case .korean: Color(red: 0.78, green: 0.22, blue: 0.28)
        case .rainyDay: Color(red: 0.50, green: 0.65, blue: 0.80)
        case .lavender: Color(red: 0.60, green: 0.40, blue: 0.80)
        }
    }

    var buttonColor: Color {
        switch self {
        case .minimal: Color(red: 0.92, green: 0.92, blue: 0.94)
        case .halloween: Color(red: 0.20, green: 0.10, blue: 0.28)
        case .christmas: Color(red: 0.12, green: 0.25, blue: 0.15)
        case .space: Color(red: 0.10, green: 0.06, blue: 0.22)
        case .cherryBlossom: Color(red: 1.0, green: 0.90, blue: 0.94)
        case .retroGame: Color(red: 0.10, green: 0.10, blue: 0.20)
        case .autumn: Color(red: 0.90, green: 0.82, blue: 0.70)
        case .aurora: Color(red: 0.08, green: 0.12, blue: 0.22)
        case .circus: Color(red: 0.95, green: 0.88, blue: 0.82)
        case .desert: Color(red: 0.20, green: 0.15, blue: 0.30)
        case .candy: Color(red: 1.0, green: 0.85, blue: 0.90)
        case .zenGarden: Color(red: 0.90, green: 0.88, blue: 0.82)
        case .forsythia: Color(red: 1.0, green: 0.94, blue: 0.70)
        case .ocean: Color(red: 0.85, green: 0.93, blue: 0.98)
        case .neonCyber: Color(red: 0.12, green: 0.06, blue: 0.20)
        case .korean: Color(red: 0.94, green: 0.90, blue: 0.82)
        case .rainyDay: Color(red: 0.16, green: 0.18, blue: 0.24)
        case .lavender: Color(red: 0.92, green: 0.88, blue: 0.96)
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
        case .forsythia:
            Color(red: 1.0, green: 0.97, blue: 0.85)
        case .ocean:
            Color(red: 0.97, green: 0.99, blue: 1.0)
        case .neonCyber:
            Color(red: 0.08, green: 0.04, blue: 0.15)
        case .korean:
            Color(red: 0.98, green: 0.96, blue: 0.90)
        case .rainyDay:
            Color(red: 0.14, green: 0.16, blue: 0.22)
        case .lavender:
            Color(red: 0.98, green: 0.96, blue: 1.0)
        }
    }

    var cardShadowColor: Color {
        switch self {
        case .minimal: Color.black.opacity(0.12)
        case .halloween: Color(red: 0.95, green: 0.55, blue: 0.10).opacity(0.45)
        case .christmas: Color.red.opacity(0.25)
        case .space: Color(red: 0.4, green: 0.2, blue: 0.9).opacity(0.50)
        case .cherryBlossom: Color(red: 1.0, green: 0.5, blue: 0.7).opacity(0.30)
        case .retroGame: Color(red: 0.1, green: 0.95, blue: 0.4).opacity(0.55)
        case .autumn: Color(red: 0.6, green: 0.3, blue: 0.1).opacity(0.22)
        case .aurora: Color(red: 0.1, green: 0.8, blue: 0.5).opacity(0.50)
        case .circus: Color.red.opacity(0.22)
        case .desert: Color(red: 0.9, green: 0.7, blue: 0.3).opacity(0.45)
        case .candy: Color(red: 0.95, green: 0.35, blue: 0.55).opacity(0.25)
        case .zenGarden: Color(red: 0.4, green: 0.5, blue: 0.3).opacity(0.18)
        case .forsythia: Color(red: 0.95, green: 0.80, blue: 0.05).opacity(0.35)
        case .ocean: Color(red: 0.20, green: 0.60, blue: 0.85).opacity(0.25)
        case .neonCyber: Color(red: 0.95, green: 0.20, blue: 0.60).opacity(0.45)
        case .korean: Color(red: 0.60, green: 0.35, blue: 0.15).opacity(0.20)
        case .rainyDay: Color(red: 0.30, green: 0.45, blue: 0.65).opacity(0.35)
        case .lavender: Color(red: 0.60, green: 0.40, blue: 0.80).opacity(0.25)
        }
    }

    var fontDesign: Font.Design {
        switch self {
        case .minimal: .default
        case .halloween: .serif
        case .christmas: .rounded
        case .space: .monospaced
        case .cherryBlossom: .serif
        case .retroGame: .monospaced
        case .autumn: .serif
        case .aurora: .default
        case .circus: .rounded
        case .desert: .default
        case .candy: .rounded
        case .zenGarden: .serif
        case .forsythia: .rounded
        case .ocean: .rounded
        case .neonCyber: .monospaced
        case .korean: .serif
        case .rainyDay: .default
        case .lavender: .serif
        }
    }
}
