import type { CategoryKey } from '../theme/categories';
import type { PackKey } from '../theme/packs';
import { CURRENT_LANG, type Lang } from '../i18n';

export interface Card {
  id: string;
  question: string;
  category: CategoryKey;
}

type RawCard = { question: string; category: string };
type LangBundle = Record<string, RawCard[]>;

// 언어별 카드 묶음을 비동기 청크로 로드 (rsbuild/rspack 코드 스플리팅).
async function loadBundle(lang: Lang): Promise<LangBundle> {
  switch (lang) {
    case 'ko':
      return (await import('./cards/ko.json')).default as LangBundle;
    case 'ja':
      return (await import('./cards/ja.json')).default as LangBundle;
    case 'zh-Hans':
      return (await import('./cards/zh-Hans.json')).default as LangBundle;
    case 'es':
      return (await import('./cards/es.json')).default as LangBundle;
    case 'pt-BR':
      return (await import('./cards/pt-BR.json')).default as LangBundle;
    case 'fr':
      return (await import('./cards/fr.json')).default as LangBundle;
    case 'de':
      return (await import('./cards/de.json')).default as LangBundle;
    case 'id':
      return (await import('./cards/id.json')).default as LangBundle;
    case 'en':
    default:
      return (await import('./cards/en.json')).default as LangBundle;
  }
}

let cache: LangBundle | null = null;

export async function loadCards(pack: PackKey): Promise<Card[]> {
  if (!cache) {
    cache = await loadBundle(CURRENT_LANG).catch(
      async () => (await import('./cards/en.json')).default as LangBundle
    );
  }
  const raw = cache[pack] ?? [];
  return raw.map((item, i) => ({
    id: `${pack}-${i}`,
    question: item.question,
    category: item.category as CategoryKey,
  }));
}
