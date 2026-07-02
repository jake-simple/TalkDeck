// 앱인토스 "앱 내 기능" 딥링크 처리.
// 콘솔에 등록하는 이동 URL 형식: intoss://<appName>/<screenName>
// getSchemeUri() 는 앱이 "처음 진입한" 스킴 값을 반환한다(페이지 이동 중 변경은 반영 안 됨).
export type DeepLinkScreen = 'packPicker' | 'themePicker' | null;

async function getSchemeUri(): Promise<string | null> {
  try {
    const mod: any = await import('@apps-in-toss/web-framework');
    const fn = (mod?.default ?? mod)?.getSchemeUri;
    if (typeof fn !== 'function') return null;
    return fn();
  } catch {
    return null;
  }
}

/** intoss://icebreakingcard/packPicker -> 'packPicker' */
export function parseScreenName(uri: string | null): string | null {
  if (!uri) return null;
  try {
    // intoss:// 스킴은 표준 URL 파서가 host/path 를 못 가를 수 있어 문자열로 직접 처리.
    const withoutScheme = uri.replace(/^[a-zA-Z][\w+.-]*:\/\//, '');
    const parts = withoutScheme.split(/[/?#]/).filter(Boolean);
    // parts[0] = appName, parts[1] = screenName
    return parts[1] ?? null;
  } catch {
    return null;
  }
}

export async function getInitialDeepLinkScreen(): Promise<DeepLinkScreen> {
  const uri = await getSchemeUri();
  const screen = parseScreenName(uri);
  if (screen === 'packPicker' || screen === 'themePicker') return screen;
  return null;
}
