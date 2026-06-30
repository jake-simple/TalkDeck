import { create } from 'zustand';
import { UNLIMITED_DURATION_MS } from '../lib/adConfig';

const KEY = 'ait_entitlement';

interface Persisted {
  unlimitedUntil: number;
  themeWatched: boolean;
  packWatched: boolean;
}

function load(): Persisted {
  try {
    const raw = JSON.parse(localStorage.getItem(KEY) || 'null');
    if (raw && typeof raw === 'object') {
      return {
        unlimitedUntil: Number(raw.unlimitedUntil) || 0,
        themeWatched: !!raw.themeWatched,
        packWatched: !!raw.packWatched,
      };
    }
  } catch {
    /* ignore */
  }
  return { unlimitedUntil: 0, themeWatched: false, packWatched: false };
}

interface EntitlementState extends Persisted {
  /** 현재 무제한 이용 가능 여부 */
  isUnlimited: () => boolean;
  /** 무제한 만료까지 남은 ms (없으면 0) */
  remainingMs: () => number;
  /** 테마 리워드 시청 완료 처리 (둘 다 시청 시 1시간 무제한 부여) */
  grantTheme: () => void;
  /** 카드팩 리워드 시청 완료 처리 (둘 다 시청 시 1시간 무제한 부여) */
  grantPack: () => void;
}

export const useEntitlement = create<EntitlementState>((set, get) => {
  const initial = load();

  const persist = () => {
    const { unlimitedUntil, themeWatched, packWatched } = get();
    try {
      localStorage.setItem(
        KEY,
        JSON.stringify({ unlimitedUntil, themeWatched, packWatched })
      );
    } catch {
      /* ignore */
    }
  };

  const grant = (side: 'theme' | 'pack') => {
    if (get().isUnlimited()) return;
    const other = side === 'theme' ? get().packWatched : get().themeWatched;
    if (other) {
      // 양쪽 모두 시청 → 1시간 무제한, 플래그 초기화
      set({
        unlimitedUntil: Date.now() + UNLIMITED_DURATION_MS,
        themeWatched: false,
        packWatched: false,
      });
    } else {
      set(side === 'theme' ? { themeWatched: true } : { packWatched: true });
    }
    persist();
  };

  return {
    ...initial,
    isUnlimited: () => Date.now() < get().unlimitedUntil,
    remainingMs: () => Math.max(0, get().unlimitedUntil - Date.now()),
    grantTheme: () => grant('theme'),
    grantPack: () => grant('pack'),
  };
});
