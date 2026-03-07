import SwiftUI

enum CardPack: String, CaseIterable, Identifiable {
    case basic
    case friends
    case couple
    case blindDate
    case married
    case babyParents
    case family
    case coworkers
    case afterFight
    case travel
    case icebreaking
    case lateNight
    case wouldYouRather
    case newYear
    case hotTakes
    case neverHaveIEver

    var id: String { rawValue }

    var name: String {
        switch self {
        case .basic: "기본"
        case .friends: "친구"
        case .couple: "연인"
        case .blindDate: "소개팅"
        case .married: "부부"
        case .babyParents: "아기 있는 부부"
        case .family: "가족"
        case .coworkers: "직장인"
        case .afterFight: "마음 풀기"
        case .travel: "여행 중"
        case .icebreaking: "아이스브레이킹"
        case .lateNight: "심야 토크"
        case .wouldYouRather: "밸런스 게임"
        case .newYear: "연말연시"
        case .hotTakes: "논쟁 토크"
        case .neverHaveIEver: "나는 한 번도"
        }
    }

    var iconName: String {
        switch self {
        case .basic: "rectangle.stack.fill"
        case .friends: "person.2.fill"
        case .couple: "heart.fill"
        case .blindDate: "sparkles"
        case .married: "house.fill"
        case .babyParents: "stroller.fill"
        case .family: "figure.2.and.child.holdinghands"
        case .coworkers: "briefcase.fill"
        case .afterFight: "bolt.heart.fill"
        case .travel: "airplane"
        case .icebreaking: "hand.wave.fill"
        case .lateNight: "moon.stars.fill"
        case .wouldYouRather: "arrow.left.arrow.right.circle.fill"
        case .newYear: "fireworks"
        case .hotTakes: "flame.fill"
        case .neverHaveIEver: "hand.raised.fill"
        }
    }

    var description: String {
        switch self {
        case .basic: "누구와도 좋은 범용 대화 카드"
        case .friends: "친구끼리 더 깊어지는 대화"
        case .couple: "연인과 설레는 대화"
        case .blindDate: "처음 만난 사이, 자연스러운 대화"
        case .married: "부부가 다시 가까워지는 대화"
        case .babyParents: "육아 속 우리 이야기"
        case .family: "세대를 넘는 가족 대화"
        case .coworkers: "동료와 편하게 나누는 이야기"
        case .afterFight: "서운한 마음을 풀고 다시 가까워지는 대화"
        case .travel: "여행길에 나누는 대화"
        case .icebreaking: "처음 만난 그룹을 위한 대화"
        case .lateNight: "깊은 밤, 감성적인 대화"
        case .wouldYouRather: "이거 vs 저거, 선택의 연속"
        case .newYear: "한 해를 돌아보고 새해를 맞이하며"
        case .hotTakes: "가벼운 논쟁으로 시작하는 대화"
        case .neverHaveIEver: "나는 한 번도... 해본 적 없다!"
        }
    }

    var accentColor: Color {
        switch self {
        case .basic: Color(red: 0.4, green: 0.5, blue: 0.7)
        case .friends: Color(red: 0.3, green: 0.7, blue: 0.4)
        case .couple: Color(red: 0.9, green: 0.3, blue: 0.4)
        case .blindDate: Color(red: 0.9, green: 0.5, blue: 0.7)
        case .married: Color(red: 0.6, green: 0.4, blue: 0.8)
        case .babyParents: Color(red: 0.95, green: 0.6, blue: 0.3)
        case .family: Color(red: 0.2, green: 0.6, blue: 0.8)
        case .coworkers: Color(red: 0.3, green: 0.3, blue: 0.6)
        case .afterFight: Color(red: 0.55, green: 0.4, blue: 0.75)
        case .travel: Color(red: 0.2, green: 0.7, blue: 0.7)
        case .icebreaking: Color(red: 0.9, green: 0.7, blue: 0.2)
        case .lateNight: Color(red: 0.35, green: 0.35, blue: 0.75)
        case .wouldYouRather: Color(red: 0.9, green: 0.5, blue: 0.2)
        case .newYear: Color(red: 0.85, green: 0.65, blue: 0.15)
        case .hotTakes: Color(red: 0.9, green: 0.3, blue: 0.2)
        case .neverHaveIEver: Color(red: 0.4, green: 0.65, blue: 0.35)
        }
    }

    /// 이 팩에서 사용하는 카테고리 목록 (덱 구성에 사용)
    var categories: [CardCategory] {
        switch self {
        case .basic:
            [.vibe, .whatIf, .story, .deep]
        case .friends:
            [.recentLife, .memories, .innerThoughts, .friendship]
        case .couple:
            [.excitement, .taste, .memories, .future]
        case .blindDate:
            [.firstImpression, .taste, .lifestyle, .values]
        case .married:
            [.dailyLife, .memories, .honestly, .ahead]
        case .babyParents:
            [.parenting, .coupleLife, .hardships, .gratitude]
        case .family:
            [.childhood, .recentLife, .familyStory, .generationGap]
        case .coworkers:
            [.workLife, .workStyle, .dreamsAndGoals, .afterWork]
        case .afterFight:
            [.coolDown, .myFeelings, .yourSide, .makingUp]
        case .travel:
            [.travelStyle, .memories, .thisNow, .bucketList]
        case .icebreaking:
            [.firstMeeting, .taste, .funQuestion, .unexpectedSide]
        case .lateNight:
            [.emotional, .philosophy, .confession, .dream]
        case .wouldYouRather:
            [.lightChoice, .hardChoice, .wildChoice, .seriousChoice]
        case .newYear:
            [.yearReview, .gratitude, .newYearResolution, .wish]
        case .hotTakes:
            [.dailyLife, .culture, .relationship, .life]
        case .neverHaveIEver:
            [.dailyLife, .adventure, .relationship, .secret]
        }
    }
}
