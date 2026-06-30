import { create } from 'zustand';
import { UNLIMITED_DURATION_MS } from '../lib/adConfig';

const KEY = 'ait_entitlement';

interface Persisted {
  /** 테마 무제한 만료 시각(ms epoch) */
  themeUnlimitedUntil: number;
  /** 카드팩 무제한 만료 시각(ms epoch) */
  packUnlimitedUntil: number;
}

function load(): Persisted {
  try {
    const raw = JSON.parse(localStorage.getItem(KEY) || 'null');
    if (raw && typeof raw === 'object') {
      return {
        themeUnlimitedUntil: Number(raw.themeUnlimitedUntil) || 0,
        packUnlimitedUntil: Number(raw.packUnlimitedUntil) || 0,
      };
    }
  } catch {
    /* ignore */
  }
  return { themeUnlimitedUntil: 0, packUnlimitedUntil: 0 };
}

interface EntitlementState extends Persisted {
  /** 테마 변경이 현재 무제한인지 */
  isThemeUnlimited: () => boolean;
  /** 카드팩 변경이 현재 무제한인지 */
  isPackUnlimited: () => boolean;
  /** 테마 리워드 시청 완료 → 테마 변경 1시간 무제한 */
  grantTheme: () => void;
  /** 카드팩 리워드 시청 완료 → 카드팩 변경 1시간 무제한 */
  grantPack: () => void;
}

export const useEntitlement = create<EntitlementState>((set, get) => {
  const initial = load();

  const persist = () => {
    const { themeUnlimitedUntil, packUnlimitedUntil } = get();
    try {
      localStorage.setItem(KEY, JSON.stringify({ themeUnlimitedUntil, packUnlimitedUntil }));
    } catch {
      /* ignore */
    }
  };

  return {
    ...initial,
    isThemeUnlimited: () => Date.now() < get().themeUnlimitedUntil,
    isPackUnlimited: () => Date.now() < get().packUnlimitedUntil,
    grantTheme: () => {
      set({ themeUnlimitedUntil: Date.now() + UNLIMITED_DURATION_MS });
      persist();
    },
    grantPack: () => {
      set({ packUnlimitedUntil: Date.now() + UNLIMITED_DURATION_MS });
      persist();
    },
  };
});
