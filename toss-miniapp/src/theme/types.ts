import type { RGB, RGBA } from '../lib/colors';

export type ThemeKey =
  | 'minimal'
  | 'halloween'
  | 'christmas'
  | 'space'
  | 'cherryBlossom'
  | 'retroGame'
  | 'autumn'
  | 'aurora'
  | 'circus'
  | 'desert'
  | 'candy'
  | 'zenGarden'
  | 'forsythia'
  | 'ocean'
  | 'neonCyber'
  | 'korean'
  | 'rainyDay'
  | 'lavender';

export type FontDesign = 'default' | 'serif' | 'rounded' | 'monospaced';

export interface Theme {
  key: ThemeKey;
  /** i18n key: theme_<key> */
  nameKey: string;
  emoji: string;
  /** SF Symbol name (mapped to web icon via lib/icon) */
  iconName: string;
  cardCornerRadius: number;
  backgroundGradientColors: [RGB, RGB];
  isDark: boolean;
  textColor: RGB;
  cardTextColor: RGB;
  accentColor: RGB;
  buttonColor: RGB;
  cardBackgroundColor: RGB | RGBA;
  cardShadowColor: RGBA;
  fontDesign: FontDesign;
}

export const FONT_FAMILY: Record<FontDesign, string> = {
  default: 'var(--font-default)',
  serif: 'var(--font-serif)',
  rounded: 'var(--font-rounded)',
  monospaced: 'var(--font-mono)',
};

export const LIGHT_TEXT: RGB = [0.92, 0.92, 0.96];
export const DARK_TEXT: RGB = [0.18, 0.18, 0.22];
