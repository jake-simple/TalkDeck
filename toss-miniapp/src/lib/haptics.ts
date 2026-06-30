// 앱인토스 web-framework 의 햅틱 브리지를 best-effort 로 호출.
// 토스 웹뷰 밖(일반 브라우저)에서는 navigator.vibrate 로 폴백.
type HapticType = 'swipe' | 'shuffle' | 'random';

const FALLBACK_MS: Record<HapticType, number> = {
  swipe: 10,
  shuffle: 20,
  random: 30,
};

// web-framework 햅틱 타입 매핑 (SDK 시그니처 변동 대비 best-effort).
const SDK_TYPE: Record<HapticType, string> = {
  swipe: 'tickWeak',
  shuffle: 'basicWeak',
  random: 'success',
};

let sdkFn: ((opts: { type: string }) => void) | null | undefined;

async function getSdk() {
  if (sdkFn !== undefined) return sdkFn;
  try {
    const mod: any = await import('@apps-in-toss/web-framework');
    sdkFn =
      mod.generateHapticFeedback ??
      mod.haptic ??
      (mod.default && mod.default.generateHapticFeedback) ??
      null;
  } catch {
    sdkFn = null;
  }
  return sdkFn;
}

function fire(type: HapticType) {
  void getSdk().then((fn) => {
    if (fn) {
      try {
        fn({ type: SDK_TYPE[type] });
        return;
      } catch {
        /* fall through to vibrate */
      }
    }
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
      try {
        navigator.vibrate(FALLBACK_MS[type]);
      } catch {
        /* no-op */
      }
    }
  });
}

export const Haptics = {
  swipe: () => fire('swipe'),
  shuffle: () => fire('shuffle'),
  random: () => fire('random'),
};
