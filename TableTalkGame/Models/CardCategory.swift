import SwiftUI

enum CardCategory: String, CaseIterable {
    case vibe
    case whatIf
    case story
    case deep

    var name: String {
        switch self {
        case .vibe: "바이브 체크"
        case .whatIf: "만약에"
        case .story: "내 이야기"
        case .deep: "솔직한 대화"
        }
    }

    var iconName: String {
        switch self {
        case .vibe: "sparkles"
        case .whatIf: "cloud.fill"
        case .story: "book.fill"
        case .deep: "heart.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .vibe: Color(red: 0.2, green: 0.7, blue: 0.5)
        case .whatIf: Color(red: 0.9, green: 0.7, blue: 0.2)
        case .story: Color(red: 0.4, green: 0.5, blue: 0.8)
        case .deep: Color(red: 0.9, green: 0.35, blue: 0.4)
        }
    }

    /// 게임 시작 시 각 카테고리에서 뽑을 카드 수
    var gameDrawCount: Int {
        switch self {
        case .vibe: 18
        case .whatIf: 15
        case .story: 15
        case .deep: 12
        }
    }
}
