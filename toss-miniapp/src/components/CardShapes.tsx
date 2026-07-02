import type { CSSProperties, ReactNode } from 'react';
import type { Theme } from '../theme/types';
import { rgb, rgba } from '../lib/colors';
import type { RGB } from '../lib/colors';

// SwiftUI CardShapes.swift -> SVG 포팅.
// 카드는 대략 정사각형(최대 400x400)이며 반응형이어야 한다.
// viewBox="0 0 100 100" + preserveAspectRatio="none" 로 카드 크기에 맞춰 늘어나되,
// stroke 두께는 vectorEffect="non-scaling-stroke" 로 픽셀 기준 일정하게 유지한다.
//
// 좌표계: viewBox 100 단위가 최대 카드폭 ~400px 에 대응하므로
// SwiftUI 의 pt 값을 약 1/4 로 환산해 viewBox 단위(VB)로 사용한다.

const VB = 100; // viewBox 한 변
const SCALE = 4; // 400px 카드 기준 pt -> VB 환산 계수

/** SwiftUI cardCornerRadius(pt) -> viewBox 단위 rx */
function vbRadius(theme: Theme): number {
  return theme.cardCornerRadius / SCALE;
}

/** pt -> viewBox 단위 (좌표/패딩용) */
function vb(pt: number): number {
  return pt / SCALE;
}

const wrapperStyle: CSSProperties = {
  position: 'absolute',
  inset: 0,
  width: '100%',
  height: '100%',
  pointerEvents: 'none',
};

interface SvgProps {
  children: ReactNode;
  defs?: ReactNode;
}

/** 공통 SVG 래퍼: 카드에 맞춰 늘어나는 오버레이 */
function BorderSvg({ children, defs }: SvgProps) {
  return (
    <div style={wrapperStyle} aria-hidden>
      <svg
        width="100%"
        height="100%"
        viewBox={`0 0 ${VB} ${VB}`}
        preserveAspectRatio="none"
        style={{ display: 'block' }}
      >
        {defs ? <defs>{defs}</defs> : null}
        {children}
      </svg>
    </div>
  );
}

/**
 * 둥근 사각형 stroke. inset(VB 단위)만큼 안쪽으로 들여 그린다.
 * stroke 폭은 non-scaling-stroke 로 픽셀 기준.
 */
interface RectStrokeProps {
  inset: number; // viewBox 단위
  rx: number; // viewBox 단위
  stroke: string;
  strokeWidth: number; // px
  dash?: string;
  filter?: string;
}

function RectStroke({ inset, rx, stroke, strokeWidth, dash, filter }: RectStrokeProps) {
  const size = VB - inset * 2;
  return (
    <rect
      x={inset}
      y={inset}
      width={size}
      height={size}
      rx={Math.max(0, rx)}
      ry={Math.max(0, rx)}
      fill="none"
      stroke={stroke}
      strokeWidth={strokeWidth}
      strokeDasharray={dash}
      vectorEffect="non-scaling-stroke"
      filter={filter}
    />
  );
}

/** 가우시안 블러 글로우 필터 정의 */
function GlowFilter({ id, std }: { id: string; std: number }) {
  return (
    <filter id={id} x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation={std} />
    </filter>
  );
}

type Stop = { offset: string; color: string };

function LinearGrad({ id, stops, diagonal = true }: { id: string; stops: Stop[]; diagonal?: boolean }) {
  // SwiftUI topLeading -> bottomTrailing 대각선 그라데이션
  const coords = diagonal
    ? { x1: '0%', y1: '0%', x2: '100%', y2: '100%' }
    : { x1: '0%', y1: '0%', x2: '0%', y2: '100%' };
  return (
    <linearGradient id={id} {...coords}>
      {stops.map((s, i) => (
        <stop key={i} offset={s.offset} stopColor={s.color} />
      ))}
    </linearGradient>
  );
}

// SwiftUI AngularGradient 는 SVG 로 직접 표현이 어려워
// 다색 conic 느낌을 주는 다중 stop linearGradient(대각선) 로 근사한다.
function AngularApprox({ id, stops }: { id: string; stops: Stop[] }) {
  return (
    <linearGradient id={id} x1="0%" y1="0%" x2="100%" y2="100%">
      {stops.map((s, i) => (
        <stop key={i} offset={s.offset} stopColor={s.color} />
      ))}
    </linearGradient>
  );
}

export function ThemedCardBorder({ theme }: { theme: Theme }) {
  const rx = vbRadius(theme);

  switch (theme.key) {
    case 'minimal': {
      // 깔끔한 이중 테두리 (밝은 회색 두 줄)
      const outer: RGB = [0.75, 0.75, 0.78];
      const inner: RGB = [0.82, 0.82, 0.85];
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx} stroke={rgb(outer)} strokeWidth={1.5} />
          <RectStroke inset={vb(6)} rx={Math.max(0, rx - vb(5))} stroke={rgb(inner)} strokeWidth={0.8} />
        </BorderSvg>
      );
    }

    case 'halloween': {
      // 주황 이중 테두리: 바깥 옅은 줄 + 안쪽 진한 줄
      const orange: RGB = [0.95, 0.55, 0.1];
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx + vb(4)} stroke={rgba(orange, 0.2)} strokeWidth={1} />
          <RectStroke inset={vb(4)} rx={rx} stroke={rgba(orange, 0.5)} strokeWidth={2} />
        </BorderSvg>
      );
    }

    case 'christmas': {
      // 금색 그라데이션 오너먼트 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgb([0.85, 0.7, 0.2]) },
        { offset: '50%', color: rgb([0.95, 0.85, 0.4]) },
        { offset: '100%', color: rgb([0.85, 0.7, 0.2]) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="xmasGold" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#xmasGold)" strokeWidth={3} />
        </BorderSvg>
      );
    }

    case 'space': {
      // 보라색 점선 + 바깥 글로우
      const purple: RGB = [0.55, 0.35, 0.95];
      return (
        <BorderSvg defs={<GlowFilter id="spaceGlow" std={1.2} />}>
          <RectStroke inset={0} rx={rx} stroke={rgba(purple, 0.15)} strokeWidth={6} filter="url(#spaceGlow)" />
          <RectStroke inset={0} rx={rx} stroke={rgba(purple, 0.4)} strokeWidth={2} dash="6 4" />
        </BorderSvg>
      );
    }

    case 'cherryBlossom': {
      // 섬세한 분홍 한 줄
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx} stroke={rgba([0.95, 0.7, 0.8], 0.5)} strokeWidth={1.5} />
        </BorderSvg>
      );
    }

    case 'retroGame': {
      // 네온 그린 픽셀 테두리 + 글로우
      const green: RGB = [0.1, 0.95, 0.4];
      return (
        <BorderSvg defs={<GlowFilter id="retroGlow" std={1.8} />}>
          <RectStroke inset={0} rx={rx} stroke={rgba(green, 0.3)} strokeWidth={8} filter="url(#retroGlow)" />
          <RectStroke inset={0} rx={rx} stroke={rgb(green)} strokeWidth={2.5} />
        </BorderSvg>
      );
    }

    case 'autumn': {
      // 따뜻한 갈색 그라데이션 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.75, 0.5, 0.2], 0.4) },
        { offset: '100%', color: rgba([0.85, 0.6, 0.25], 0.3) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="autumnBrown" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#autumnBrown)" strokeWidth={2} />
        </BorderSvg>
      );
    }

    case 'aurora': {
      // 무지개 글로우 테두리 (angular 근사)
      const main: Stop[] = [
        { offset: '0%', color: rgba([0.1, 0.9, 0.5], 0.5) },
        { offset: '40%', color: rgba([0.3, 0.5, 0.9], 0.4) },
        { offset: '75%', color: rgba([0.7, 0.2, 0.8], 0.5) },
        { offset: '100%', color: rgba([0.1, 0.9, 0.5], 0.5) },
      ];
      const glow: Stop[] = [
        { offset: '0%', color: rgba([0.1, 0.9, 0.5], 0.2) },
        { offset: '50%', color: rgba([0.7, 0.2, 0.8], 0.15) },
        { offset: '100%', color: rgba([0.1, 0.9, 0.5], 0.2) },
      ];
      return (
        <BorderSvg
          defs={
            <>
              <AngularApprox id="auroraMain" stops={main} />
              <AngularApprox id="auroraGlow" stops={glow} />
              <GlowFilter id="auroraBlur" std={1.5} />
            </>
          }
        >
          <RectStroke inset={0} rx={rx} stroke="url(#auroraGlow)" strokeWidth={8} filter="url(#auroraBlur)" />
          <RectStroke inset={0} rx={rx} stroke="url(#auroraMain)" strokeWidth={2.5} />
        </BorderSvg>
      );
    }

    case 'circus': {
      // 빨강 두꺼운 테두리 + 안쪽 금색 얇은 줄
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx} stroke={rgb([0.9, 0.2, 0.3])} strokeWidth={3} />
          <RectStroke inset={vb(5)} rx={rx} stroke={rgba([0.95, 0.8, 0.15], 0.5)} strokeWidth={1} />
        </BorderSvg>
      );
    }

    case 'desert': {
      // 모래색 은은한 그라데이션 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.9, 0.75, 0.35], 0.5) },
        { offset: '50%', color: rgba([0.8, 0.65, 0.3], 0.3) },
        { offset: '100%', color: rgba([0.9, 0.75, 0.35], 0.5) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="desertSand" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#desertSand)" strokeWidth={1.5} />
        </BorderSvg>
      );
    }

    case 'candy': {
      // 다색 캔디 테두리 (angular 근사)
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.95, 0.35, 0.55], 0.6) },
        { offset: '25%', color: rgba([0.55, 0.85, 0.75], 0.5) },
        { offset: '50%', color: rgba([0.98, 0.8, 0.25], 0.6) },
        { offset: '75%', color: rgba([0.65, 0.5, 0.9], 0.5) },
        { offset: '100%', color: rgba([0.95, 0.35, 0.55], 0.6) },
      ];
      return (
        <BorderSvg defs={<AngularApprox id="candyMix" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#candyMix)" strokeWidth={3} />
        </BorderSvg>
      );
    }

    case 'zenGarden': {
      // 미니멀 얇은 차콜 한 줄
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx} stroke={rgba([0.4, 0.42, 0.38], 0.25)} strokeWidth={1} />
        </BorderSvg>
      );
    }

    case 'forsythia': {
      // 선명한 노랑 그라데이션 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.98, 0.85, 0.08], 0.6) },
        { offset: '50%', color: rgba([0.9, 0.75, 0.05], 0.4) },
        { offset: '100%', color: rgba([0.98, 0.85, 0.08], 0.6) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="forsythiaYellow" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#forsythiaYellow)" strokeWidth={2.5} />
        </BorderSvg>
      );
    }

    case 'ocean': {
      // 부드러운 파랑 그라데이션 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.2, 0.6, 0.85], 0.4) },
        { offset: '50%', color: rgba([0.4, 0.75, 0.9], 0.3) },
        { offset: '100%', color: rgba([0.2, 0.6, 0.85], 0.4) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="oceanBlue" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#oceanBlue)" strokeWidth={2} />
        </BorderSvg>
      );
    }

    case 'neonCyber': {
      // 네온 핑크/시안 이중 테두리 + 핑크 글로우
      const pink: RGB = [0.95, 0.2, 0.6];
      const cyan: RGB = [0.0, 0.95, 0.9];
      return (
        <BorderSvg defs={<GlowFilter id="neonGlow" std={1.8} />}>
          <RectStroke inset={0} rx={rx} stroke={rgba(pink, 0.3)} strokeWidth={8} filter="url(#neonGlow)" />
          <RectStroke inset={0} rx={rx} stroke={rgb(pink)} strokeWidth={2} />
          <RectStroke inset={vb(4)} rx={rx} stroke={rgba(cyan, 0.3)} strokeWidth={1} />
        </BorderSvg>
      );
    }

    case 'korean': {
      // 한지 느낌: 따뜻한 갈색 테두리 + 안쪽 붉은 선
      return (
        <BorderSvg>
          <RectStroke inset={0} rx={rx} stroke={rgba([0.65, 0.45, 0.25], 0.35)} strokeWidth={1.5} />
          <RectStroke
            inset={vb(6)}
            rx={Math.max(0, rx - vb(4))}
            stroke={rgba([0.78, 0.22, 0.28], 0.15)}
            strokeWidth={0.8}
          />
        </BorderSvg>
      );
    }

    case 'rainyDay': {
      // 차분한 블루그레이 테두리 + 부드러운 글로우
      return (
        <BorderSvg defs={<GlowFilter id="rainyGlow" std={1.2} />}>
          <RectStroke inset={0} rx={rx} stroke={rgba([0.5, 0.65, 0.8], 0.15)} strokeWidth={6} filter="url(#rainyGlow)" />
          <RectStroke inset={0} rx={rx} stroke={rgba([0.4, 0.5, 0.65], 0.3)} strokeWidth={1.5} />
        </BorderSvg>
      );
    }

    case 'lavender': {
      // 부드러운 보라 그라데이션 테두리
      const stops: Stop[] = [
        { offset: '0%', color: rgba([0.7, 0.5, 0.9], 0.4) },
        { offset: '50%', color: rgba([0.55, 0.35, 0.75], 0.3) },
        { offset: '100%', color: rgba([0.7, 0.5, 0.9], 0.4) },
      ];
      return (
        <BorderSvg defs={<LinearGrad id="lavenderPurple" stops={stops} />}>
          <RectStroke inset={0} rx={rx} stroke="url(#lavenderPurple)" strokeWidth={2} />
        </BorderSvg>
      );
    }

    default:
      return null;
  }
}
