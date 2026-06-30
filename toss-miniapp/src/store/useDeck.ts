import { create } from 'zustand';
import { type Card, loadCards } from '../data/cards';
import { CATEGORIES, type CategoryKey } from '../theme/categories';
import { PACKS, type PackKey } from '../theme/packs';
import { Haptics } from '../lib/haptics';

function shuffle<T>(arr: T[]): T[] {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

interface DeckState {
  selectedPack: PackKey;
  allCards: Card[];
  currentDeck: Card[];
  selectedCategory: CategoryKey | null;
  currentIndex: number;
  randomCard: Card | null;
  showRandomCard: boolean;
  loading: boolean;

  init: () => Promise<void>;
  selectPack: (pack: PackKey) => Promise<void>;
  selectCategory: (category: CategoryKey | null) => void;
  buildGameDeck: () => void;
  swipeCard: () => void;
  showRandom: () => void;
  closeRandom: () => void;
}

export const useDeck = create<DeckState>((set, get) => ({
  selectedPack: 'basic',
  allCards: [],
  currentDeck: [],
  selectedCategory: null,
  currentIndex: 0,
  randomCard: null,
  showRandomCard: false,
  loading: true,

  init: async () => {
    const cards = await loadCards('basic');
    set({ allCards: cards, loading: false });
    get().buildGameDeck();
  },

  selectPack: async (pack) => {
    set({ loading: true });
    const cards = await loadCards(pack);
    set({
      selectedPack: pack,
      allCards: cards,
      selectedCategory: null,
      loading: false,
    });
    get().buildGameDeck();
  },

  selectCategory: (category) => {
    set({ selectedCategory: category });
    get().buildGameDeck();
  },

  buildGameDeck: () => {
    const { selectedCategory, selectedPack, allCards } = get();
    let deck: Card[];
    if (selectedCategory) {
      deck = shuffle(allCards.filter((c) => c.category === selectedCategory));
    } else {
      const out: Card[] = [];
      for (const cat of PACKS[selectedPack].categories) {
        const pool = allCards.filter((c) => c.category === cat);
        const count = Math.min(CATEGORIES[cat].gameDrawCount, pool.length);
        out.push(...shuffle(pool).slice(0, count));
      }
      deck = shuffle(out);
    }
    set({ currentDeck: deck, currentIndex: 0 });
  },

  swipeCard: () => {
    const { currentIndex, currentDeck } = get();
    if (currentIndex >= currentDeck.length) return;
    set({ currentIndex: currentIndex + 1 });
    Haptics.swipe();
  },

  showRandom: () => {
    const { currentDeck, currentIndex, allCards } = get();
    const top = currentDeck[currentIndex];
    const source = top
      ? allCards.filter((c) => c.category === top.category)
      : allCards;
    const pick = source[Math.floor(Math.random() * source.length)] ?? null;
    set({ randomCard: pick, showRandomCard: true });
    Haptics.random();
  },

  closeRandom: () => set({ showRandomCard: false }),
}));

// 파생 셀렉터
export const selectVisibleCards = (s: DeckState): Card[] =>
  s.currentDeck.slice(s.currentIndex, Math.min(s.currentIndex + 3, s.currentDeck.length));
export const selectIsFinished = (s: DeckState): boolean =>
  s.currentIndex >= s.currentDeck.length;
export const selectTotalCount = (s: DeckState): number => s.currentDeck.length;
export const selectRemainingCount = (s: DeckState): number =>
  Math.max(s.currentDeck.length - s.currentIndex, 0);
