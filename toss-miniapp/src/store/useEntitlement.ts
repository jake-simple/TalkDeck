import { create } from 'zustand';
import { UNLIMITED_DURATION_MS } from '../lib/adConfig';

const KEY = 'ait_entitlement_v1';

interface Persisted {
  /** 테마 무제한 만료 시각(ms epoch) */
  themeUnlimitedUntil: number;
  /** 카드팩 무제한 만료 시각(ms epoch) */
  packUnlimitedUntil: number;
}

const EMPTY: Persisted = { themeUnlimitedUntil: 0, packUnlimitedUntil: 0 };

function parse(raw: string | null): Persisted {
  try {
    const obj = raw ? JSON.parse(raw) : null;
    if (obj && typeof obj === 'object') {
      return {
        themeUnlimitedUntil: Number(obj.themeUnlimitedUntil) || 0,
        packUnlimitedUntil: Number(obj.packUnlimitedUntil) || 0,
      };
    }
  } catch {
    /* ignore */
  }
  return { ...EMPTY };
}

/**
 * 앱인토스 네이티브 저장소(Storage.getItem/setItem)를 사용한다.
 * "앱이 종료되었다가 다시 시작해도 데이터가 유지"되는 저장소로,
 * 웹뷰 localStorage보다 미니앱 재시작 후 영속성이 안정적이다.
 * SDK 로드/미지원 환경(일반 브라우저 등)에서는 localStorage 로 폴백한다.
 */
async function getSdkStorage(): Promise<{
  getItem: (k: string) => Promise<string | null>;
  setItem: (k: string, v: string) => Promise<void>;
} | null> {
  try {
    const mod: any = await import('@apps-in-toss/web-framework');
    const Storage = (mod?.default ?? mod)?.Storage;
    if (Storage?.getItem && Storage?.setItem) return Storage;
  } catch {
    /* ignore */
  }
  return null;
}

async function readPersisted(): Promise<Persisted> {
  const storage = await getSdkStorage();
  if (storage) {
    try {
      const raw = await storage.getItem(KEY);
      return parse(raw);
    } catch {
      /* fall through to localStorage */
    }
  }
  try {
    return parse(localStorage.getItem(KEY));
  } catch {
    return { ...EMPTY };
  }
}

async function writePersisted(data: Persisted): Promise<void> {
  const raw = JSON.stringify(data);
  const storage = await getSdkStorage();
  if (storage) {
    try {
      await storage.setItem(KEY, raw);
      return;
    } catch {
      /* fall through to localStorage */
    }
  }
  try {
    localStorage.setItem(KEY, raw);
  } catch {
    /* ignore */
  }
}

interface EntitlementState extends Persisted {
  /** 네이티브 저장소에서 초기 상태를 불러왔는지 */
  hydrated: boolean;
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
  // 네이티브 저장소는 비동기라, 최초 로드 전까지는 EMPTY(제한 상태)로 시작하고
  // 로드가 끝나면 실제 값으로 갱신한다(hydrated=true).
  void readPersisted().then((p) => set({ ...p, hydrated: true }));

  return {
    ...EMPTY,
    hydrated: false,
    isThemeUnlimited: () => Date.now() < get().themeUnlimitedUntil,
    isPackUnlimited: () => Date.now() < get().packUnlimitedUntil,
    grantTheme: () => {
      const next = { themeUnlimitedUntil: Date.now() + UNLIMITED_DURATION_MS, packUnlimitedUntil: get().packUnlimitedUntil };
      set(next);
      void writePersisted(next);
    },
    grantPack: () => {
      const next = { themeUnlimitedUntil: get().themeUnlimitedUntil, packUnlimitedUntil: Date.now() + UNLIMITED_DURATION_MS };
      set(next);
      void writePersisted(next);
    },
  };
});
