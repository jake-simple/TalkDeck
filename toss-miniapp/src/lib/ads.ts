// 앱인토스 광고(web-framework) 추상화.
// - 배너: TossAds.initialize + attachBanner
// - 리워드/전면: loadFullScreenAd -> showFullScreenAd (userEarnedReward 로 보상 판정)
// 토스 웹뷰 밖(일반 브라우저/미지원 환경)에서는 광고 없이 안전하게 통과(fail-open)한다.

/* eslint-disable @typescript-eslint/no-explicit-any */
type Sdk = any;

let sdkPromise: Promise<Sdk | null> | undefined;
async function getSdk(): Promise<Sdk | null> {
  if (sdkPromise === undefined) {
    sdkPromise = import('@apps-in-toss/web-framework')
      .then((m: any) => (m?.default ?? m) as Sdk)
      .catch(() => null);
  }
  return sdkPromise;
}

function supported(fn: any): boolean {
  try {
    return typeof fn?.isSupported === 'function' ? fn.isSupported() === true : false;
  } catch {
    return false;
  }
}

let initPromise: Promise<boolean> | undefined;
/**
 * TossAds.initialize 는 콜백 기반 비동기 초기화라, 완료(onInitialized) 전에
 * attachBanner 를 호출하면 조용히 실패할 수 있다. 완료(또는 실패/타임아웃)까지 기다린다.
 */
function ensureInit(sdk: Sdk): Promise<boolean> {
  if (initPromise) return initPromise;
  initPromise = new Promise<boolean>((resolve) => {
    try {
      if (!sdk?.TossAds?.initialize || !supported(sdk.TossAds.initialize)) {
        resolve(false);
        return;
      }
      let settled = false;
      const finish = (ok: boolean) => {
        if (settled) return;
        settled = true;
        resolve(ok);
      };
      const timer = setTimeout(() => finish(true), 4000);
      sdk.TossAds.initialize({
        callbacks: {
          onInitialized: () => {
            clearTimeout(timer);
            finish(true);
          },
          onInitializationFailed: () => {
            clearTimeout(timer);
            finish(false);
          },
        },
      });
    } catch {
      resolve(false);
    }
  });
  return initPromise;
}

/** 광고(전면/리워드)가 현재 환경에서 지원되는지 */
export async function rewardedAdSupported(): Promise<boolean> {
  const sdk = await getSdk();
  return supported(sdk?.showFullScreenAd) && supported(sdk?.loadFullScreenAd);
}

/**
 * 하단 배너 부착. 반환된 정리 함수를 호출하면 배너를 제거한다.
 * 미지원 환경에서는 아무것도 하지 않는다.
 */
export async function attachBanner(
  adGroupId: string,
  target: HTMLElement,
  theme: 'light' | 'dark'
): Promise<() => void> {
  const sdk = await getSdk();
  if (!sdk?.TossAds?.attachBanner) {
    console.warn('[ads] TossAds.attachBanner 를 찾을 수 없어요 (SDK 미로드/미지원 환경)');
    return () => {};
  }
  const ok = await ensureInit(sdk);
  if (!ok) {
    console.warn('[ads] TossAds.initialize 실패/미지원 — 배너를 붙이지 않아요');
    return () => {};
  }
  try {
    const res = sdk.TossAds.attachBanner(adGroupId, target, {
      theme,
      variant: 'card',
      callbacks: {
        onAdRendered: () => console.info('[ads] banner rendered', adGroupId),
        onAdFailedToRender: (p: any) =>
          console.warn('[ads] banner failed to render', adGroupId, p),
        onNoFill: (p: any) => console.warn('[ads] banner no fill', adGroupId, p),
      },
    });
    return () => {
      try {
        res?.destroy?.();
      } catch {
        /* no-op */
      }
    };
  } catch (e) {
    console.warn('[ads] attachBanner 호출 중 오류', e);
    return () => {};
  }
}

/**
 * 리워드(전면) 광고를 노출하고, 보상 획득 여부를 resolve.
 * - userEarnedReward -> true
 * - 끝까지 안 보고 닫음(dismissed without reward) -> false
 * - 미지원/로드실패/노출실패/타임아웃 -> true (fail-open: 광고 인프라 문제로 사용자를 막지 않음)
 */
export async function showRewardedAd(adGroupId: string): Promise<boolean> {
  const sdk = await getSdk();
  if (!(supported(sdk?.showFullScreenAd) && supported(sdk?.loadFullScreenAd))) {
    return true;
  }
  return new Promise<boolean>((resolve) => {
    let settled = false;
    let rewarded = false;
    const done = (v: boolean) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      resolve(v);
    };
    const timer = setTimeout(() => done(true), 45000);
    try {
      sdk.loadFullScreenAd({
        options: { adGroupId },
        onEvent: (e: any) => {
          if (e?.type !== 'loaded') return;
          sdk.showFullScreenAd({
            options: { adGroupId },
            onEvent: (se: any) => {
              if (se?.type === 'userEarnedReward') rewarded = true;
              else if (se?.type === 'dismissed') done(rewarded);
              else if (se?.type === 'failedToShow') done(true);
            },
            onError: () => done(true),
          });
        },
        onError: () => done(true),
      });
    } catch {
      done(true);
    }
  });
}
