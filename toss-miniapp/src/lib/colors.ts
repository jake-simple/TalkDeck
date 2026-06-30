// SwiftUI Color(red:green:blue:) 는 0~1 범위. 웹 rgba 문자열로 변환.
export type RGB = readonly [number, number, number];
export type RGBA = readonly [number, number, number, number];

export function rgb(c: RGB | RGBA): string {
  const r = Math.round(c[0] * 255);
  const g = Math.round(c[1] * 255);
  const b = Math.round(c[2] * 255);
  const a = c.length === 4 ? (c as RGBA)[3] : 1;
  return `rgba(${r}, ${g}, ${b}, ${a})`;
}

// 불투명도만 덧입힐 때 (SwiftUI .opacity())
export function rgba(c: RGB, alpha: number): string {
  return rgb([c[0], c[1], c[2], alpha]);
}

export function linearGradient(
  colors: string[],
  angle = 180 // 'top -> bottom' 기본
): string {
  return `linear-gradient(${angle}deg, ${colors.join(', ')})`;
}
