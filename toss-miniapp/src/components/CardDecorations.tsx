import type { CSSProperties, ReactNode } from 'react';
import type { Theme } from '../theme/types';
import type { RGB } from '../lib/colors';
import { rgb, rgba } from '../lib/colors';

// SwiftUI Canvas decorations are drawn in the card's pixel space. We reproduce
// them in an SVG with a fixed viewBox and preserveAspectRatio="none" so the
// drawing stretches to fill whatever card size the parent gives us. The parent
// clips both layers to the rounded card rect (see CardView), so we just fill
// the area (position:absolute, inset:0, 100%x100%, pointerEvents:none).
//
// Reference card box used for the overlay drawings. Width/height roughly match a
// portrait question card; corner/edge-anchored ornaments stay visually correct
// under non-uniform scaling.
const VB_W = 320;
const VB_H = 440;

const fillLayer: CSSProperties = {
  position: 'absolute',
  inset: 0,
  width: '100%',
  height: '100%',
  pointerEvents: 'none',
};

function Svg({ children }: { children: ReactNode }) {
  return (
    <svg
      style={fillLayer}
      viewBox={`0 0 ${VB_W} ${VB_H}`}
      preserveAspectRatio="none"
      xmlns="http://www.w3.org/2000/svg"
      aria-hidden="true"
    >
      {children}
    </svg>
  );
}

// ---------------------------------------------------------------------------
// CardBackgroundPattern — subtle texture/gradient fill behind the content.
// ---------------------------------------------------------------------------

export function CardBackgroundPattern({ theme }: { theme: Theme }) {
  const bg = rgb(theme.cardBackgroundColor);

  switch (theme.key) {
    case 'minimal': {
      // Subtle radial white -> off-white.
      const style: CSSProperties = {
        ...fillLayer,
        background: `radial-gradient(circle at 50% 50%, ${rgb([1, 1, 1])} 0%, ${rgb([0.96, 0.96, 0.97])} 70%)`,
      };
      return <div style={style} />;
    }

    case 'halloween': {
      // Dark vignette: center -> slightly darker edges.
      const style: CSSProperties = {
        ...fillLayer,
        background: `radial-gradient(circle at 50% 50%, ${bg} 0%, ${rgbaFromTheme(theme.cardBackgroundColor, 0.85)} 80%)`,
      };
      return <div style={style} />;
    }

    case 'christmas': {
      // Warm ivory base + faint gold diamond grid.
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <Svg>
            <defs>
              <pattern id="bgChristmasDiamond" width="30" height="30" patternUnits="userSpaceOnUse">
                <path
                  d="M15 0 L30 15 L15 30 L0 15 Z"
                  fill="none"
                  stroke={rgba([0.85, 0.7, 0.2], 0.06)}
                  strokeWidth="0.5"
                />
              </pattern>
            </defs>
            <rect x="0" y="0" width={VB_W} height={VB_H} fill="url(#bgChristmasDiamond)" />
          </Svg>
        </>
      );
    }

    case 'space': {
      // Dark base + tiny white star dots (deterministic, like the Swift loop).
      const stars: ReactNode[] = [];
      for (let i = 0; i < 15; i++) {
        const x = (i * 37 + 13) % VB_W;
        const y = (i * 53 + 7) % VB_H;
        const r = i % 3 === 0 ? 1.1 : 0.7;
        stars.push(<circle key={i} cx={x} cy={y} r={r} fill={rgba([1, 1, 1], 0.15)} />);
      }
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <Svg>{stars}</Svg>
        </>
      );
    }

    case 'cherryBlossom': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${rgb([1, 0.95, 0.97])} 0%, ${bg} 100%)`,
      };
      return <div style={style} />;
    }

    case 'retroGame': {
      // Dark base + green grid lines.
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <Svg>
            <defs>
              <pattern id="bgRetroGrid" width="20" height="20" patternUnits="userSpaceOnUse">
                <path
                  d="M20 0 L0 0 L0 20"
                  fill="none"
                  stroke={rgba([0.1, 0.95, 0.4], 0.06)}
                  strokeWidth="0.5"
                />
              </pattern>
            </defs>
            <rect x="0" y="0" width={VB_W} height={VB_H} fill="url(#bgRetroGrid)" />
          </Svg>
        </>
      );
    }

    case 'autumn': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${bg} 0%, ${rgb([0.98, 0.94, 0.88])} 100%)`,
      };
      return <div style={style} />;
    }

    case 'aurora': {
      // Dark base + subtle diagonal green->purple color wash.
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <div
            style={{
              ...fillLayer,
              background: `linear-gradient(135deg, ${rgba([0.1, 0.9, 0.5], 0.04)} 0%, ${rgba([0.5, 0.2, 0.8], 0.04)} 50%, transparent 100%)`,
            }}
          />
        </>
      );
    }

    case 'circus': {
      // White base + faint radiating stripes from top-center.
      const rays: ReactNode[] = [];
      const big = Math.max(VB_W, VB_H);
      for (let i = 0; i < 12; i++) {
        if (i % 2 !== 0) continue;
        const angle = (i * Math.PI) / 6;
        const cx = VB_W / 2;
        const x1 = cx + Math.cos(angle) * big;
        const y1 = Math.sin(angle) * big;
        const x2 = cx + Math.cos(angle + Math.PI / 12) * big;
        const y2 = Math.sin(angle + Math.PI / 12) * big;
        rays.push(
          <path
            key={i}
            d={`M${cx} 0 L${x1} ${y1} L${x2} ${y2} Z`}
            fill={rgba([0.85, 0.15, 0.2], 0.03)}
          />,
        );
      }
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <Svg>{rays}</Svg>
        </>
      );
    }

    case 'desert': {
      // Dark base + warm gold glow rising from the bottom.
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <div
            style={{
              ...fillLayer,
              background: `linear-gradient(0deg, ${rgba([0.9, 0.75, 0.35], 0.05)} 0%, transparent 100%)`,
            }}
          />
        </>
      );
    }

    case 'candy': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${rgb([1, 0.94, 0.96])} 0%, ${bg} 50%, ${rgb([0.94, 1, 0.98])} 100%)`,
      };
      return <div style={style} />;
    }

    case 'zenGarden': {
      // Warm sand radial.
      const style: CSSProperties = {
        ...fillLayer,
        background: `radial-gradient(circle at 50% 50%, ${rgb([0.96, 0.95, 0.91])} 0%, ${bg} 70%)`,
      };
      return <div style={style} />;
    }

    case 'forsythia': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${rgb([1, 0.96, 0.82])} 0%, ${bg} 50%, ${rgb([1, 0.94, 0.78])} 100%)`,
      };
      return <div style={style} />;
    }

    case 'ocean': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${rgb([0.92, 0.97, 1])} 0%, ${bg} 50%, ${rgb([0.9, 0.96, 1])} 100%)`,
      };
      return <div style={style} />;
    }

    case 'neonCyber': {
      // Dark base + faint pink grid.
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <Svg>
            <defs>
              <pattern id="bgNeonGrid" width="25" height="25" patternUnits="userSpaceOnUse">
                <path
                  d="M25 0 L0 0 L0 25"
                  fill="none"
                  stroke={rgba([0.95, 0.2, 0.6], 0.04)}
                  strokeWidth="0.5"
                />
              </pattern>
            </defs>
            <rect x="0" y="0" width={VB_W} height={VB_H} fill="url(#bgNeonGrid)" />
          </Svg>
        </>
      );
    }

    case 'korean': {
      // Hanji texture feel — warm radial.
      const style: CSSProperties = {
        ...fillLayer,
        background: `radial-gradient(circle at 50% 50%, ${rgb([0.98, 0.96, 0.9])} 0%, ${bg} 70%)`,
      };
      return <div style={style} />;
    }

    case 'rainyDay': {
      // Dark base + cool blue diagonal wash (both corners).
      return (
        <>
          <div style={{ ...fillLayer, background: bg }} />
          <div
            style={{
              ...fillLayer,
              background: `linear-gradient(135deg, ${rgba([0.3, 0.45, 0.65], 0.04)} 0%, transparent 50%, ${rgba([0.3, 0.45, 0.65], 0.03)} 100%)`,
            }}
          />
        </>
      );
    }

    case 'lavender': {
      const style: CSSProperties = {
        ...fillLayer,
        background: `linear-gradient(135deg, ${rgb([0.96, 0.94, 1])} 0%, ${bg} 50%, ${rgb([0.95, 0.92, 0.99])} 100%)`,
      };
      return <div style={style} />;
    }

    default:
      return <div style={{ ...fillLayer, background: bg }} />;
  }
}

// Apply an opacity to a theme color that may already carry alpha.
function rgbaFromTheme(c: Theme['cardBackgroundColor'], alpha: number): string {
  return rgba([c[0], c[1], c[2]], alpha);
}

// ---------------------------------------------------------------------------
// CardDecorationOverlay — per-theme ornaments / frame accents over the card.
// ---------------------------------------------------------------------------

export function CardDecorationOverlay({ theme }: { theme: Theme }) {
  switch (theme.key) {
    case 'minimal':
      return <MinimalFrame />;
    case 'halloween':
      return <HalloweenFrame />;
    case 'christmas':
      return <ChristmasFrame />;
    case 'space':
      return <SpaceFrame />;
    case 'cherryBlossom':
      return <CherryBlossomFrame />;
    case 'retroGame':
      return <RetroFrame />;
    case 'autumn':
      return <AutumnFrame />;
    case 'aurora':
      return <AuroraFrame />;
    case 'circus':
      return <CircusFrame />;
    case 'desert':
      return <DesertFrame />;
    case 'candy':
      return <CandyFrame />;
    case 'zenGarden':
      return <ZenGardenFrame />;
    case 'forsythia':
      return <ForsythiaFrame />;
    case 'ocean':
      return <OceanFrame />;
    case 'neonCyber':
      return <NeonCyberFrame />;
    case 'korean':
      return <KoreanFrame />;
    case 'rainyDay':
      return <RainyDayFrame />;
    case 'lavender':
      return <LavenderFrame />;
    default:
      return null;
  }
}

// Helpers ----------------------------------------------------------------

/** Corner L-bracket path. (x,y) is the corner; dx/dy point inward (±1). */
function bracketPath(x: number, y: number, dx: number, dy: number, len: number): string {
  return `M${x + dx * len} ${y} L${x} ${y} L${x} ${y + dy * len}`;
}

function roundedRect(x: number, y: number, w: number, h: number, r: number): string {
  const rr = Math.min(r, w / 2, h / 2);
  return [
    `M${x + rr} ${y}`,
    `H${x + w - rr}`,
    `A${rr} ${rr} 0 0 1 ${x + w} ${y + rr}`,
    `V${y + h - rr}`,
    `A${rr} ${rr} 0 0 1 ${x + w - rr} ${y + h}`,
    `H${x + rr}`,
    `A${rr} ${rr} 0 0 1 ${x} ${y + h - rr}`,
    `V${y + rr}`,
    `A${rr} ${rr} 0 0 1 ${x + rr} ${y}`,
    'Z',
  ].join(' ');
}

// Minimal -----------------------------------------------------------------

function MinimalFrame() {
  const gray: RGB = [0.78, 0.78, 0.82];
  const inset = 14;
  const len = 20;
  const cx = VB_W / 2;
  const corners: Array<[number, number, number, number]> = [
    [inset, inset, 1, 1],
    [VB_W - inset, inset, -1, 1],
    [VB_W - inset, VB_H - inset, -1, -1],
    [inset, VB_H - inset, 1, -1],
  ];
  const dots: ReactNode[] = [];
  for (let i = -2; i <= 2; i++) {
    const ds = i === 0 ? 4 : 2.5;
    const op = i === 0 ? 0.4 : 0.25;
    dots.push(
      <circle key={i} cx={cx + i * 10} cy={inset + 6} r={ds / 2} fill={rgba(gray, op)} />,
    );
  }
  return (
    <Svg>
      {corners.map(([x, y, dx, dy], i) => (
        <path
          key={i}
          d={bracketPath(x, y, dx, dy, len)}
          fill="none"
          stroke={rgba(gray, 0.5)}
          strokeWidth={1.2}
        />
      ))}
      {dots}
      <line
        x1={cx - 30}
        y1={VB_H - inset - 8}
        x2={cx + 30}
        y2={VB_H - inset - 8}
        stroke={rgba(gray, 0.25)}
        strokeWidth={0.8}
      />
    </Svg>
  );
}

// Halloween (Yu-Gi-Oh) ----------------------------------------------------

function HalloweenFrame() {
  const orange: RGB = [0.85, 0.55, 0.1];
  const pureOrange: RGB = [1, 0.5, 0];
  const inset = 10;
  const inner = 18;
  const artTop = inner + 50;
  const artBottom = VB_H - inner - 50;
  return (
    <Svg>
      <path
        d={roundedRect(inset, inset, VB_W - inset * 2, VB_H - inset * 2, 12)}
        fill="none"
        stroke={rgba(orange, 0.5)}
        strokeWidth={2}
      />
      <path
        d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 8)}
        fill="none"
        stroke={rgba(orange, 0.25)}
        strokeWidth={1}
      />
      <line x1={inner + 8} y1={artTop} x2={VB_W - inner - 8} y2={artTop} stroke={rgba(pureOrange, 0.15)} strokeWidth={0.5} />
      <line x1={inner + 8} y1={artBottom} x2={VB_W - inner - 8} y2={artBottom} stroke={rgba(pureOrange, 0.15)} strokeWidth={0.5} />
    </Svg>
  );
}

// Christmas (Victorian) ---------------------------------------------------

function ChristmasFrame() {
  const gold: RGB = [0.8, 0.65, 0.2];
  const red: RGB = [0.85, 0.15, 0.15];
  const green: RGB = [0.15, 0.5, 0.2];
  const outer = 12;
  const inner = 22;
  const corners: Array<[number, number, boolean, boolean]> = [
    [outer + 3, outer + 3, false, false],
    [VB_W - outer - 3, outer + 3, true, false],
    [VB_W - outer - 3, VB_H - outer - 3, true, true],
    [outer + 3, VB_H - outer - 3, false, true],
  ];
  const snowCX = VB_W / 2;
  const snowCY = outer + 16;
  const mainArms: ReactNode[] = [];
  for (let arm = 0; arm < 6; arm++) {
    const a = (arm * Math.PI) / 3;
    mainArms.push(
      <line
        key={`a${arm}`}
        x1={snowCX}
        y1={snowCY}
        x2={snowCX + Math.cos(a) * 8}
        y2={snowCY + Math.sin(a) * 8}
        stroke={rgba(gold, 0.4)}
        strokeWidth={0.8}
      />,
    );
    const midX = snowCX + Math.cos(a) * 5;
    const midY = snowCY + Math.sin(a) * 5;
    for (const sign of [-1, 1]) {
      const ba = a + (sign * Math.PI) / 4;
      mainArms.push(
        <line
          key={`b${arm}${sign}`}
          x1={midX}
          y1={midY}
          x2={midX + Math.cos(ba) * 3}
          y2={midY + Math.sin(ba) * 3}
          stroke={rgba(gold, 0.3)}
          strokeWidth={0.6}
        />,
      );
    }
  }
  const miniSnow: Array<[number, number, number]> = [
    [outer + 20, VB_H * 0.3, 4],
    [VB_W - outer - 20, VB_H * 0.25, 3.5],
    [outer + 18, VB_H * 0.7, 3],
    [VB_W - outer - 18, VB_H * 0.75, 4],
  ];
  const miniArms: ReactNode[] = [];
  miniSnow.forEach(([sx, sy, sr], idx) => {
    for (let arm = 0; arm < 6; arm++) {
      const a = (arm * Math.PI) / 3;
      miniArms.push(
        <line
          key={`m${idx}-${arm}`}
          x1={sx}
          y1={sy}
          x2={sx + Math.cos(a) * sr}
          y2={sy + Math.sin(a) * sr}
          stroke={rgba(gold, 0.2)}
          strokeWidth={0.5}
        />,
      );
    }
  });
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 10)} fill="none" stroke={rgba(gold, 0.5)} strokeWidth={2} />
      <path d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 6)} fill="none" stroke={rgba(gold, 0.3)} strokeWidth={1} />
      {corners.map(([x, y, flipX, flipY], i) => {
        const dx = flipX ? -1 : 1;
        const dy = flipY ? -1 : 1;
        const fl = 25;
        const leafX = x + dx * 8;
        const leafY = y + dy * 8;
        return (
          <g key={i}>
            <path d={bracketPath(x, y, dx, dy, fl)} fill="none" stroke={rgba(gold, 0.6)} strokeWidth={2} />
            <ellipse cx={leafX} cy={leafY} rx={5} ry={2.5} fill={rgba(green, 0.25)} />
            <ellipse cx={leafX} cy={leafY} rx={2.5} ry={5} fill={rgba(green, 0.25)} />
            <circle cx={leafX} cy={leafY} r={2} fill={rgba(red, 0.5)} />
          </g>
        );
      })}
      {mainArms}
      {miniArms}
    </Svg>
  );
}

// Space (MTG) -------------------------------------------------------------

function SpaceFrame() {
  const purple: RGB = [0.45, 0.25, 0.85];
  const starBlue: RGB = [0.6, 0.7, 1];
  const outer = 8;
  const bw = 6;
  const constellations: Array<[number, number]> = [
    [20, 20],
    [VB_W - 20, 20],
    [15, VB_H * 0.3],
    [VB_W - 15, VB_H * 0.3],
    [18, VB_H * 0.5],
    [VB_W - 18, VB_H * 0.5],
    [20, VB_H * 0.7],
    [VB_W - 20, VB_H * 0.7],
    [22, VB_H - 22],
    [VB_W - 22, VB_H - 22],
    [VB_W * 0.5, 16],
    [VB_W * 0.5, VB_H - 16],
  ];
  const leftLine = `M20 20 L15 ${VB_H * 0.3} L18 ${VB_H * 0.5} L20 ${VB_H * 0.7} L22 ${VB_H - 22}`;
  const rightLine = `M${VB_W - 20} 20 L${VB_W - 15} ${VB_H * 0.3} L${VB_W - 18} ${VB_H * 0.5} L${VB_W - 20} ${VB_H * 0.7} L${VB_W - 22} ${VB_H - 22}`;
  const nebulaR = 30;
  const nebCorners: Array<[number, number]> = [
    [outer, outer],
    [VB_W - outer, outer],
    [outer, VB_H - outer],
    [VB_W - outer, VB_H - outer],
  ];
  return (
    <Svg>
      <path
        d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 8)}
        fill="none"
        stroke={rgba(purple, 0.2)}
        strokeWidth={bw}
      />
      <rect x={outer + bw + 4} y={outer + bw + 30} width={VB_W - (outer + bw + 4) * 2} height={4} fill={rgba(purple, 0.1)} />
      <rect x={outer + bw + 4} y={VB_H * 0.68} width={VB_W - (outer + bw + 4) * 2} height={4} fill={rgba(purple, 0.1)} />
      {nebCorners.map(([cx, cy], i) => (
        <circle key={`n${i}`} cx={cx} cy={cy} r={nebulaR} fill={rgba(purple, 0.03)} />
      ))}
      <path d={leftLine} fill="none" stroke={rgba(purple, 0.08)} strokeWidth={0.5} />
      <path d={rightLine} fill="none" stroke={rgba(purple, 0.08)} strokeWidth={0.5} />
      {constellations.map(([x, y], i) => (
        <g key={`s${i}`}>
          <circle cx={x} cy={y} r={4} fill={rgba(starBlue, 0.06)} />
          <circle cx={x} cy={y} r={1.5} fill={rgba(purple, 0.45)} />
        </g>
      ))}
    </Svg>
  );
}

// Cherry Blossom (Hanafuda) ----------------------------------------------

function CherryBlossomFrame() {
  const pink: RGB = [0.9, 0.5, 0.6];
  const branch: RGB = [0.45, 0.3, 0.25];
  const gold: RGB = [0.95, 0.75, 0.2];
  const inset = 14;
  const blossoms: Array<[number, number, number]> = [
    [VB_W * 0.12, VB_H * 0.13, 10],
    [VB_W * 0.22, VB_H * 0.09, 12],
    [VB_W * 0.35, VB_H * 0.07, 11],
    [VB_W * 0.15, VB_H * 0.05, 8],
  ];
  const falling: Array<[number, number, number]> = [
    [VB_W * 0.75, VB_H * 0.25, 15],
    [VB_W * 0.85, VB_H * 0.45, -25],
    [VB_W * 0.3, VB_H * 0.8, 40],
  ];
  return (
    <Svg>
      <path
        d={roundedRect(inset, inset, VB_W - inset * 2, VB_H - inset * 2, 20)}
        fill="none"
        stroke={rgba(pink, 0.2)}
        strokeWidth={1}
      />
      <path
        d={`M0 ${VB_H * 0.15} C${VB_W * 0.1} ${VB_H * 0.12}, ${VB_W * 0.25} ${VB_H * 0.05}, ${VB_W * 0.4} ${VB_H * 0.08}`}
        fill="none"
        stroke={rgba(branch, 0.15)}
        strokeWidth={1.5}
      />
      <path
        d={`M${VB_W * 0.2} ${VB_H * 0.11} Q${VB_W * 0.12} ${VB_H * 0.06}, ${VB_W * 0.15} ${VB_H * 0.04}`}
        fill="none"
        stroke={rgba(branch, 0.12)}
        strokeWidth={1}
      />
      {blossoms.map(([x, y, r], bi) => (
        <g key={`bl${bi}`}>
          {Array.from({ length: 5 }, (_, p) => {
            const a = (p * Math.PI * 2) / 5 - Math.PI / 2;
            const px = x + Math.cos(a) * r * 0.6;
            const py = y + Math.sin(a) * r * 0.6;
            return <ellipse key={p} cx={px} cy={py} rx={r * 0.4} ry={r * 0.25} fill={rgba(pink, 0.12)} />;
          })}
          <circle cx={x} cy={y} r={2} fill={rgba(gold, 0.2)} />
        </g>
      ))}
      <path
        d={`M${VB_W} ${VB_H * 0.88} C${VB_W * 0.9} ${VB_H * 0.9}, ${VB_W * 0.75} ${VB_H * 0.95}, ${VB_W * 0.65} ${VB_H * 0.92}`}
        fill="none"
        stroke={rgba(branch, 0.12)}
        strokeWidth={1.5}
      />
      {falling.map(([x, y, rot], fi) => (
        <path
          key={`fp${fi}`}
          d="M0 -5 Q5 0 0 5 Q-3 0 0 -5 Z"
          transform={`translate(${x} ${y}) rotate(${rot})`}
          fill={rgba(pink, 0.1)}
        />
      ))}
    </Svg>
  );
}

// Retro (Arcade) ----------------------------------------------------------

function RetroFrame() {
  const green: RGB = [0.1, 0.95, 0.4];
  const outer = 8;
  const inner = 14;
  const len = 15;
  const corners: Array<[number, number, number, number]> = [
    [outer + 2, outer + 2, 1, 1],
    [VB_W - outer - 2, outer + 2, -1, 1],
    [VB_W - outer - 2, VB_H - outer - 2, -1, -1],
    [outer + 2, VB_H - outer - 2, 1, -1],
  ];
  const scanlines: ReactNode[] = [];
  for (let y = 0; y < VB_H; y += 3) {
    scanlines.push(<rect key={y} x={0} y={y} width={VB_W} height={1} fill={rgba(green, 0.015)} />);
  }
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 2)} fill="none" stroke={rgba(green, 0.6)} strokeWidth={2} />
      <path d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 1)} fill="none" stroke={rgba(green, 0.2)} strokeWidth={1} />
      {scanlines}
      {corners.map(([x, y, dx, dy], i) => (
        <path key={i} d={bracketPath(x, y, dx, dy, len)} fill="none" stroke={rgba(green, 0.5)} strokeWidth={2} />
      ))}
      <rect x={VB_W * 0.3} y={VB_H - 12} width={VB_W * 0.4} height={1} fill={rgba(green, 0.1)} />
    </Svg>
  );
}

// Autumn (Tarot) ----------------------------------------------------------

function AutumnFrame() {
  const brown: RGB = [0.65, 0.45, 0.2];
  const outer = 10;
  const inner = 18;
  const mid = (outer + inner) / 2;
  const topDiamonds: ReactNode[] = [];
  const botDiamonds: ReactNode[] = [];
  for (let i = mid + 15; i < VB_W - mid - 15; i += 20) {
    topDiamonds.push(
      <path
        key={`td${i}`}
        d={`M${i} ${outer + 1} L${i + 4} ${mid} L${i} ${inner - 1} L${i - 4} ${mid} Z`}
        fill={rgba(brown, 0.15)}
      />,
    );
    botDiamonds.push(
      <path
        key={`bd${i}`}
        d={`M${i} ${VB_H - inner + 1} L${i + 4} ${VB_H - mid} L${i} ${VB_H - outer - 1} L${i - 4} ${VB_H - mid} Z`}
        fill={rgba(brown, 0.15)}
      />,
    );
  }
  const moonY = inner + 8;
  const phases: Array<[number, number]> = [
    [VB_W / 2 - 24, 4],
    [VB_W / 2 - 12, 5],
    [VB_W / 2, 6],
    [VB_W / 2 + 12, 5],
    [VB_W / 2 + 24, 4],
  ];
  const cornerSym: Array<[number, number]> = [
    [inner + 8, inner + 8],
    [VB_W - inner - 8, inner + 8],
    [inner + 8, VB_H - inner - 8],
    [VB_W - inner - 8, VB_H - inner - 8],
  ];
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 14)} fill="none" stroke={rgba(brown, 0.4)} strokeWidth={2} />
      <path d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 10)} fill="none" stroke={rgba(brown, 0.2)} strokeWidth={1} />
      {topDiamonds}
      {botDiamonds}
      {phases.map(([x, r], i) =>
        r === 6 ? (
          <circle key={`p${i}`} cx={x} cy={moonY} r={r} fill={rgba(brown, 0.25)} />
        ) : (
          <circle key={`p${i}`} cx={x} cy={moonY} r={r} fill="none" stroke={rgba(brown, 0.2)} strokeWidth={0.8} />
        ),
      )}
      {cornerSym.map(([x, y], i) => (
        <g key={`c${i}`}>
          {Array.from({ length: 8 }, (_, ray) => {
            const a = (ray * Math.PI) / 4;
            return (
              <line
                key={ray}
                x1={x}
                y1={y}
                x2={x + Math.cos(a) * 6}
                y2={y + Math.sin(a) * 6}
                stroke={rgba(brown, 0.2)}
                strokeWidth={0.8}
              />
            );
          })}
          <circle cx={x} cy={y} r={2} fill={rgba(brown, 0.3)} />
        </g>
      ))}
    </Svg>
  );
}

// Aurora (Holographic) ----------------------------------------------------

function AuroraFrame() {
  // Prismatic edge glow via conic-gradient masked to a border, plus a faint
  // holographic diamond grid. Approximates the SwiftUI AngularGradient stroke.
  const ring = (lineWidth: number, blur: number, colors: string): CSSProperties => ({
    ...fillLayer,
    borderRadius: 24,
    background: `conic-gradient(from 0deg, ${colors})`,
    WebkitMask: `linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0)`,
    WebkitMaskComposite: 'xor',
    maskComposite: 'exclude',
    padding: lineWidth,
    filter: `blur(${blur}px)`,
  });
  const inset = 16;
  const diamonds: ReactNode[] = [];
  for (let row = 0; row < VB_H / 30; row++) {
    for (let col = 0; col < VB_W / 30; col++) {
      const x = col * 30 + (row % 2 === 0 ? 0 : 15);
      const y = row * 30;
      const hue = ((x + y) / (VB_W + VB_H)) * 360;
      diamonds.push(
        <path
          key={`${row}-${col}`}
          d={`M${x} ${y - 3} L${x + 3} ${y} L${x} ${y + 3} L${x - 3} ${y} Z`}
          fill={`hsla(${hue}, 50%, 100%, 0.04)`}
        />,
      );
    }
  }
  return (
    <>
      <div
        style={ring(
          5,
          8,
          `${rgba([0.1, 0.9, 0.5], 0.15)}, ${rgba([0.7, 0.2, 0.8], 0.12)}, ${rgba([0.1, 0.9, 0.5], 0.15)}`,
        )}
      />
      <div
        style={ring(
          2.5,
          1,
          `${rgba([0.1, 0.9, 0.5], 0.4)}, ${rgba([0.2, 0.6, 0.9], 0.3)}, ${rgba([0.7, 0.2, 0.8], 0.4)}, ${rgba([0.9, 0.4, 0.2], 0.3)}, ${rgba([0.1, 0.9, 0.5], 0.4)}`,
        )}
      />
      <Svg>
        <path
          d={roundedRect(inset, inset, VB_W - inset * 2, VB_H - inset * 2, 18)}
          fill="none"
          stroke={rgba([1, 1, 1], 0.08)}
          strokeWidth={0.5}
        />
        {diamonds}
      </Svg>
    </>
  );
}

// Circus (Playing Card) ---------------------------------------------------

function CircusFrame() {
  const red: RGB = [0.85, 0.15, 0.2];
  const gold: RGB = [0.85, 0.7, 0.15];
  const outer = 10;
  const inner = 18;
  const centerY = VB_H / 2;
  const cornerPos: Array<[number, number]> = [
    [outer + 6, outer + 6],
    [VB_W - outer - 6, outer + 6],
    [outer + 6, VB_H - outer - 6],
    [VB_W - outer - 6, VB_H - outer - 6],
  ];
  const rays: ReactNode[] = [];
  for (let i = 0; i < 8; i++) {
    if (i % 2 !== 0) continue;
    const angle = (i * Math.PI) / 8 + Math.PI / 16;
    const endX = VB_W / 2 + Math.cos(angle - Math.PI / 2) * 60;
    const endY = Math.sin(angle - Math.PI / 2) * 60;
    rays.push(
      <line key={i} x1={VB_W / 2} y1={0} x2={endX} y2={-endY} stroke={rgba(red, 0.04)} strokeWidth={12} />,
    );
  }
  return (
    <Svg>
      {rays}
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 14)} fill="none" stroke={rgba(red, 0.5)} strokeWidth={2.5} />
      <path d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 10)} fill="none" stroke={rgba(red, 0.2)} strokeWidth={1} />
      {cornerPos.map(([x, y], i) => (
        <circle key={i} cx={x} cy={y} r={6} fill={rgba(gold, 0.15)} />
      ))}
      <line x1={inner + 10} y1={centerY} x2={VB_W / 2 - 15} y2={centerY} stroke={rgba(red, 0.1)} strokeWidth={0.5} />
      <line x1={VB_W / 2 + 15} y1={centerY} x2={VB_W - inner - 10} y2={centerY} stroke={rgba(red, 0.1)} strokeWidth={0.5} />
      <path
        d={`M${VB_W / 2} ${centerY - 8} L${VB_W / 2 + 8} ${centerY} L${VB_W / 2} ${centerY + 8} L${VB_W / 2 - 8} ${centerY} Z`}
        fill="none"
        stroke={rgba(red, 0.2)}
        strokeWidth={1}
      />
    </Svg>
  );
}

// Desert (Egyptian) -------------------------------------------------------

function DesertFrame() {
  const gold: RGB = [0.9, 0.75, 0.35];
  const outer = 10;
  const inner = 20;
  const x = (outer + inner) / 2;
  const rx = VB_W - (outer + inner) / 2;
  const spacing = 22;
  const symbols: ReactNode[] = [];
  for (let y = inner + 20; y < VB_H - inner - 20; y += spacing) {
    const shapeIdx = Math.floor(y / spacing) % 3;
    for (const cx of [x, rx]) {
      if (shapeIdx === 0) {
        symbols.push(
          <path
            key={`${y}-${cx}`}
            d={`M${cx} ${y - 4} L${cx + 4} ${y + 4} L${cx - 4} ${y + 4} Z`}
            fill="none"
            stroke={rgba(gold, 0.25)}
            strokeWidth={0.8}
          />,
        );
      } else if (shapeIdx === 1) {
        symbols.push(<circle key={`${y}-${cx}`} cx={cx} cy={y} r={3} fill="none" stroke={rgba(gold, 0.25)} strokeWidth={0.8} />);
      } else {
        symbols.push(
          <g key={`${y}-${cx}`} fill="none" stroke={rgba(gold, 0.25)} strokeWidth={0.8}>
            <ellipse cx={cx} cy={y - 2.5} rx={3} ry={2.5} />
            <line x1={cx} y1={y} x2={cx} y2={y + 5} />
            <line x1={cx - 3} y1={y + 2} x2={cx + 3} y2={y + 2} />
          </g>,
        );
      }
    }
  }
  const tcx = VB_W / 2;
  const tcy = inner + 6;
  const bcx = VB_W / 2;
  const bcy = VB_H - inner - 6;
  const legs: ReactNode[] = [];
  for (const side of [-1, 1]) {
    for (let leg = 0; leg < 3; leg++) {
      const lx = bcx + side * 6;
      const ly = bcy - 2 + leg * 3;
      legs.push(
        <line key={`${side}-${leg}`} x1={lx} y1={ly} x2={lx + side * 8} y2={ly - 2} stroke={rgba(gold, 0.15)} strokeWidth={0.5} />,
      );
    }
  }
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 10)} fill="none" stroke={rgba(gold, 0.4)} strokeWidth={2} />
      <path d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 6)} fill="none" stroke={rgba(gold, 0.2)} strokeWidth={1} />
      {symbols}
      <circle cx={tcx} cy={tcy} r={5} fill={rgba(gold, 0.3)} />
      <path d={`M${tcx - 5} ${tcy} Q${tcx - 20} ${tcy - 8}, ${tcx - 35} ${tcy + 2}`} fill="none" stroke={rgba(gold, 0.25)} strokeWidth={1.5} />
      <path d={`M${tcx + 5} ${tcy} Q${tcx + 20} ${tcy - 8}, ${tcx + 35} ${tcy + 2}`} fill="none" stroke={rgba(gold, 0.25)} strokeWidth={1.5} />
      <ellipse cx={bcx} cy={bcy} rx={6} ry={4} fill={rgba(gold, 0.15)} />
      {legs}
    </Svg>
  );
}

// Candy -------------------------------------------------------------------

function CandyFrame() {
  const pink: RGB = [0.95, 0.35, 0.55];
  const mint: RGB = [0.55, 0.85, 0.75];
  const yellow: RGB = [0.98, 0.8, 0.25];
  const outer = 10;
  const inner = 18;
  const corners: Array<[number, number]> = [
    [outer + 6, outer + 6],
    [VB_W - outer - 6, outer + 6],
    [outer + 6, VB_H - outer - 6],
    [VB_W - outer - 6, VB_H - outer - 6],
  ];
  const cornerColors: RGB[] = [pink, mint, yellow, pink];
  const sprinkles: Array<[number, number, number, RGB]> = [
    [VB_W * 0.3, outer + 4, 30, mint],
    [VB_W * 0.6, outer + 5, -20, yellow],
    [VB_W * 0.8, outer + 3, 45, pink],
    [outer + 4, VB_H * 0.4, 70, yellow],
    [outer + 5, VB_H * 0.7, -15, mint],
    [VB_W - outer - 4, VB_H * 0.35, -60, pink],
    [VB_W - outer - 5, VB_H * 0.65, 25, yellow],
    [VB_W * 0.25, VB_H - outer - 4, -35, pink],
    [VB_W * 0.55, VB_H - outer - 5, 50, mint],
    [VB_W * 0.75, VB_H - outer - 3, -10, yellow],
  ];
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 24)} fill="none" stroke={rgba(pink, 0.35)} strokeWidth={3} />
      <path
        d={roundedRect(inner, inner, VB_W - inner * 2, VB_H - inner * 2, 20)}
        fill="none"
        stroke={rgba(mint, 0.3)}
        strokeWidth={1.5}
        strokeDasharray="4 4"
      />
      {corners.map(([x, y], i) => (
        <g key={i}>
          <circle cx={x} cy={y} r={5} fill={rgba(cornerColors[i], 0.3)} />
          <circle cx={x} cy={y} r={2.5} fill={rgba(cornerColors[i], 0.2)} />
        </g>
      ))}
      {sprinkles.map(([x, y, rot, color], i) => (
        <rect
          key={`sp${i}`}
          x={-4}
          y={-1}
          width={8}
          height={2}
          rx={1}
          ry={1}
          fill={rgba(color, 0.3)}
          transform={`translate(${x} ${y}) rotate(${rot})`}
        />
      ))}
    </Svg>
  );
}

// Forsythia ---------------------------------------------------------------

function ForsythiaFrame() {
  const yellow: RGB = [0.98, 0.85, 0.08];
  const darkYellow: RGB = [0.85, 0.65, 0.08];
  const brown: RGB = [0.55, 0.42, 0.2];
  const green: RGB = [0.45, 0.6, 0.25];
  const outer = 12;
  const topFlowers: Array<[number, number, number]> = [
    [VB_W * 0.1, VB_H * 0.1, 9],
    [VB_W * 0.22, VB_H * 0.065, 11],
    [VB_W * 0.38, VB_H * 0.05, 10],
    [VB_W * 0.18, VB_H * 0.03, 7],
  ];
  const leafPos: Array<[number, number]> = [
    [VB_W * 0.15, VB_H * 0.09],
    [VB_W * 0.32, VB_H * 0.055],
    [VB_W * 0.45, VB_H * 0.06],
  ];
  const botFlowers: Array<[number, number, number]> = [
    [VB_W * 0.88, VB_H * 0.9, 8],
    [VB_W * 0.72, VB_H * 0.94, 10],
    [VB_W * 0.6, VB_H * 0.94, 7],
  ];
  const falling: Array<[number, number, number]> = [
    [VB_W * 0.8, VB_H * 0.35, 20],
    [VB_W * 0.25, VB_H * 0.7, -30],
    [VB_W * 0.65, VB_H * 0.5, 45],
    [VB_W * 0.45, VB_H * 0.4, -15],
  ];
  const flower = (x: number, y: number, r: number, op: number, withCenter: boolean, key: string) => (
    <g key={key}>
      {Array.from({ length: 4 }, (_, p) => {
        const a = (p * Math.PI) / 2 + Math.PI / 4;
        const px = x + Math.cos(a) * r * 0.5;
        const py = y + Math.sin(a) * r * 0.5;
        return <ellipse key={p} cx={px} cy={py} rx={r * 0.35} ry={r * 0.2} fill={rgba(yellow, op)} />;
      })}
      {withCenter && <circle cx={x} cy={y} r={1.5} fill={rgba(darkYellow, 0.25)} />}
    </g>
  );
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 18)} fill="none" stroke={rgba(yellow, 0.35)} strokeWidth={1.5} />
      <path
        d={`M0 ${VB_H * 0.12} C${VB_W * 0.12} ${VB_H * 0.08}, ${VB_W * 0.3} ${VB_H * 0.03}, ${VB_W * 0.5} ${VB_H * 0.06}`}
        fill="none"
        stroke={rgba(brown, 0.2)}
        strokeWidth={1.5}
      />
      <path
        d={`M${VB_W * 0.25} ${VB_H * 0.07} Q${VB_W * 0.18} ${VB_H * 0.04}, ${VB_W * 0.2} ${VB_H * 0.02}`}
        fill="none"
        stroke={rgba(brown, 0.16)}
        strokeWidth={1}
      />
      {topFlowers.map(([x, y, r], i) => flower(x, y, r, 0.22, true, `tf${i}`))}
      {leafPos.map(([x, y], i) => (
        <path
          key={`lf${i}`}
          d={`M${x} ${y} Q${x + 4} ${y - 5}, ${x + 6} ${y - 4}`}
          fill="none"
          stroke={rgba(green, 0.18)}
          strokeWidth={1}
        />
      ))}
      <path
        d={`M${VB_W} ${VB_H * 0.88} C${VB_W * 0.88} ${VB_H * 0.92}, ${VB_W * 0.7} ${VB_H * 0.96}, ${VB_W * 0.55} ${VB_H * 0.94}`}
        fill="none"
        stroke={rgba(brown, 0.16)}
        strokeWidth={1.5}
      />
      {botFlowers.map(([x, y, r], i) => flower(x, y, r, 0.18, false, `bf${i}`))}
      {falling.map(([x, y, rot], i) => (
        <ellipse key={`fp${i}`} cx={0} cy={0} rx={3} ry={2} fill={rgba(yellow, 0.14)} transform={`translate(${x} ${y}) rotate(${rot})`} />
      ))}
    </Svg>
  );
}

// Zen Garden --------------------------------------------------------------

function ZenGardenFrame() {
  const stone: RGB = [0.4, 0.42, 0.38];
  const bambooGreen: RGB = [0.45, 0.55, 0.35];
  const outer = 12;
  const wave = (baseY: number, keyPrefix: string) => {
    const rows: ReactNode[] = [];
    const segments = 8;
    const segWidth = (VB_W - outer * 2 - 40) / segments;
    for (let row = 0; row < 3; row++) {
      const y = baseY + row * 8;
      let d = `M${outer + 20} ${y}`;
      for (let s = 0; s < segments; s++) {
        const sx = outer + 20 + s * segWidth;
        const cy = y + (s % 2 === 0 ? -3 : 3);
        d += ` Q${sx + segWidth * 0.5} ${cy}, ${sx + segWidth} ${y}`;
      }
      rows.push(
        <path key={`${keyPrefix}${row}`} d={d} fill="none" stroke={rgba(stone, 0.08 + row * 0.02)} strokeWidth={0.6} />,
      );
    }
    return rows;
  };
  const stones: Array<[number, number, number]> = [
    [outer + 14, outer + 14, 6],
    [VB_W - outer - 14, VB_H - outer - 14, 8],
    [VB_W - outer - 16, outer + 16, 5],
  ];
  const nodes: ReactNode[] = [];
  for (let ny = VB_H * 0.4; ny < VB_H * 0.6; ny += 20) {
    nodes.push(
      <line key={ny} x1={outer + 5} y1={ny} x2={outer + 11} y2={ny} stroke={rgba(bambooGreen, 0.15)} strokeWidth={1} />,
    );
  }
  return (
    <Svg>
      <path d={roundedRect(outer, outer, VB_W - outer * 2, VB_H - outer * 2, 16)} fill="none" stroke={rgba(stone, 0.2)} strokeWidth={1} />
      {wave(outer + 12, 'tw')}
      {wave(VB_H - outer - 30, 'bw')}
      {stones.map(([x, y, r], i) => (
        <circle key={i} cx={x} cy={y} r={r} fill={rgba(stone, 0.1)} stroke={rgba(stone, 0.15)} strokeWidth={0.5} />
      ))}
      <line x1={outer + 8} y1={VB_H * 0.35} x2={outer + 8} y2={VB_H * 0.65} stroke={rgba(bambooGreen, 0.12)} strokeWidth={1.5} />
      {nodes}
    </Svg>
  );
}

// Ocean -------------------------------------------------------------------

function OceanFrame() {
  const blue: RGB = [0.2, 0.6, 0.85];
  const inset = 12;
  const topWave = sineWave(inset + 8, 0, 3);
  const bottomWave = sineWave(VB_H - inset - 8, 1.5, 3);
  const corners: Array<[number, number]> = [
    [inset + 10, inset + 10],
    [VB_W - inset - 10, inset + 10],
    [inset + 10, VB_H - inset - 10],
    [VB_W - inset - 10, VB_H - inset - 10],
  ];
  return (
    <Svg>
      <path d={topWave} fill="none" stroke={rgba(blue, 0.15)} strokeWidth={0.8} />
      <path d={bottomWave} fill="none" stroke={rgba(blue, 0.15)} strokeWidth={0.8} />
      {corners.map(([cx, cy], i) => (
        <g key={i}>
          {[6, 4, 2.5].map((r) => (
            <circle key={r} cx={cx} cy={cy} r={r} fill="none" stroke={rgba(blue, 0.12)} strokeWidth={0.6} />
          ))}
        </g>
      ))}
    </Svg>
  );
}

function sineWave(baseY: number, phase: number, amp: number): string {
  let d = '';
  for (let x = 0; x <= VB_W; x += 3) {
    const y = baseY + Math.sin(x * 0.05 + phase) * amp;
    d += x === 0 ? `M${x} ${y}` : ` L${x} ${y}`;
  }
  return d;
}

// Neon Cyber --------------------------------------------------------------

function NeonCyberFrame() {
  const pink: RGB = [0.95, 0.2, 0.6];
  const cyan: RGB = [0, 0.95, 0.9];
  const inset = 8;
  const len = 25;
  const corners: Array<[number, number, number, number]> = [
    [inset, inset, 1, 1],
    [VB_W - inset, inset, -1, 1],
    [VB_W - inset, VB_H - inset, -1, -1],
    [inset, VB_H - inset, 1, -1],
  ];
  const scanY = VB_H * 0.3;
  const dots: ReactNode[] = [];
  for (let i = 0; i < 8; i++) {
    const dotX = inset + 30 + i * ((VB_W - inset * 2 - 60) / 7);
    const dotR = i % 3 === 0 ? 2 : 1.2;
    dots.push(<circle key={i} cx={dotX} cy={inset + 4} r={dotR} fill={rgba(pink, 0.2)} />);
  }
  return (
    <Svg>
      {corners.map(([x, y, dx, dy], i) => (
        <path
          key={i}
          d={bracketPath(x, y, dx, dy, len)}
          fill="none"
          stroke={rgba(i % 2 === 0 ? pink : cyan, 0.5)}
          strokeWidth={1.5}
        />
      ))}
      <line x1={inset + 5} y1={scanY} x2={VB_W - inset - 5} y2={scanY} stroke={rgba(cyan, 0.08)} strokeWidth={0.5} />
      {dots}
    </Svg>
  );
}

// Korean Traditional ------------------------------------------------------

function KoreanFrame() {
  const red: RGB = [0.78, 0.22, 0.28];
  const blue: RGB = [0.2, 0.35, 0.6];
  const green: RGB = [0.15, 0.45, 0.35];
  const yellow: RGB = [0.85, 0.65, 0.15];
  const inset = 12;
  const cs = 18;
  const cornerPos: Array<[number, number]> = [
    [inset, inset],
    [VB_W - inset - cs, inset],
    [inset, VB_H - inset - cs],
    [VB_W - inset - cs, VB_H - inset - cs],
  ];
  const cornerColors: RGB[] = [red, blue, green, yellow];
  const cx = VB_W / 2;
  return (
    <Svg>
      {cornerPos.map(([x, y], i) => (
        <g key={i}>
          <rect x={x} y={y} width={cs} height={cs} fill="none" stroke={rgba(cornerColors[i], 0.15)} strokeWidth={0.8} />
          <rect x={x + 3} y={y + 3} width={cs - 6} height={cs - 6} fill="none" stroke={rgba(cornerColors[i], 0.1)} strokeWidth={0.5} />
        </g>
      ))}
      <line x1={cx - 25} y1={inset + 6} x2={cx + 25} y2={inset + 6} stroke={rgba(red, 0.2)} strokeWidth={0.8} />
      <line x1={cx - 25} y1={VB_H - inset - 6} x2={cx + 25} y2={VB_H - inset - 6} stroke={rgba(blue, 0.2)} strokeWidth={0.8} />
    </Svg>
  );
}

// Rainy Day ---------------------------------------------------------------

function RainyDayFrame() {
  const gray: RGB = [0.5, 0.55, 0.65];
  const blue: RGB = [0.5, 0.65, 0.8];
  const inset = 14;
  const len = 15;
  const drops: ReactNode[] = [];
  for (let i = 0; i < 6; i++) {
    const x = 15 + i * 12;
    const startY = 10;
    const endY = startY + (8 + (i % 3) * 5);
    drops.push(<line key={i} x1={x} y1={startY} x2={x} y2={endY} stroke={rgba(blue, 0.08)} strokeWidth={0.8} />);
  }
  const mist: ReactNode[] = [];
  for (let i = 0; i < 3; i++) {
    const y = VB_H - 12 - i * 5;
    mist.push(<line key={i} x1={20} y1={y} x2={VB_W - 20} y2={y} stroke={rgba(gray, 0.05 - i * 0.01)} strokeWidth={0.6} />);
  }
  const corners: Array<[number, number, number, number]> = [
    [inset, inset, 1, 1],
    [VB_W - inset, inset, -1, 1],
    [VB_W - inset, VB_H - inset, -1, -1],
    [inset, VB_H - inset, 1, -1],
  ];
  return (
    <Svg>
      {drops}
      {mist}
      {corners.map(([x, y, dx, dy], i) => (
        <path key={i} d={bracketPath(x, y, dx, dy, len)} fill="none" stroke={rgba(gray, 0.12)} strokeWidth={0.8} />
      ))}
    </Svg>
  );
}

// Lavender ----------------------------------------------------------------

function LavenderFrame() {
  const purple: RGB = [0.6, 0.4, 0.8];
  const inset = 14;
  const cx = VB_W / 2;
  const topDots: ReactNode[] = [];
  const botDots: ReactNode[] = [];
  for (let i = -1; i <= 1; i++) {
    const ds = i === 0 ? 4 : 3;
    const op = i === 0 ? 0.25 : 0.15;
    topDots.push(<circle key={i} cx={cx + i * 10} cy={inset + 10} r={ds / 2} fill={rgba(purple, op)} />);
    botDots.push(<circle key={i} cx={cx + i * 10} cy={VB_H - inset - 10} r={ds / 2} fill={rgba(purple, op)} />);
  }
  const sideDots: ReactNode[] = [];
  for (let side = 0; side < 2; side++) {
    const x = side === 0 ? inset + 8 : VB_W - inset - 8;
    for (let j = 0; j < 4; j++) {
      const y = VB_H * (0.3 + j * 0.12);
      sideDots.push(<circle key={`${side}-${j}`} cx={x} cy={y} r={1.5} fill={rgba(purple, 0.1)} />);
    }
  }
  return (
    <Svg>
      <path
        d={roundedRect(inset + 6, inset + 6, VB_W - (inset + 6) * 2, VB_H - (inset + 6) * 2, 18)}
        fill="none"
        stroke={rgba(purple, 0.08)}
        strokeWidth={0.6}
      />
      {topDots}
      {botDots}
      {sideDots}
    </Svg>
  );
}
