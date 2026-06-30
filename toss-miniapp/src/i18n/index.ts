import strings from './strings.json';

export const SUPPORTED_LANGS = [
  'ko',
  'en',
  'ja',
  'zh-Hans',
  'es',
  'pt-BR',
  'fr',
  'de',
  'id',
] as const;

export type Lang = (typeof SUPPORTED_LANGS)[number];

const TABLE = strings as Record<string, Record<string, string>>;

function detectLang(): Lang {
  const nav =
    typeof navigator !== 'undefined'
      ? navigator.language || (navigator.languages && navigator.languages[0])
      : 'en';
  const lower = (nav || 'en').toLowerCase();
  if (lower.startsWith('ko')) return 'ko';
  if (lower.startsWith('ja')) return 'ja';
  if (lower.startsWith('zh')) return 'zh-Hans';
  if (lower.startsWith('es')) return 'es';
  if (lower.startsWith('pt')) return 'pt-BR';
  if (lower.startsWith('fr')) return 'fr';
  if (lower.startsWith('de')) return 'de';
  if (lower.startsWith('id')) return 'id';
  if (lower.startsWith('en')) return 'en';
  return 'en';
}

export const CURRENT_LANG: Lang = detectLang();

export function t(key: string): string {
  const langTable = TABLE[CURRENT_LANG] ?? TABLE.en;
  return langTable?.[key] ?? TABLE.en?.[key] ?? key;
}
