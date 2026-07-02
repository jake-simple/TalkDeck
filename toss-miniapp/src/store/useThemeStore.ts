import { create } from 'zustand';
import type { ThemeKey } from '../theme/types';
import { THEMES } from '../theme/themes';

const STORAGE_KEY = 'selectedTheme';

function readInitial(): ThemeKey {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw && raw in THEMES) return raw as ThemeKey;
  } catch {
    /* ignore */
  }
  return 'minimal';
}

interface ThemeState {
  themeKey: ThemeKey;
  setTheme: (key: ThemeKey) => void;
}

export const useThemeStore = create<ThemeState>((set) => ({
  themeKey: readInitial(),
  setTheme: (key) => {
    try {
      localStorage.setItem(STORAGE_KEY, key);
    } catch {
      /* ignore */
    }
    set({ themeKey: key });
  },
}));
