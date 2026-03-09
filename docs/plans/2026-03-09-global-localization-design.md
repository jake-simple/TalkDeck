# TalkDeck 글로벌 현지화 디자인

**날짜:** 2026-03-09
**상태:** 승인됨

---

## 목표

TalkDeck을 한국어 단일 언어에서 8개 언어 지원 앱으로 확장하여 글로벌 App Store 출시.

---

## 대상 언어 (8개)

| # | 언어 | 코드 | 주요 시장 |
|---|------|------|----------|
| 1 | 영어 | `en` | 미국, 영국, 호주, 캐나다 |
| 2 | 일본어 | `ja` | 일본 |
| 3 | 중국어 간체 | `zh-Hans` | 중국, 싱가포르, 말레이시아 |
| 4 | 스페인어 | `es` | 멕시코, 미국 라틴계, 스페인 |
| 5 | 포르투갈어 | `pt-BR` | 브라질 |
| 6 | 프랑스어 | `fr` | 프랑스, 캐나다, 벨기에 |
| 7 | 독일어 | `de` | 독일, 오스트리아, 스위스 |
| 8 | 인도네시아어 | `id` | 인도네시아 |

---

## 번역 방식

**AI 번역 (GPT/DeepL)** — 전량 AI 번역, 별도 원어민 검수 없음

번역 대상:
- 카드 질문: 16팩 × 240개 = **3,840개 질문**
- UI 문자열: 앱 내 버튼, 레이블, 설명 등 (약 50-100개)
- App Store 메타데이터: 앱 이름, 설명, 키워드 (언어별)

---

## 아키텍처

### 카드 데이터 현지화 전략

**현재 구조:**
```
CardPackData_Friends.swift  // 한국어 하드코딩
CardPackData_Couple.swift
... (16개 파일)
```

**선택지 A — 언어별 데이터 파일 분리:**
```
CardPackData_Friends_ko.swift
CardPackData_Friends_en.swift
CardPackData_Friends_ja.swift
... (16 × 9 = 144개 파일)
```
→ 단순하지만 파일 수 폭증

**선택지 B — JSON 기반 언어 리소스:**
```
Resources/
  ko/cards_friends.json
  en/cards_friends.json
  ja/cards_friends.json
```
→ 번역 관리 편리, 런타임 로드

**선택지 C — Localizable.strings + 키 기반:**
```
ko.lproj/CardQuestions.strings
en.lproj/CardQuestions.strings
```
→ Xcode 표준 방식, 3,840개 키 관리 필요

**추천: 선택지 B (JSON)** — 번역 파일을 AI가 언어별로 생성하기 쉽고, 앱 업데이트 없이 콘텐츠 수정 가능

### UI 문자열

Xcode 표준 `Localizable.strings` 방식 사용:
```
en.lproj/Localizable.strings
ja.lproj/Localizable.strings
... (8개)
```

### 언어 감지

`Locale.current.language.languageCode` → 지원 언어면 해당 언어, 미지원이면 영어 fallback

---

## 스코프 외 (이번 버전 제외)

- 아랍어 (RTL 레이아웃 개발 필요)
- 러시아어 (App Store 결제 제한)
- 중국어 번체 (간체로 커버)
- 문화적 질문 재작성 (번역만, 의미 조정 없음)

---

## 성공 기준

- [ ] 8개 언어에서 앱 빌드 및 실행 확인
- [ ] 카드 질문 전량 번역 완료 (3,840 × 8 = 30,720개)
- [ ] App Store 메타데이터 8개 언어 제출
- [ ] 언어 전환 시 UI 깨짐 없음 (긴 텍스트 대응)
