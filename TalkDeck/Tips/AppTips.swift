import SwiftUI
import TipKit

// MARK: - Tip Events (chaining triggers)

extension AppTipEvents {
    static let packPickerDismissed = Tips.Event(id: "packPickerDismissed")
    static let swipeCardDismissed = Tips.Event(id: "swipeCardDismissed")
    static let themePickerDismissed = Tips.Event(id: "themePickerDismissed")
    static let screenAlwaysOnDismissed = Tips.Event(id: "screenAlwaysOnDismissed")
    static let shuffleDismissed = Tips.Event(id: "shuffleDismissed")
}

enum AppTipEvents {}

// MARK: - Tips (displayed in order)

// 1. 카드팩 선택 — 첫 번째, 항상 표시
struct PackPickerTip: Tip {
    var title: Text {
        Text("tip_pack_picker_title")
    }
    var message: Text? {
        Text("tip_pack_picker_message")
    }
    var image: Image? {
        Image(systemName: "rectangle.stack.fill")
    }
}

// 2. 카드 넘기기 — 카드팩 팁 닫힌 후
struct SwipeCardTip: Tip {
    var title: Text {
        Text("tip_swipe_card_title")
    }
    var message: Text? {
        Text("tip_swipe_card_message")
    }
    var image: Image? {
        Image(systemName: "hand.draw.fill")
    }
    var rules: [Tips.Rule] {
        #Rule(AppTipEvents.packPickerDismissed) { $0.donations.count >= 1 }
    }
}

// 3. 테마 변경 — 스와이프 팁 닫힌 후
struct ThemePickerTip: Tip {
    var title: Text {
        Text("tip_theme_picker_title")
    }
    var message: Text? {
        Text("tip_theme_picker_message")
    }
    var image: Image? {
        Image(systemName: "paintpalette.fill")
    }
    var rules: [Tips.Rule] {
        #Rule(AppTipEvents.swipeCardDismissed) { $0.donations.count >= 1 }
    }
}

// 4. 화면 자동잠금 방지 — 테마 팁 닫힌 후
struct ScreenAlwaysOnTip: Tip {
    var title: Text {
        Text("tip_screen_always_on_title")
    }
    var message: Text? {
        Text("tip_screen_always_on_message")
    }
    var image: Image? {
        Image(systemName: "sun.max.fill")
    }
    var rules: [Tips.Rule] {
        #Rule(AppTipEvents.themePickerDismissed) { $0.donations.count >= 1 }
    }
}

// 5. 카드 섞기 — 화면잠금 팁 닫힌 후
struct ShuffleTip: Tip {
    var title: Text {
        Text("tip_shuffle_title")
    }
    var message: Text? {
        Text("tip_shuffle_message")
    }
    var image: Image? {
        Image(systemName: "shuffle")
    }
    var rules: [Tips.Rule] {
        #Rule(AppTipEvents.screenAlwaysOnDismissed) { $0.donations.count >= 1 }
    }
}

// 6. 랜덤 카드 — 섞기 팁 닫힌 후
struct RandomCardTip: Tip {
    var title: Text {
        Text("tip_random_card_title")
    }
    var message: Text? {
        Text("tip_random_card_message")
    }
    var image: Image? {
        Image(systemName: "dice.fill")
    }
    var rules: [Tips.Rule] {
        #Rule(AppTipEvents.shuffleDismissed) { $0.donations.count >= 1 }
    }
}
