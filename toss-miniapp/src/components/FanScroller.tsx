import {
  type CSSProperties,
  type ReactNode,
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react';

export interface FanPhaseStyle {
  scale: number;
  rotateDeg: number;
  translateY: number;
  rotate3dDeg?: number;
  perspective?: number;
  opacity?: number;
}

interface FanScrollerProps<T> {
  items: T[];
  initialIndex: number;
  cardWidth: number;
  /** spacing between cards (can be negative to overlap, like SwiftUI spacing) */
  gap: number;
  height: number;
  /** transform per card based on phase (0 = centered, ±1 = one card away) */
  phaseStyle: (phase: number) => FanPhaseStyle;
  renderCard: (item: T, centered: boolean, index: number) => ReactNode;
  onCenterChange?: (originalIndex: number) => void;
  onActivate?: (originalIndex: number) => void;
}

const REPEAT = 9;

// SwiftUI 의 무한 팬 스크롤 + scrollTransition 재현.
export function FanScroller<T>({
  items,
  initialIndex,
  cardWidth,
  gap,
  height,
  phaseStyle,
  renderCard,
  onCenterChange,
  onActivate,
}: FanScrollerProps<T>) {
  const len = items.length;
  const total = REPEAT * len;
  const middleBlock = Math.floor(REPEAT / 2);
  const slot = cardWidth + gap;

  const scrollerRef = useRef<HTMLDivElement>(null);
  const cardRefs = useRef<(HTMLDivElement | null)[]>([]);
  const rafRef = useRef<number | null>(null);
  const [centered, setCentered] = useState(middleBlock * len + initialIndex);
  const centeredRef = useRef(centered);
  centeredRef.current = centered;
  const [pad, setPad] = useState(0);

  // 가운데 정렬을 위한 좌우 패딩
  useEffect(() => {
    const el = scrollerRef.current;
    if (!el) return;
    const update = () => setPad(Math.max(0, el.clientWidth / 2 - cardWidth / 2));
    update();
    const ro = new ResizeObserver(update);
    ro.observe(el);
    return () => ro.disconnect();
  }, [cardWidth]);

  // 초기 스크롤 위치 = 중앙 블록 + initialIndex
  useEffect(() => {
    const el = scrollerRef.current;
    if (!el || pad === 0) return;
    const target = middleBlock * len + initialIndex;
    el.scrollLeft = target * slot;
    centeredRef.current = target;
    setCentered(target);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pad, len]);

  const applyTransforms = useCallback(() => {
    const el = scrollerRef.current;
    if (!el) return;
    const viewCenter = el.scrollLeft + el.clientWidth / 2;
    let best = 0;
    let bestDist = Infinity;
    for (let i = 0; i < total; i++) {
      const node = cardRefs.current[i];
      if (!node) continue;
      const cardCenter = pad + i * slot + cardWidth / 2;
      const phase = (cardCenter - viewCenter) / slot;
      const dist = Math.abs(phase);
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
      // 화면에서 너무 먼 카드는 스킵 (성능)
      if (dist > 4) {
        node.style.visibility = 'hidden';
        continue;
      }
      node.style.visibility = 'visible';
      const s = phaseStyle(phase);
      const parts = [
        `scale(${s.scale})`,
        `rotate(${s.rotateDeg}deg)`,
        `translateY(${s.translateY}px)`,
      ];
      if (s.rotate3dDeg !== undefined) {
        parts.unshift(
          `perspective(${s.perspective ?? 600}px) rotateY(${s.rotate3dDeg}deg)`
        );
      }
      node.style.transform = parts.join(' ');
      node.style.opacity = String(s.opacity ?? 1);
      node.style.zIndex = String(1000 - Math.round(dist * 10));
    }
    if (best !== centeredRef.current) {
      centeredRef.current = best;
      setCentered(best);
      onCenterChange?.(((best % len) + len) % len);
    }
    // 가장자리 근처면 중앙 블록으로 재배치 (무한 스크롤)
    if (best < len || best >= total - len) {
      const offset = best - (middleBlock * len + (((best % len) + len) % len));
      el.scrollLeft -= offset * slot;
    }
  }, [pad, slot, cardWidth, total, len, middleBlock, phaseStyle, onCenterChange]);

  const onScroll = useCallback(() => {
    if (rafRef.current != null) return;
    rafRef.current = requestAnimationFrame(() => {
      rafRef.current = null;
      applyTransforms();
    });
  }, [applyTransforms]);

  useEffect(() => {
    applyTransforms();
  }, [applyTransforms, pad]);

  const centerOn = (i: number) => {
    const el = scrollerRef.current;
    if (!el) return;
    el.scrollTo({ left: i * slot, behavior: 'smooth' });
  };

  return (
    <div
      ref={scrollerRef}
      onScroll={onScroll}
      className="no-select"
      style={{
        height,
        width: '100%',
        overflowX: 'auto',
        overflowY: 'hidden',
        display: 'flex',
        alignItems: 'center',
        scrollSnapType: 'x mandatory',
        WebkitOverflowScrolling: 'touch',
        scrollbarWidth: 'none',
        paddingLeft: pad,
        paddingRight: pad,
      }}
    >
      {Array.from({ length: total }).map((_, i) => {
        const item = items[((i % len) + len) % len];
        const isCentered = i === centered;
        const cardStyle: CSSProperties = {
          flex: `0 0 ${cardWidth}px`,
          width: cardWidth,
          height: '100%',
          marginRight: gap,
          scrollSnapAlign: 'center',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          transition: 'transform 0.15s ease-out, opacity 0.15s ease-out',
          willChange: 'transform',
        };
        return (
          <div
            key={i}
            ref={(n) => {
              cardRefs.current[i] = n;
            }}
            style={cardStyle}
            onClick={() => {
              if (i === centeredRef.current) {
                onActivate?.(((i % len) + len) % len);
              } else {
                centerOn(i);
              }
            }}
          >
            {renderCard(item, isCentered, ((i % len) + len) % len)}
          </div>
        );
      })}
    </div>
  );
}
