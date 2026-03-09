# TalkDeck 글로벌 현지화 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** TalkDeck을 8개 언어(한국어 포함 9개)로 현지화하여 글로벌 App Store 출시

**Architecture:** 카드 질문 데이터를 Swift 하드코딩에서 JSON 파일로 마이그레이션하고, 언어별 JSON을 Bundle에서 로드. UI 문자열은 Xcode String Catalog(.xcstrings) 사용.

**Tech Stack:** Swift, SwiftUI, Xcode String Catalog, JSONDecoder, Python(마이그레이션 스크립트), GPT/DeepL API(번역)

---

## 대상 언어

| 코드 | 언어 |
|------|------|
| `ko` | 한국어 (기존) |
| `en` | 영어 |
| `ja` | 일본어 |
| `zh-Hans` | 중국어 간체 |
| `es` | 스페인어 |
| `pt-BR` | 포르투갈어 (브라질) |
| `fr` | 프랑스어 |
| `de` | 독일어 |
| `id` | 인도네시아어 |

---

## Task 1: JSON 스키마 설계 및 CardDataLoader 구현

**Files:**
- Create: `TalkDeck/Data/CardDataLoader.swift`
- Create: `TalkDeck/Resources/CardData/ko/basic.json` (샘플 1개, 검증용)

### Step 1: JSON 스키마 확정

각 팩의 JSON 파일 포맷:
```json
[
  {"question": "아무도 안 볼 때 몰래 즐기는 guilty pleasure가 있다면?", "category": "vibe"},
  {"question": "음식에 대한 가장 특이한 취향은?", "category": "vibe"}
]
```
- 파일명: `{pack.rawValue}.json` (e.g. `basic.json`, `blindDate.json`)
- 경로: `TalkDeck/Resources/CardData/{langCode}/{pack.rawValue}.json`

### Step 2: CardDataLoader.swift 작성

```swift
import Foundation

enum CardDataLoader {
    private static let supportedLanguages = ["ko", "en", "ja", "zh-Hans", "es", "pt-BR", "fr", "de", "id"]

    static func cards(for pack: CardPack) -> [Card] {
        let langCode = Locale.current.language.languageCode?.identifier ?? "en"
        let lang = supportedLanguages.contains(langCode) ? langCode : "en"
        return load(pack: pack, language: lang)
            ?? load(pack: pack, language: "en")
            ?? load(pack: pack, language: "ko")
            ?? []
    }

    private static func load(pack: CardPack, language: String) -> [Card]? {
        guard let url = Bundle.main.url(
            forResource: pack.rawValue,
            withExtension: "json",
            subdirectory: "CardData/\(language)"
        ),
        let data = try? Data(contentsOf: url),
        let items = try? JSONDecoder().decode([CardJSON].self, from: data)
        else { return nil }

        return items.compactMap { item in
            guard let category = CardCategory(rawValue: item.category) else { return nil }
            return Card(question: item.question, category: category)
        }
    }
}

private struct CardJSON: Codable {
    let question: String
    let category: String
}
```

### Step 3: basic.json 샘플 (5개) 만들어 경로 확인

`TalkDeck/Resources/CardData/ko/basic.json`:
```json
[
  {"question": "아무도 안 볼 때 몰래 즐기는 guilty pleasure가 있다면?", "category": "vibe"},
  {"question": "음식에 대한 가장 특이한 취향은?", "category": "vibe"},
  {"question": "만약 하루 동안 다른 사람이 될 수 있다면 누가 되고 싶어?", "category": "whatIf"},
  {"question": "지금까지 살면서 가장 무서웠던 순간은?", "category": "story"},
  {"question": "살면서 가장 후회하는 결정은?", "category": "deep"}
]
```

### Step 4: Xcode에서 JSON 파일을 번들에 포함

- `TalkDeck/Resources/CardData/` 폴더를 Xcode 프로젝트에 추가 (Add Files to TalkDeck)
- Target Membership: TalkDeck ✓
- **중요:** "Create folder references" 선택 (not groups)

### Step 5: 빌드 확인

```
Product → Build (⌘B)
```
Expected: 빌드 성공, JSON 파일 번들에 포함

### Step 6: Commit

```bash
git add TalkDeck/Data/CardDataLoader.swift TalkDeck/Resources/
git commit -m "feat: JSON 기반 CardDataLoader 구현 및 샘플 JSON 추가"
```

---

## Task 2: 한국어 데이터 JSON으로 마이그레이션 (스크립트)

**Files:**
- Create: `scripts/extract_cards.py`
- Create: `TalkDeck/Resources/CardData/ko/*.json` (16개 파일)

### Step 1: Python 추출 스크립트 작성

`scripts/extract_cards.py`:
```python
#!/usr/bin/env python3
"""CardPackData_*.swift 파일에서 Card 데이터를 추출해 JSON으로 저장"""

import re
import json
import os
from pathlib import Path

DATA_DIR = Path("TalkDeck/Data")
OUT_DIR = Path("TalkDeck/Resources/CardData/ko")

# CardPack rawValue → 파일명 매핑
PACK_FILES = {
    "basic": "CardData",          # CardData.swift 안에 있음
    "friends": "CardPackData_Friends",
    "couple": "CardPackData_Couple",
    "blindDate": "CardPackData_BlindDate",
    "married": "CardPackData_Married",
    "babyParents": "CardPackData_BabyParents",
    "family": "CardPackData_Family",
    "coworkers": "CardPackData_Coworkers",
    "afterFight": "CardPackData_AfterFight",
    "travel": "CardPackData_Travel",
    "icebreaking": "CardPackData_Icebreaking",
    "lateNight": "CardPackData_LateNight",
    "wouldYouRather": "CardPackData_WouldYouRather",
    "newYear": "CardPackData_NewYear",
    "hotTakes": "CardPackData_HotTakes",
    "neverHaveIEver": "CardPackData_NeverHaveIEver",
}

CARD_PATTERN = re.compile(r'Card\(question:\s*"([^"]+)",\s*category:\s*\.(\w+)\)')

def extract_from_file(filepath: Path) -> list[dict]:
    text = filepath.read_text(encoding="utf-8")
    cards = []
    for match in CARD_PATTERN.finditer(text):
        cards.append({"question": match.group(1), "category": match.group(2)})
    return cards

def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    for pack_name, swift_file in PACK_FILES.items():
        filepath = DATA_DIR / f"{swift_file}.swift"
        if not filepath.exists():
            print(f"⚠️  파일 없음: {filepath}")
            continue

        cards = extract_from_file(filepath)
        out_path = OUT_DIR / f"{pack_name}.json"
        out_path.write_text(json.dumps(cards, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"✅ {pack_name}.json: {len(cards)}개 카드")

if __name__ == "__main__":
    main()
```

### Step 2: 스크립트 실행

```bash
cd /Users/miniling/TalkDeck
python3 scripts/extract_cards.py
```

Expected:
```
✅ basic.json: 240개 카드
✅ friends.json: 240개 카드
...
✅ neverHaveIEver.json: 240개 카드
```

### Step 3: 카드 수 검증

```bash
python3 -c "
import json, os
from pathlib import Path
total = 0
for f in Path('TalkDeck/Resources/CardData/ko').glob('*.json'):
    n = len(json.loads(f.read_text()))
    print(f'{f.stem}: {n}')
    total += n
print(f'총합: {total}개')
"
```
Expected: 총합 3840개 (16팩 × 240)

### Step 4: Commit

```bash
git add scripts/ TalkDeck/Resources/CardData/ko/
git commit -m "chore: 한국어 카드 데이터 JSON으로 마이그레이션 (3840개)"
```

---

## Task 3: CardData.swift를 CardDataLoader로 교체

**Files:**
- Modify: `TalkDeck/Data/CardData.swift`

### Step 1: 현재 CardData.swift 백업 확인

현재 `CardData.swift`의 `cards(for:)` 함수를 `CardDataLoader.cards(for:)` 호출로 교체:

```swift
enum CardData {
    static func cards(for pack: CardPack) -> [Card] {
        CardDataLoader.cards(for: pack)
    }
}
```

**주의:** 기존의 `static let basicCards`, `friendsCards` 등 모든 정적 배열은 더 이상 필요 없지만, 다른 곳에서 참조하는지 먼저 확인.

### Step 2: 참조 확인

Xcode에서 `basicCards`, `friendsCards` 등을 검색하거나:
```bash
grep -r "CardData\." TalkDeck/ --include="*.swift" | grep -v "CardData\.swift" | grep -v "CardPackData"
```

참조가 없으면 `CardData.swift`를 위의 3줄로 교체.

### Step 3: 빌드 + 시뮬레이터 실행

```
Product → Run (⌘R)
```
Expected: 앱 실행, 카드가 한국어로 정상 표시

### Step 4: Commit

```bash
git add TalkDeck/Data/CardData.swift
git commit -m "refactor: CardData를 JSON 기반 CardDataLoader로 교체"
```

---

## Task 4: UI 문자열 현지화 (String Catalog)

**Files:**
- Create: `TalkDeck/Localizable.xcstrings`
- Modify: 각 View 파일에서 하드코딩 문자열 추출

### Step 1: Xcode에서 String Catalog 생성

Xcode → File → New → File → String Catalog → 이름: `Localizable`
위치: `TalkDeck/`

### Step 2: 현지화할 UI 문자열 파악

아래 파일들의 하드코딩 문자열 확인:
```bash
grep -n '"[가-힣]' TalkDeck/Views/PackPickerView.swift
grep -n '"[가-힣]' TalkDeck/Views/ThemePickerView.swift
grep -n '"[가-힣]' TalkDeck/Views/CardDeckView.swift
```

주요 대상:
- 팩 이름 (`CardPack.name`) → `CardPack.swift`에서 `String(localized:)` 적용
- 카테고리 이름 (`CardCategory`의 표시명이 있다면)
- 버튼 텍스트, 레이블

### Step 3: `String(localized:)` 적용 패턴

기존:
```swift
Text("카드 섞기")
```
변경:
```swift
Text("shuffle_cards", bundle: .main)
// 또는
Text(String(localized: "shuffle_cards"))
```

String Catalog에서:
```
Key: shuffle_cards
ko: 카드 섞기
en: Shuffle Cards
```

### Step 4: CardPack 이름 현지화

`CardPack.swift`의 `var name: String`을 `var nameKey: LocalizedStringKey`로 변경하거나 별도 다국어 테이블 사용.

간단한 방법 — `CardPack.swift`에서:
```swift
var name: String {
    String(localized: "pack_\(rawValue)_name")
}
```

String Catalog에 추가:
```
pack_basic_name: ko=기본, en=Basic, ja=基本, ...
pack_friends_name: ko=친구, en=Friends, ja=友達, ...
```

### Step 5: 8개 언어 번역 추가

String Catalog에서 각 키에 대해 아래 언어 번역 입력:
`en`, `ja`, `zh-Hans`, `es`, `pt-BR`, `fr`, `de`, `id`

### Step 6: 빌드 + 언어 전환 테스트

시뮬레이터에서 Settings → General → Language → English로 변경 후 앱 실행.
Expected: 팩 이름, UI 버튼이 영어로 표시

### Step 7: Commit

```bash
git add TalkDeck/Localizable.xcstrings TalkDeck/Models/CardPack.swift TalkDeck/Views/
git commit -m "feat: UI 문자열 String Catalog 기반 현지화 추가 (8개 언어)"
```

---

## Task 5: 카드 질문 번역 (Claude Code 직접 번역)

**Files:**
- Create: `TalkDeck/Resources/CardData/{en,ja,zh-Hans,es,pt-BR,fr,de,id}/*.json` (8 × 16 = 128개 파일)

### Step 1: 번역 스크립트 작성

의존성 설치:
```bash
pip3 install anthropic
```

`scripts/translate_cards.py`:
```python
#!/usr/bin/env python3
"""Claude Sonnet을 사용해 카드 질문을 대상 언어로 번역"""

import json
import os
import time
from pathlib import Path
import anthropic

client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

KO_DIR = Path("TalkDeck/Resources/CardData/ko")
OUT_BASE = Path("TalkDeck/Resources/CardData")

LANGUAGES = {
    "en": "English",
    "ja": "Japanese",
    "zh-Hans": "Simplified Chinese",
    "es": "Spanish (Latin American)",
    "pt-BR": "Brazilian Portuguese",
    "fr": "French",
    "de": "German",
    "id": "Indonesian",
}

SYSTEM_PROMPT = """You are a professional translator specializing in casual conversation starter questions for a card game app.
Translate the given Korean questions naturally and conversationally in {lang}.
- Keep the casual, friendly tone
- Maintain the same question format
- Preserve cultural nuance where possible, adapt where necessary
- Return ONLY a JSON array in the same format: [{{"question": "...", "category": "..."}}]
- Do NOT translate the "category" field values"""

def translate_pack(pack_name: str, lang_code: str, lang_name: str) -> list[dict]:
    ko_path = KO_DIR / f"{pack_name}.json"
    cards = json.loads(ko_path.read_text())

    # 배치로 나누어 번역 (API 토큰 한도 고려)
    batch_size = 30
    translated = []

    for i in range(0, len(cards), batch_size):
        batch = cards[i:i+batch_size]
        prompt = json.dumps(batch, ensure_ascii=False)

        message = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=4096,
            system=SYSTEM_PROMPT.format(lang=lang_name),
            messages=[{"role": "user", "content": prompt}]
        )

        result = json.loads(message.content[0].text)
        translated.extend(result)
        time.sleep(0.3)  # rate limit 방지

    return translated

def main():
    import sys
    target_lang = sys.argv[1] if len(sys.argv) > 1 else None

    langs = {target_lang: LANGUAGES[target_lang]} if target_lang else LANGUAGES

    for lang_code, lang_name in langs.items():
        out_dir = OUT_BASE / lang_code
        out_dir.mkdir(parents=True, exist_ok=True)

        for ko_file in sorted(KO_DIR.glob("*.json")):
            pack_name = ko_file.stem
            out_path = out_dir / ko_file.name

            if out_path.exists():
                print(f"⏭️  {lang_code}/{pack_name}.json 이미 존재, 스킵")
                continue

            print(f"🔄 번역 중: {lang_code}/{pack_name}.json ...")
            cards = translate_pack(pack_name, lang_code, lang_name)
            out_path.write_text(json.dumps(cards, ensure_ascii=False, indent=2))
            print(f"✅ {lang_code}/{pack_name}.json: {len(cards)}개")

if __name__ == "__main__":
    main()
```

### Step 2: 영어 1개 팩으로 먼저 테스트

```bash
export OPENAI_API_KEY="sk-..."
python3 scripts/translate_cards.py en
# basic.json 하나만 먼저 확인
cat TalkDeck/Resources/CardData/en/basic.json | head -20
```

Expected: 영어 질문 5개가 자연스럽게 번역됨

### Step 3: 전체 번역 실행

```bash
# 언어별로 순차 실행 (API 부하 분산)
python3 scripts/translate_cards.py en
python3 scripts/translate_cards.py ja
python3 scripts/translate_cards.py zh-Hans
python3 scripts/translate_cards.py es
python3 scripts/translate_cards.py pt-BR
python3 scripts/translate_cards.py fr
python3 scripts/translate_cards.py de
python3 scripts/translate_cards.py id
```

### Step 4: 번역 검증

```bash
python3 -c "
import json
from pathlib import Path
langs = ['en','ja','zh-Hans','es','pt-BR','fr','de','id']
for lang in langs:
    total = sum(len(json.loads(f.read_text())) for f in Path(f'TalkDeck/Resources/CardData/{lang}').glob('*.json'))
    status = '✅' if total == 3840 else '❌'
    print(f'{status} {lang}: {total}/3840개')
"
```

### Step 5: Xcode에 번역 JSON 추가

이미 Task 1에서 `CardData/` 폴더를 "folder reference"로 추가했다면 자동 포함.
없다면 Xcode에서 `TalkDeck/Resources/CardData/` 폴더 전체를 다시 Add.

### Step 6: 시뮬레이터 언어 변경 테스트

시뮬레이터 언어를 English로 변경 → 앱 실행 → 카드가 영어로 표시 확인

### Step 7: Commit

```bash
git add TalkDeck/Resources/CardData/ scripts/translate_cards.py
git commit -m "feat: 8개 언어 카드 질문 번역 완료 (30720개)"
```

---

## Task 6: App Store 메타데이터 현지화

**Files:**
- Create: `docs/appstore-metadata/` (각 언어별 텍스트 파일)

### Step 1: 메타데이터 디렉토리 생성

```bash
mkdir -p docs/appstore-metadata/{ko,en,ja,zh-Hans,es,pt-BR,fr,de,id}
```

### Step 2: 각 언어별 메타데이터 작성

아래 항목을 각 언어로 작성 (GPT 활용 가능):
- `name.txt` — 앱 이름 (30자 이내)
- `subtitle.txt` — 부제목 (30자 이내)
- `description.txt` — 앱 설명 (4000자 이내)
- `keywords.txt` — 키워드 (100자, 쉼표 구분)

영어 예시 (`docs/appstore-metadata/en/`):
```
name.txt: TalkDeck
subtitle.txt: Conversation Starter Card Game
keywords.txt: conversation,card game,questions,social,party,icebreaker,couple,friends
```

### Step 3: App Store Connect에 업로드

App Store Connect → 앱 → 언어 추가 → 각 언어 메타데이터 입력

### Step 4: Commit

```bash
git add docs/appstore-metadata/
git commit -m "docs: App Store 8개 언어 메타데이터 추가"
```

---

## Task 7: 최종 검증

### Checklist

- [ ] 한국어: 앱 정상 동작, 카드 3840개 로드
- [ ] 영어: 시뮬레이터 언어 전환 후 카드 + UI 영어 표시
- [ ] 일본어: 시뮬레이터 언어 전환 후 일본어 표시
- [ ] 미지원 언어 (예: 힌디어): 영어 fallback 동작 확인
- [ ] 긴 텍스트(독일어 등) UI 깨짐 없음
- [ ] App Store Connect 9개 언어 메타데이터 입력 완료

### 언어 fallback 테스트

```swift
// CardDataLoader 내부 로직 검증
// 시뮬레이터를 Hindi(hi)로 설정 → 영어 카드가 로드되는지 확인
```

### Commit

```bash
git add -A
git commit -m "chore: 글로벌 현지화 최종 검증 완료"
```

---

## 예상 번역 비용

| 항목 | 수량 | GPT-4o 예상 비용 |
|------|------|----------------|
| 카드 질문 (8개 언어) | 30,720개 | ~$8-15 |
| UI 문자열 | ~100개 × 8 | ~$0.5 |
| App Store 메타데이터 | 8개 언어 | ~$1 |
| **합계** | | **~$10-17** |

> Claude Sonnet 4.6 기준 (입력 $3/MTok, 출력 $15/MTok)
