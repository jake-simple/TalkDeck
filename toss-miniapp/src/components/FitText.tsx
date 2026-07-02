import { type CSSProperties, useLayoutEffect, useRef, useState } from 'react';

interface FitTextProps {
  text: string;
  /** base font size in px (scale = 1) */
  baseSize: number;
  /** minimum scale factor, like SwiftUI minimumScaleFactor */
  minScale?: number;
  fontFamily?: string;
  fontWeight?: number | string;
  color?: string;
  lineHeight?: number; // px line spacing baseline → use as CSS line-height multiple
  letterSpacing?: number;
  italic?: boolean;
  textAlign?: CSSProperties['textAlign'];
  paddingX?: number;
  prefix?: string;
}

// SwiftUI minimumScaleFactor 재현: 컨테이너에 맞을 때까지 폰트 스케일 축소.
export function FitText({
  text,
  baseSize,
  minScale = 0.55,
  fontFamily,
  fontWeight = 600,
  color,
  lineHeight = 1.3,
  letterSpacing,
  italic,
  textAlign = 'center',
  paddingX = 0,
  prefix,
}: FitTextProps) {
  const outerRef = useRef<HTMLDivElement>(null);
  const innerRef = useRef<HTMLDivElement>(null);
  const [size, setSize] = useState(baseSize);

  useLayoutEffect(() => {
    const outer = outerRef.current;
    const inner = innerRef.current;
    if (!outer || !inner) return;

    const fit = () => {
      const maxW = outer.clientWidth;
      const maxH = outer.clientHeight;
      if (maxW === 0 || maxH === 0) return;
      let lo = baseSize * minScale;
      let hi = baseSize;
      // 빠른 경로: 최대 크기로 맞으면 그대로.
      inner.style.fontSize = `${hi}px`;
      if (inner.scrollHeight <= maxH && inner.scrollWidth <= maxW) {
        setSize(hi);
        return;
      }
      // 이진 탐색
      for (let i = 0; i < 12; i++) {
        const mid = (lo + hi) / 2;
        inner.style.fontSize = `${mid}px`;
        if (inner.scrollHeight <= maxH && inner.scrollWidth <= maxW) {
          lo = mid;
        } else {
          hi = mid;
        }
      }
      setSize(lo);
    };

    fit();
    const ro = new ResizeObserver(fit);
    ro.observe(outer);
    return () => ro.disconnect();
  }, [text, baseSize, minScale, prefix]);

  return (
    <div
      ref={outerRef}
      style={{
        flex: '1 1 auto',
        width: '100%',
        minHeight: 0,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        paddingLeft: paddingX,
        paddingRight: paddingX,
        overflow: 'hidden',
      }}
    >
      <div
        ref={innerRef}
        style={{
          fontSize: size,
          fontFamily,
          fontWeight,
          color,
          lineHeight,
          letterSpacing,
          fontStyle: italic ? 'italic' : undefined,
          textAlign,
          width: '100%',
          wordBreak: 'keep-all',
          whiteSpace: 'pre-wrap',
        }}
      >
        {prefix}
        {text}
      </div>
    </div>
  );
}
