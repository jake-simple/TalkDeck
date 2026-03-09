import Foundation

enum CardData {
    static func cards(for pack: CardPack) -> [Card] {
        CardDataLoader.cards(for: pack)
    }
}
