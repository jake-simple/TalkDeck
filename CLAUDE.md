# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TalkDeck (이야기 카드) is a Korean-language iOS card game app for conversation starters. Users swipe through themed question cards across 16 card packs (e.g., friends, couple, family, icebreaking). The app features 13 visual themes with per-theme card layouts inspired by trading card games (Yu-Gi-Oh, Pokemon, MTG, Tarot, etc.).

- **Bundle ID:** com.onessa.TalkDeck
- **Deployment Target:** iOS 26.2
- **Swift Version:** 5.0
- **UI Framework:** SwiftUI (no UIKit storyboards)
- **State Management:** Swift Observation framework (`@Observable`)
- **Theme Persistence:** `@AppStorage("selectedTheme")`

## Build

Open `TableTalkGame.xcodeproj` in Xcode and build. No external dependencies or package managers.

## Architecture

Single-screen app with overlay-based navigation (no NavigationStack/NavigationView).

### Data Flow
```
TalkDeckApp -> ContentView -> CardDeckView (main screen)
                                    ├── CardView (question card display)
                                    ├── PackPickerView (overlay - card pack selector)
                                    ├── ThemePickerView (overlay - theme selector)
                                    └── CardDeckViewModel (@Observable, manages deck state)
```

### Models (`Models/`)
- `Card` — Simple struct with `question: String` and `category: CardCategory`
- `CardPack` — 16 pack types, each with name, icon, description, accent color, and 4 associated `CardCategory` values
- `CardCategory` — ~50 category types across all packs, each with `gameDrawCount` controlling how many cards are drawn per game session
- `AppTheme` — 13 visual themes, each defining colors, corner radius, font design, and dark/light mode flag

### Views (`Views/`)
- `CardDeckView` — Main game screen: card stack with swipe gestures (horizontal fly-out, vertical shrink), shuffle, random card, shake gesture support
- `CardView` — Per-theme card layouts (13 unique layouts like `yugiohLayout`, `pokemonLayout`, `tarotLayout`)
- `CardDecorations` — Per-theme decorative overlays and borders drawn on cards
- `CardShapes` — Custom Shape implementations for themed card borders
- `ThemeParticleScene` — Canvas-based animated backgrounds per theme (snowfall, bubbles, stars, etc.)
- `PackPickerView` / `ThemePickerView` — Full-screen overlay pickers with infinite horizontal scroll (fan-style) using `scrollTransition` for 3D card fan effect
- `CategoryFilterView` — Category filter UI

### Data (`Data/`)
- `CardData` — Central dispatch: maps `CardPack` to its card array
- `CardPackData_*.swift` — One file per pack, each containing ~240 question cards across 4 categories (60 per category)

### Key Patterns
- **Deck building:** `CardDeckViewModel.buildGameDeck()` draws `gameDrawCount` cards per category from the selected pack, then shuffles. Single-category filter mode uses all cards from that category.
- **Infinite scroll pickers:** Both PackPicker and ThemePicker use virtual index mapping with 80x repetition for seamless infinite scrolling.
- **Theme system:** `AppTheme` is a comprehensive enum where every visual property (colors, fonts, corner radii) is defined per-theme via switch statements.
- **Haptic feedback:** `HapticManager` enum with static methods for swipe, shuffle, and random actions.

## Conventions

- All user-facing strings are in Korean
- Card data files follow naming convention `CardPackData_<PackName>.swift`
- Each card pack has exactly 4 categories with 60 questions each (240 total per pack)
- Theme-specific card layouts are named after their inspiration (e.g., `yugiohLayout` for Halloween theme)
