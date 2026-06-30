# TalkDeck (이야기 카드) — 앱인토스 미니앱

네이티브 SwiftUI 앱 `TalkDeck` 을 [앱인토스(Apps in Toss)](https://developers-apps-in-toss.toss.im/) **웹 프레임워크** 미니앱으로 이식한 프로젝트입니다. React + TypeScript + Granite(`@apps-in-toss/web-framework`) 기반입니다.

## 스택

- `@apps-in-toss/web-framework` (Granite) + React 18 + TypeScript
- 번들러: rsbuild (`ait dev` / `ait build` 가 내부적으로 사용)
- 상태관리: zustand
- 아이콘: remixicon (SF Symbol → 웹 아이콘 매핑은 `src/lib/icon.tsx`)

## 개발 / 빌드 / 배포

```bash
npm install          # 또는 yarn

# 앱인토스(Granite) 개발 서버
npm run dev          # ait dev

# 일반 웹(rsbuild) 단독 실행 — 토스 SDK 없이 UI 확인용
npm run standalone:dev

npm run typecheck    # tsc --noEmit
npm run build        # ait build
npm run deploy       # ait deploy (앱인토스 콘솔 배포)
```

> `granite.config.ts` 의 `brand.icon` 은 토스 개발자센터 콘솔에 업로드한 실제 아이콘 URL로 교체해야 합니다. `appName` / `displayName` / `primaryColor` 도 콘솔 등록 값과 맞춰주세요.

## 구조

```
src/
  index.tsx              엔트리 (root 마운트)
  App.tsx                덱 데이터 로드 + DeckScreen
  i18n/
    strings.json         9개 언어 UI 문자열 (Localizable.xcstrings 추출)
    index.ts             언어 감지 + t(key)
  data/
    cards/<lang>.json    9개 언어 × 15팩 카드 데이터 (언어별 비동기 청크)
    cards.ts             팩별 카드 로더
  theme/
    types.ts             Theme/ThemeKey/FontDesign 타입
    themes.ts            18개 테마 토큰 (AppTheme.swift 1:1 이식)
    packs.ts             15개 팩 토큰 (CardPack.swift)
    categories.ts        카테고리 토큰 + gameDrawCount (CardCategory.swift)
  store/
    useDeck.ts           덱 빌드/셔플/필터/스와이프 로직 (CardDeckViewModel)
    useThemeStore.ts     테마 선택 + localStorage 영속화 (@AppStorage)
  lib/
    colors.ts            SwiftUI 0~1 RGB → rgba 변환
    icon.tsx             SF Symbol → remixicon/이모지 매핑
    haptics.ts           앱인토스 햅틱 브리지 (+ navigator.vibrate 폴백)
  components/
    DeckScreen.tsx       메인 화면 (헤더/카드스택/스와이프/하단바/랜덤)
    CardView.tsx         18개 테마별 TCG 카드 레이아웃
    CardShapes.tsx       테마별 카드 보더 (ThemedCardBorder)
    CardDecorations.tsx  테마별 배경 패턴 + 장식 오버레이
    ThemeParticleScene.tsx  18개 테마 Canvas 애니메이션 배경
    FitText.tsx          minimumScaleFactor 재현 (자동 축소)
    FanScroller.tsx      무한 팬/커버플로 스크롤러 (scrollTransition)
    PackPicker.tsx       팩 선택 오버레이
    ThemePicker.tsx      테마 선택 오버레이
```

## 원본과의 매핑 / 비고

- **데이터·다국어**: 원본 iOS 앱이 이미 런타임 JSON(`CardData/<lang>/<pack>.json`)으로 카드를 로드하고 있어, 9개 언어(ko/en/ja/zh-Hans/es/pt-BR/fr/de/id) 전체를 그대로 이식했습니다.
- **18개 테마 풀 비주얼 패리티**: 테마별 색/폰트/코너, 카드 보더, 배경 패턴/장식, Canvas 파티클 배경, TCG 카드 레이아웃을 모두 재현했습니다.
- **SF Symbols**: iOS 전용이라 remixicon + 이모지로 매핑했습니다(`src/lib/icon.tsx`). 일부 장식 아이콘은 가장 가까운 대체 아이콘을 사용합니다.
- **햅틱**: 앱인토스 SDK 햅틱을 best-effort 로 호출하고, 토스 웹뷰 밖에서는 `navigator.vibrate` 로 폴백합니다. SDK 함수명/시그니처는 실제 버전에 맞춰 `src/lib/haptics.ts` 에서 조정하세요.
- **화면 켜짐 유지(Screen always-on)**: 웹 `navigator.wakeLock` 으로 best-effort 구현.
- **셰이크 → 랜덤 카드**: `devicemotion` 이벤트로 구현(iOS Safari 는 권한 필요, 토스 웹뷰 환경에 맞춰 조정 가능).
- TipKit 온보딩 팁은 이식 범위에서 제외했습니다(플랫폼 종속 기능).

## 출시 전 체크리스트 (코드 외)

- 사업자등록 및 토스 개발자센터 파트너 입점 신청
- 콘솔에 앱 등록(아이콘/스플래시/메타데이터) 후 `granite.config.ts` 값 일치
- 토스 심사 + QA (평균 2~4주), 만 19세 이상 대상 / iOS 16+, Android 7+
