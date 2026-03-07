import SwiftUI
import Observation

@Observable
class CardDeckViewModel {
    var selectedPack: CardPack = .basic
    var allCards: [Card] = CardData.cards(for: .basic)
    var currentDeck: [Card] = []
    var selectedCategory: CardCategory? = nil
    var currentIndex: Int = 0
    var showRandomCard: Bool = false
    var randomCard: Card? = nil

    var remainingCount: Int {
        max(currentDeck.count - currentIndex, 0)
    }

    var totalCount: Int {
        currentDeck.count
    }

    var isFinished: Bool {
        currentIndex >= currentDeck.count
    }

    var visibleCards: [Card] {
        let start = currentIndex
        let end = min(currentIndex + 3, currentDeck.count)
        guard start < end else { return [] }
        return Array(currentDeck[start..<end])
    }

    init() {
        buildGameDeck()
    }

    func selectPack(_ pack: CardPack) {
        selectedPack = pack
        allCards = CardData.cards(for: pack)
        selectedCategory = nil
        buildGameDeck()
    }

    func selectCategory(_ category: CardCategory?) {
        selectedCategory = category
        buildGameDeck()
    }

    func buildGameDeck() {
        if let category = selectedCategory {
            // 특정 카테고리 선택 시 해당 카테고리 전체에서 셔플
            let filtered = allCards.filter { $0.category == category }
            currentDeck = filtered.shuffled()
        } else {
            // 팩의 카테고리별 배분에 맞춰 뽑기
            var deck: [Card] = []
            for category in selectedPack.categories {
                let pool = allCards.filter { $0.category == category }
                let count = min(category.gameDrawCount, pool.count)
                deck.append(contentsOf: pool.shuffled().prefix(count))
            }
            currentDeck = deck.shuffled()
        }
        currentIndex = 0
    }

    func swipeCard() {
        guard currentIndex < currentDeck.count else { return }
        currentIndex += 1
        HapticManager.swipe()
    }

    func showRandom() {
        let currentCategory = visibleCards.first?.category
        let source: [Card]
        if let category = currentCategory {
            source = allCards.filter { $0.category == category }
        } else {
            source = allCards
        }
        randomCard = source.randomElement()
        showRandomCard = true
        HapticManager.random()
    }
}
