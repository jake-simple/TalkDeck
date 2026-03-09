import Foundation

enum CardDataLoader {
    private static let supportedLanguages = ["ko", "en", "ja", "zh-Hans", "es", "pt-BR", "fr", "de", "id"]

    static func cards(for pack: CardPack) -> [Card] {
        let langCode = Locale.current.language.languageCode?.identifier ?? "en"
        let lang = supportedLanguages.contains(langCode) ? langCode : "en"
        return load(pack: pack, language: lang)
            ?? load(pack: pack, language: "en")
            ?? load(pack: pack, language: "ko")
            ?? []
    }

    private static func load(pack: CardPack, language: String) -> [Card]? {
        guard let url = Bundle.main.url(
            forResource: pack.rawValue,
            withExtension: "json",
            subdirectory: "CardData/\(language)"
        ),
        let data = try? Data(contentsOf: url),
        let items = try? JSONDecoder().decode([CardJSON].self, from: data)
        else { return nil }

        return items.compactMap { item in
            guard let category = CardCategory(rawValue: item.category) else { return nil }
            return Card(question: item.question, category: category)
        }
    }
}

private struct CardJSON: Codable {
    let question: String
    let category: String
}
