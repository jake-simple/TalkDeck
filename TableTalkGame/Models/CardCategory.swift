import SwiftUI

enum CardCategory: String, CaseIterable {

    // MARK: - 기본 (Basic)
    case vibe
    case whatIf
    case story
    case deep

    // MARK: - 친구 (Friends)
    case recentLife      // 요즘 근황
    case memories        // 추억
    case innerThoughts   // 속마음
    case friendship      // 우정

    // MARK: - 연인 (Couple)
    case excitement      // 설렘
    case taste           // 취향
    case future          // 미래

    // MARK: - 소개팅 (Blind Date)
    case firstImpression // 첫인상
    case lifestyle       // 라이프스타일
    case values          // 가치관

    // MARK: - 부부 (Married)
    case dailyLife       // 일상
    case honestly        // 솔직하게
    case ahead           // 앞으로

    // MARK: - 아기 있는 부부 (Baby Parents)
    case parenting       // 육아 이야기
    case coupleLife      // 부부 이야기
    case hardships       // 힘든 점
    case gratitude       // 감사

    // MARK: - 가족 (Family)
    case childhood       // 어린 시절
    case familyStory     // 가족 이야기
    case generationGap   // 세대 차이

    // MARK: - 직장인 (Coworkers)
    case workLife        // 직장 생활
    case workStyle       // 업무 스타일
    case dreamsAndGoals  // 꿈과 목표
    case afterWork       // 퇴근 후

    // MARK: - 싸웠을 때 (After Fight)
    case coolDown        // 진정하기
    case myFeelings      // 내 감정
    case yourSide        // 네 입장
    case makingUp        // 화해

    // MARK: - 공통
    case life            // 인생 이야기

    // MARK: - 여행 중 (Travel)
    case travelStyle     // 여행 스타일
    case thisNow         // 지금 이 순간
    case bucketList      // 버킷리스트

    // MARK: - 아이스브레이킹 (Icebreaking)
    case firstMeeting    // 첫 만남
    case funQuestion     // 재미있는 질문
    case unexpectedSide  // 의외의 면

    // MARK: - 심야 토크 (Late Night)
    case emotional       // 감성
    case philosophy      // 철학
    case confession      // 고백
    case dream           // 꿈

    // MARK: - 밸런스 게임 (Would You Rather)
    case lightChoice     // 가벼운
    case hardChoice      // 어려운
    case wildChoice      // 황당한
    case seriousChoice   // 진지한

    // MARK: - 연말연시 (New Year)
    case yearReview      // 올해 회고
    case newYearResolution // 새해 다짐
    case wish            // 소망

    // MARK: - 논쟁 토크 (Hot Takes)
    case culture         // 문화
    case relationship    // 관계

    // MARK: - 나는 한 번도 (Never Have I Ever)
    case adventure       // 모험
    case secret          // 비밀

    // MARK: - Properties

    var name: String {
        switch self {
        case .vibe: "바이브 체크"
        case .whatIf: "만약에"
        case .story: "내 이야기"
        case .deep: "솔직한 대화"
        case .recentLife: "요즘 근황"
        case .memories: "추억"
        case .innerThoughts: "속마음"
        case .friendship: "우정"
        case .excitement: "설렘"
        case .taste: "취향"
        case .future: "미래"
        case .firstImpression: "첫인상"
        case .lifestyle: "라이프스타일"
        case .values: "가치관"
        case .dailyLife: "일상"
        case .honestly: "솔직하게"
        case .ahead: "앞으로"
        case .parenting: "육아 이야기"
        case .coupleLife: "부부 이야기"
        case .hardships: "힘든 점"
        case .gratitude: "감사"
        case .childhood: "어린 시절"
        case .familyStory: "가족 이야기"
        case .generationGap: "세대 차이"
        case .workLife: "직장 생활"
        case .workStyle: "업무 스타일"
        case .dreamsAndGoals: "꿈과 목표"
        case .afterWork: "퇴근 후"
        case .coolDown: "진정하기"
        case .myFeelings: "내 감정"
        case .yourSide: "네 입장"
        case .makingUp: "화해"
        case .life: "인생 이야기"
        case .travelStyle: "여행 스타일"
        case .thisNow: "지금 이 순간"
        case .bucketList: "버킷리스트"
        case .firstMeeting: "첫 만남"
        case .funQuestion: "재미있는 질문"
        case .unexpectedSide: "의외의 면"
        case .emotional: "감성"
        case .philosophy: "철학"
        case .confession: "고백"
        case .dream: "꿈"
        case .lightChoice: "가벼운"
        case .hardChoice: "어려운"
        case .wildChoice: "황당한"
        case .seriousChoice: "진지한"
        case .yearReview: "올해 회고"
        case .newYearResolution: "새해 다짐"
        case .wish: "소망"
        case .culture: "문화"
        case .relationship: "관계"
        case .adventure: "모험"
        case .secret: "비밀"
        }
    }

    var iconName: String {
        switch self {
        case .vibe: "sparkles"
        case .whatIf: "cloud.fill"
        case .story: "book.fill"
        case .deep: "heart.circle.fill"
        case .recentLife: "sun.max.fill"
        case .memories: "photo.fill"
        case .innerThoughts: "bubble.left.fill"
        case .friendship: "person.2.fill"
        case .excitement: "star.fill"
        case .taste: "heart.fill"
        case .future: "arrow.forward.circle.fill"
        case .firstImpression: "eye.fill"
        case .lifestyle: "figure.walk"
        case .values: "checkmark.seal.fill"
        case .dailyLife: "house.fill"
        case .honestly: "mic.fill"
        case .ahead: "map.fill"
        case .parenting: "stroller.fill"
        case .coupleLife: "person.2.circle.fill"
        case .hardships: "cloud.rain.fill"
        case .gratitude: "gift.fill"
        case .childhood: "bicycle"
        case .familyStory: "figure.2.and.child.holdinghands"
        case .generationGap: "arrow.up.arrow.down.circle.fill"
        case .workLife: "briefcase.fill"
        case .workStyle: "laptopcomputer"
        case .dreamsAndGoals: "flag.fill"
        case .afterWork: "sunset.fill"
        case .coolDown: "leaf.fill"
        case .myFeelings: "heart.circle.fill"
        case .yourSide: "person.fill.questionmark"
        case .makingUp: "hands.clap.fill"
        case .life: "book.closed.fill"
        case .travelStyle: "airplane"
        case .thisNow: "camera.fill"
        case .bucketList: "list.star"
        case .firstMeeting: "hand.wave.fill"
        case .funQuestion: "questionmark.bubble.fill"
        case .unexpectedSide: "theatermasks.fill"
        case .emotional: "moon.stars.fill"
        case .philosophy: "brain.head.profile"
        case .confession: "envelope.fill"
        case .dream: "cloud.moon.fill"
        case .lightChoice: "tortoise.fill"
        case .hardChoice: "bolt.fill"
        case .wildChoice: "dice.fill"
        case .seriousChoice: "exclamationmark.circle.fill"
        case .yearReview: "calendar.circle.fill"
        case .newYearResolution: "flag.checkered"
        case .wish: "wand.and.stars"
        case .culture: "building.columns.fill"
        case .relationship: "person.2.wave.2.fill"
        case .adventure: "mountain.2.fill"
        case .secret: "lock.fill"
        }
    }

    var color: Color {
        switch self {
        case .vibe: Color(red: 0.2, green: 0.7, blue: 0.5)
        case .whatIf: Color(red: 0.9, green: 0.7, blue: 0.2)
        case .story: Color(red: 0.4, green: 0.5, blue: 0.8)
        case .deep: Color(red: 0.9, green: 0.35, blue: 0.4)
        case .recentLife: Color(red: 0.95, green: 0.6, blue: 0.2)
        case .memories: Color(red: 0.6, green: 0.4, blue: 0.8)
        case .innerThoughts: Color(red: 0.2, green: 0.7, blue: 0.7)
        case .friendship: Color(red: 0.3, green: 0.75, blue: 0.4)
        case .excitement: Color(red: 0.95, green: 0.4, blue: 0.6)
        case .taste: Color(red: 0.9, green: 0.3, blue: 0.5)
        case .future: Color(red: 0.3, green: 0.5, blue: 0.9)
        case .firstImpression: Color(red: 0.4, green: 0.4, blue: 0.85)
        case .lifestyle: Color(red: 0.2, green: 0.65, blue: 0.7)
        case .values: Color(red: 0.35, green: 0.55, blue: 0.8)
        case .dailyLife: Color(red: 0.9, green: 0.55, blue: 0.25)
        case .honestly: Color(red: 0.85, green: 0.25, blue: 0.35)
        case .ahead: Color(red: 0.25, green: 0.65, blue: 0.45)
        case .parenting: Color(red: 0.95, green: 0.5, blue: 0.65)
        case .coupleLife: Color(red: 0.6, green: 0.35, blue: 0.75)
        case .hardships: Color(red: 0.3, green: 0.5, blue: 0.8)
        case .gratitude: Color(red: 0.9, green: 0.7, blue: 0.15)
        case .childhood: Color(red: 0.3, green: 0.7, blue: 0.4)
        case .familyStory: Color(red: 0.2, green: 0.55, blue: 0.8)
        case .generationGap: Color(red: 0.85, green: 0.5, blue: 0.2)
        case .workLife: Color(red: 0.3, green: 0.4, blue: 0.75)
        case .workStyle: Color(red: 0.2, green: 0.6, blue: 0.7)
        case .dreamsAndGoals: Color(red: 0.85, green: 0.25, blue: 0.3)
        case .afterWork: Color(red: 0.9, green: 0.55, blue: 0.2)
        case .coolDown: Color(red: 0.4, green: 0.7, blue: 0.6)
        case .myFeelings: Color(red: 0.85, green: 0.35, blue: 0.5)
        case .yourSide: Color(red: 0.4, green: 0.5, blue: 0.8)
        case .makingUp: Color(red: 0.9, green: 0.65, blue: 0.2)
        case .life: Color(red: 0.5, green: 0.35, blue: 0.25)
        case .travelStyle: Color(red: 0.2, green: 0.6, blue: 0.85)
        case .thisNow: Color(red: 0.2, green: 0.7, blue: 0.65)
        case .bucketList: Color(red: 0.85, green: 0.65, blue: 0.15)
        case .firstMeeting: Color(red: 0.9, green: 0.55, blue: 0.2)
        case .funQuestion: Color(red: 0.3, green: 0.75, blue: 0.45)
        case .unexpectedSide: Color(red: 0.65, green: 0.3, blue: 0.75)
        case .emotional: Color(red: 0.35, green: 0.35, blue: 0.8)
        case .philosophy: Color(red: 0.55, green: 0.25, blue: 0.75)
        case .confession: Color(red: 0.9, green: 0.4, blue: 0.6)
        case .dream: Color(red: 0.25, green: 0.4, blue: 0.75)
        case .lightChoice: Color(red: 0.3, green: 0.7, blue: 0.45)
        case .hardChoice: Color(red: 0.85, green: 0.65, blue: 0.15)
        case .wildChoice: Color(red: 0.9, green: 0.5, blue: 0.2)
        case .seriousChoice: Color(red: 0.35, green: 0.45, blue: 0.8)
        case .yearReview: Color(red: 0.3, green: 0.5, blue: 0.8)
        case .newYearResolution: Color(red: 0.85, green: 0.25, blue: 0.3)
        case .wish: Color(red: 0.85, green: 0.65, blue: 0.15)
        case .culture: Color(red: 0.2, green: 0.6, blue: 0.65)
        case .relationship: Color(red: 0.35, green: 0.5, blue: 0.8)
        case .adventure: Color(red: 0.3, green: 0.65, blue: 0.35)
        case .secret: Color(red: 0.5, green: 0.3, blue: 0.7)
        }
    }

    var gameDrawCount: Int {
        switch self {
        // 기본 팩은 기존 배분 유지
        case .vibe: 18
        case .whatIf: 15
        case .story: 15
        case .deep: 12
        // 나머지 모든 카테고리는 15장
        default: 15
        }
    }
}
