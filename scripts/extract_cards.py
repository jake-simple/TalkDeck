#!/usr/bin/env python3
"""CardPackData_*.swift 파일에서 Card 데이터를 추출해 JSON으로 저장"""

import re
import json
from pathlib import Path

DATA_DIR = Path("TalkDeck/Data")
OUT_DIR = Path("TalkDeck/Resources/CardData/ko")

# CardPack rawValue → 파일명 매핑
PACK_FILES = {
    "basic": "CardData",
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

CARD_PATTERN = re.compile(r'Card\(question:\s*"((?:[^"\\]|\\.)*)"\s*,\s*category:\s*\.(\w+)\)')

def extract_from_file(filepath: Path) -> list[dict]:
    text = filepath.read_text(encoding="utf-8")
    cards = []
    for match in CARD_PATTERN.finditer(text):
        question = match.group(1).replace('\\"', '"')
        cards.append({"question": question, "category": match.group(2)})
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
