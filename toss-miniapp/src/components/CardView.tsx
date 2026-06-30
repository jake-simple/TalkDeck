import { type CSSProperties, type ReactNode } from 'react';
import type { Card } from '../data/cards';
import type { Theme } from '../theme/types';
import { FONT_FAMILY } from '../theme/types';
import { rgb, rgba } from '../lib/colors';
import { Icon } from '../lib/icon';
import { FitText } from './FitText';
import { ThemedCardBorder } from './CardShapes';
import { CardBackgroundPattern, CardDecorationOverlay } from './CardDecorations';

const Q_SIZE = 28;
const Q_MIN_SCALE = 0.55;

function cc(s: string): number {
  return [...s].length;
}

function ff(theme: Theme): string {
  return FONT_FAMILY[theme.fontDesign];
}

const column: CSSProperties = {
  position: 'absolute',
  inset: 0,
  display: 'flex',
  flexDirection: 'column',
  zIndex: 3,
};

function HeaderFooter({
  children,
  style,
}: {
  children: ReactNode;
  style?: CSSProperties;
}) {
  return <div style={{ flex: '0 0 auto', ...style }}>{children}</div>;
}

export function CardView({ card, theme }: { card: Card; theme: Theme }) {
  const radius = theme.cardCornerRadius;
  const shadow = rgb(theme.cardShadowColor);
  const shadowSoft = rgb([
    theme.cardShadowColor[0],
    theme.cardShadowColor[1],
    theme.cardShadowColor[2],
    theme.cardShadowColor[3] * 0.4,
  ]);

  return (
    <div
      className="no-select"
      style={{
        position: 'relative',
        width: '100%',
        height: '100%',
        aspectRatio: '1 / 1',
        maxWidth: 400,
        maxHeight: 400,
        margin: '0 auto',
        borderRadius: radius,
        background: rgb(theme.cardBackgroundColor),
        boxShadow: `0 0 12px ${shadow}, 0 0 30px ${shadowSoft}`,
      }}
    >
      {/* background pattern (clipped) */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          borderRadius: radius,
          overflow: 'hidden',
          zIndex: 1,
        }}
      >
        <CardBackgroundPattern theme={theme} />
      </div>

      {/* themed border */}
      <div style={{ position: 'absolute', inset: 0, zIndex: 2, pointerEvents: 'none' }}>
        <ThemedCardBorder theme={theme} />
      </div>

      {/* decoration overlay (clipped) */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          borderRadius: radius,
          overflow: 'hidden',
          zIndex: 2,
          pointerEvents: 'none',
        }}
      >
        <CardDecorationOverlay theme={theme} />
      </div>

      {/* content */}
      {renderContent(card, theme)}
    </div>
  );
}

function question(
  text: string,
  theme: Theme,
  opts: {
    design?: string;
    size?: number;
    lineHeight?: number;
    italic?: boolean;
    paddingX: number;
    align?: CSSProperties['textAlign'];
    prefix?: string;
  }
) {
  return (
    <FitText
      text={text}
      baseSize={opts.size ?? Q_SIZE}
      minScale={Q_MIN_SCALE}
      fontFamily={opts.design ?? ff(theme)}
      fontWeight={600}
      color={rgb(theme.cardTextColor)}
      lineHeight={opts.lineHeight ?? 1.35}
      italic={opts.italic}
      textAlign={opts.align ?? 'center'}
      paddingX={opts.paddingX}
      prefix={opts.prefix}
    />
  );
}

const GOLD = rgb([0.95, 0.75, 0.15]);

function renderContent(card: Card, theme: Theme): ReactNode {
  const q = card.question;
  const n = cc(q);

  switch (theme.key) {
    // MARK: Minimal
    case 'minimal':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: 6,
              paddingTop: 28,
            }}
          >
            <div style={{ width: 20, height: 1, background: 'rgba(128,128,128,0.2)' }} />
            <Icon name="circle.fill" size={4} color="rgba(128,128,128,0.3)" />
            <div style={{ width: 20, height: 1, background: 'rgba(128,128,128,0.2)' }} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.default, paddingX: 28, lineHeight: 1.4 })}
          <HeaderFooter
            style={{
              textAlign: 'center',
              paddingBottom: 24,
              fontSize: 9,
              fontWeight: 300,
              letterSpacing: 2,
              color: 'rgba(128,128,128,0.3)',
              fontFamily: FONT_FAMILY.default,
            }}
          >
            {`No.${n % 100}`}
          </HeaderFooter>
        </div>
      );

    // MARK: Yu-Gi-Oh (Halloween)
    case 'halloween':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'flex-end',
              gap: 3,
              padding: '16px 20px 0',
            }}
          >
            {Array.from({ length: Math.min((n % 8) + 1, 8) }).map((_, i) => (
              <Icon key={i} name="star.fill" size={7} color={GOLD} />
            ))}
          </HeaderFooter>
          <HeaderFooter style={{ padding: '8px 28px 0' }}>
            <div
              style={{
                height: 6,
                border: `1px solid ${rgba([1, 0.65, 0], 0.2)}`,
                borderRadius: 4,
              }}
            />
          </HeaderFooter>
          {question(q, theme, { paddingX: 28, lineHeight: 1.25 })}
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '0 20px 16px',
            }}
          >
            <span style={{ fontSize: 18 }}>🎃</span>
            <span
              style={{
                fontSize: 9,
                fontFamily: FONT_FAMILY.monospaced,
                color: rgba(theme.cardTextColor, 0.3),
              }}
            >
              ATK/???
            </span>
          </HeaderFooter>
        </div>
      );

    // MARK: Victorian (Christmas)
    case 'christmas':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: 6,
              paddingTop: 24,
            }}
          >
            <Icon name="leaf.fill" size={9} color={rgba([0.15, 0.5, 0.2], 0.5)} style={{ transform: 'rotate(-45deg)' }} />
            <Icon name="circle.fill" size={4} color={rgba([0.85, 0.15, 0.15], 0.5)} />
            <Icon name="snowflake" size={14} color={rgba([0.8, 0.65, 0.2], 0.6)} />
            <Icon name="circle.fill" size={4} color={rgba([0.85, 0.15, 0.15], 0.5)} />
            <Icon name="leaf.fill" size={9} color={rgba([0.15, 0.5, 0.2], 0.5)} style={{ transform: 'rotate(45deg)' }} />
          </HeaderFooter>
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '8px 30px 0' }}
          >
            <div style={{ flex: 1, height: 1, background: rgba([0.8, 0.65, 0.2], 0.3) }} />
            <Icon name="star.fill" size={6} color={rgba([0.8, 0.65, 0.2], 0.6)} />
            <div style={{ flex: 1, height: 1, background: rgba([0.8, 0.65, 0.2], 0.3) }} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, italic: true, paddingX: 32, lineHeight: 1.4 })}
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 30px 24px' }}
          >
            <div style={{ flex: 1, height: 1, background: rgba([0.8, 0.65, 0.2], 0.3) }} />
            <Icon name="gift.fill" size={7} color={rgba([0.85, 0.15, 0.15], 0.45)} />
            <Icon name="snowflake" size={6} color={rgba([0.8, 0.65, 0.2], 0.4)} />
            <Icon name="gift.fill" size={7} color={rgba([0.85, 0.15, 0.15], 0.45)} />
            <div style={{ flex: 1, height: 1, background: rgba([0.8, 0.65, 0.2], 0.3) }} />
          </HeaderFooter>
        </div>
      );

    // MARK: MTG (Space)
    case 'space':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '18px 20px 0',
            }}
          >
            <Icon name="sparkles" size={11} color={rgba([0.5, 0.3, 0.8], 0.6)} />
            <div style={{ display: 'flex', gap: 3 }}>
              {Array.from({ length: (n % 4) + 1 }).map((_, i) => (
                <div
                  key={i}
                  style={{
                    width: 12,
                    height: 12,
                    borderRadius: '50%',
                    background: rgba([0.5, 0.3, 0.8], 0.6),
                    border: '0.5px solid rgba(255,255,255,0.3)',
                  }}
                />
              ))}
            </div>
          </HeaderFooter>
          <HeaderFooter style={{ padding: '10px 18px 0' }}>
            <div style={{ height: 1, background: rgba([0.5, 0.3, 0.8], 0.15) }} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.monospaced, paddingX: 24, lineHeight: 1.25 })}
          <HeaderFooter style={{ padding: '0 18px' }}>
            <div style={{ height: 1, background: rgba([0.5, 0.3, 0.8], 0.15) }} />
          </HeaderFooter>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '10px 20px',
            }}
          >
            <Icon name="sparkles" size={10} color={rgba([0.5, 0.3, 0.8], 0.4)} />
            <span
              style={{
                fontSize: 8,
                fontStyle: 'italic',
                fontFamily: FONT_FAMILY.serif,
                color: rgba(theme.cardTextColor, 0.3),
              }}
            >
              Legendary Question
            </span>
          </HeaderFooter>
        </div>
      );

    // MARK: Hanafuda (Cherry Blossom)
    case 'cherryBlossom':
      return (
        <div style={column}>
          <HeaderFooter style={{ display: 'flex', padding: '22px 24px 0' }}>
            <Icon name="leaf.fill" size={11} color={rgba([0.9, 0.55, 0.65], 0.5)} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, paddingX: 28, lineHeight: 1.4 })}
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'flex-end', padding: '0 24px 22px' }}
          >
            <Icon name="leaf.fill" size={10} color={rgba([0.9, 0.55, 0.65], 0.4)} />
          </HeaderFooter>
        </div>
      );

    // MARK: Arcade (Retro)
    case 'retroGame': {
      const green = rgb([0.1, 0.95, 0.4]);
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '16px 20px 0',
              fontFamily: FONT_FAMILY.monospaced,
              fontWeight: 700,
              fontSize: 10,
            }}
          >
            <span style={{ color: green }}>P1</span>
            <span style={{ color: rgba([0.1, 0.95, 0.4], 0.6) }}>{`LV.${(n % 99) + 1}`}</span>
            <span style={{ color: green }}>{`STAGE ${(n % 12) + 1}`}</span>
          </HeaderFooter>
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 4, padding: '6px 20px 0' }}
          >
            <span style={{ fontSize: 8, fontWeight: 700, fontFamily: FONT_FAMILY.monospaced, color: 'red' }}>HP</span>
            <div style={{ flex: 1, height: 6, borderRadius: 2, background: 'rgba(128,128,128,0.3)', overflow: 'hidden' }}>
              <div style={{ width: '70%', height: '100%', borderRadius: 2, background: 'green' }} />
            </div>
          </HeaderFooter>
          {question(q, theme, {
            design: FONT_FAMILY.monospaced,
            size: Q_SIZE - 4,
            paddingX: 22,
            lineHeight: 1.25,
            align: 'left',
            prefix: '▶ ',
          })}
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '0 20px 16px',
              fontFamily: FONT_FAMILY.monospaced,
            }}
          >
            <span style={{ fontSize: 10, color: rgba([0.1, 0.95, 0.4], 0.5) }}>{'> READY_'}</span>
            <span style={{ fontSize: 12, color: green }}>▼</span>
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Tarot (Autumn)
    case 'autumn': {
      const brown = rgb([0.65, 0.45, 0.2]);
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              textAlign: 'center',
              paddingTop: 20,
              fontFamily: FONT_FAMILY.serif,
              fontWeight: 700,
              fontSize: 12,
              letterSpacing: 4,
              color: brown,
            }}
          >
            {roman((n % 22) + 1)}
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, paddingX: 30, lineHeight: 1.4 })}
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: 6,
              paddingBottom: 20,
            }}
          >
            <Icon name="star.fill" size={6} color={rgba([0.65, 0.45, 0.2], 0.5)} />
            <Icon name="moon.fill" size={8} color={rgba([0.65, 0.45, 0.2], 0.5)} />
            <Icon name="star.fill" size={6} color={rgba([0.65, 0.45, 0.2], 0.5)} />
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Holographic (Aurora)
    case 'aurora':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '20px 22px 0',
            }}
          >
            <div style={{ display: 'flex', gap: 2 }}>
              {Array.from({ length: 3 }).map((_, i) => (
                <Icon key={i} name="sparkle" size={7} color={rgba(theme.accentColor, 0.5)} />
              ))}
            </div>
            <div style={{ display: 'flex', gap: 2 }}>
              {Array.from({ length: 3 }).map((_, i) => (
                <Icon key={i} name="sparkle" size={7} color={rgba([0.2, 0.9, 0.6], 0.6)} />
              ))}
            </div>
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.default, paddingX: 26, lineHeight: 1.25 })}
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'flex-end',
              padding: '0 22px 18px',
              fontSize: 7,
              fontWeight: 700,
              letterSpacing: 2,
              color: rgba(theme.accentColor, 0.3),
            }}
          >
            ULTRA RARE
          </HeaderFooter>
        </div>
      );

    // MARK: Playing Card (Circus)
    case 'circus': {
      const red = rgb([0.85, 0.15, 0.2]);
      const corner = (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 1 }}>
          <span style={{ fontSize: 20, fontWeight: 800, fontFamily: FONT_FAMILY.rounded, color: red }}>Q</span>
          <Icon name="heart.fill" size={10} color={red} />
        </div>
      );
      return (
        <div style={column}>
          <HeaderFooter style={{ display: 'flex', padding: '14px 18px 0' }}>{corner}</HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.rounded, paddingX: 28, lineHeight: 1.25 })}
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'flex-end', padding: '0 18px 14px' }}
          >
            <div style={{ transform: 'rotate(180deg)' }}>{corner}</div>
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Egyptian (Desert)
    case 'desert': {
      const sand = rgb([0.9, 0.75, 0.35]);
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '20px 22px 0',
            }}
          >
            <Icon name="eye.fill" size={12} color={rgba([0.9, 0.75, 0.35], 0.5)} />
            <Icon name="sun.max.fill" size={10} color={rgba([0.9, 0.75, 0.35], 0.4)} />
            <Icon name="eye.fill" size={12} color={rgba([0.9, 0.75, 0.35], 0.5)} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.default, paddingX: 26, lineHeight: 1.25 })}
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: 8,
              paddingBottom: 20,
              color: rgba([0.9, 0.75, 0.35], 0.3),
            }}
          >
            <Icon name="triangle.fill" size={8} color={sand} />
            <Icon name="circle.fill" size={5} color={sand} />
            <Icon name="diamond.fill" size={6} color={sand} />
            <Icon name="circle.fill" size={5} color={sand} />
            <Icon name="triangle.fill" size={8} color={sand} />
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Candy
    case 'candy': {
      const sprinkles = [
        [0.95, 0.35, 0.55],
        [0.55, 0.85, 0.75],
        [0.98, 0.8, 0.25],
        [0.65, 0.5, 0.9],
        [0.95, 0.55, 0.35],
        [0.5, 0.8, 0.95],
        [0.95, 0.35, 0.55],
      ] as const;
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              gap: 8,
              paddingTop: 20,
            }}
          >
            {sprinkles.map((c, i) => {
              const d = 4 + (i % 3) * 2;
              return (
                <div key={i} style={{ width: d, height: d, borderRadius: '50%', background: rgba(c, 0.5) }} />
              );
            })}
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.rounded, paddingX: 28, lineHeight: 1.25 })}
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 4, padding: '0 24px 20px' }}
          >
            <Icon name="heart.fill" size={8} color={rgba([0.95, 0.35, 0.55], 0.4)} />
            <div style={{ flex: 1, height: 1, background: rgba([0.95, 0.35, 0.55], 0.15) }} />
            <Icon name="heart.fill" size={8} color={rgba([0.95, 0.35, 0.55], 0.4)} />
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Zen Garden
    case 'zenGarden':
      return (
        <div style={column}>
          <HeaderFooter style={{ display: 'flex', justifyContent: 'center', paddingTop: 24 }}>
            <div
              style={{
                width: 24,
                height: 24,
                borderRadius: '50%',
                border: `1.5px solid ${rgba([0.35, 0.38, 0.32], 0.2)}`,
              }}
            />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, paddingX: 30, lineHeight: 1.4 })}
          <HeaderFooter style={{ display: 'flex', flexDirection: 'column', gap: 4, padding: '0 30px 22px' }}>
            {Array.from({ length: 3 }).map((_, i) => (
              <ZenWave key={i} />
            ))}
          </HeaderFooter>
        </div>
      );

    // MARK: Forsythia
    case 'forsythia': {
      const yellow = [0.98, 0.85, 0.08] as const;
      const daisy = (scale: number, op: number) => (
        <div style={{ position: 'relative', width: 14 * scale, height: 14 * scale }}>
          {Array.from({ length: 6 }).map((_, p) => (
            <div
              key={p}
              style={{
                position: 'absolute',
                left: '50%',
                top: '50%',
                width: 4 * scale,
                height: 7 * scale,
                marginLeft: -2 * scale,
                marginTop: -3.5 * scale,
                borderRadius: '50%',
                background: rgba(yellow, op),
                transform: `rotate(${p * 60}deg) translateY(${-5 * scale}px)`,
                transformOrigin: 'center',
              }}
            />
          ))}
          <div
            style={{
              position: 'absolute',
              left: '50%',
              top: '50%',
              width: 5 * scale,
              height: 5 * scale,
              marginLeft: -2.5 * scale,
              marginTop: -2.5 * scale,
              borderRadius: '50%',
              background: rgba([0.85, 0.65, 0.08], op + 0.1),
            }}
          />
        </div>
      );
      return (
        <div style={column}>
          <HeaderFooter style={{ display: 'flex', justifyContent: 'center', paddingTop: 24 }}>
            {daisy(1, 0.35)}
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.rounded, paddingX: 28, lineHeight: 1.35 })}
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 14, paddingBottom: 22 }}
          >
            {[0, 1, 2].map((i) => (
              <div key={i}>{daisy(0.85, 0.3 - i * 0.05)}</div>
            ))}
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Ocean
    case 'ocean': {
      const blue = [0.2, 0.6, 0.85] as const;
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '20px 22px 0',
            }}
          >
            <Icon name="water.waves" size={10} color={rgba(blue, 0.5)} />
            <div style={{ display: 'flex', gap: 3 }}>
              {Array.from({ length: 3 }).map((_, i) => (
                <div key={i} style={{ width: 5, height: 5, borderRadius: '50%', background: rgba(blue, 0.3) }} />
              ))}
            </div>
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.rounded, paddingX: 28, lineHeight: 1.35 })}
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 4, padding: '0 24px 20px' }}
          >
            <div style={{ flex: 1, height: 1, background: rgba(blue, 0.15) }} />
            <Icon name="fish.fill" size={8} color={rgba(blue, 0.3)} />
            <div style={{ flex: 1, height: 1, background: rgba(blue, 0.15) }} />
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Neon Cyber
    case 'neonCyber': {
      const cyan = [0.0, 0.95, 0.9] as const;
      const pink = [0.95, 0.2, 0.6] as const;
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '16px 20px 0',
              fontFamily: FONT_FAMILY.monospaced,
              fontWeight: 700,
              fontSize: 9,
            }}
          >
            <span style={{ color: rgba(cyan, 0.6) }}>SYS://</span>
            <span style={{ color: rgba(pink, 0.6) }}>{`v${(n % 99) + 1}.${n % 10}`}</span>
          </HeaderFooter>
          <HeaderFooter style={{ padding: '8px 18px 0' }}>
            <div
              style={{
                height: 1,
                background: `linear-gradient(90deg, ${rgba(pink, 0.5)}, ${rgba(cyan, 0.5)})`,
              }}
            />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.monospaced, size: Q_SIZE - 2, paddingX: 22, lineHeight: 1.2 })}
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '0 20px 16px',
              fontFamily: FONT_FAMILY.monospaced,
            }}
          >
            <span style={{ fontSize: 8, color: rgba(cyan, 0.4) }}>◈ CONNECTED</span>
            <span style={{ fontSize: 10, color: rgba(pink, 0.4) }}>▮▮▯</span>
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Korean Traditional
    case 'korean': {
      const dancheong = [
        [0.78, 0.22, 0.28],
        [0.15, 0.45, 0.35],
        [0.85, 0.65, 0.15],
        [0.2, 0.35, 0.6],
        [0.78, 0.22, 0.28],
      ] as const;
      return (
        <div style={column}>
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 8, paddingTop: 22 }}
          >
            {dancheong.map((c, i) => (
              <div key={i} style={{ width: 12, height: 3, background: rgba(c, 0.3) }} />
            ))}
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, paddingX: 30, lineHeight: 1.4 })}
          <HeaderFooter
            style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 28px 22px' }}
          >
            <div style={{ flex: 1, height: 1, background: rgba([0.78, 0.22, 0.28], 0.2) }} />
            <div style={{ width: 6, height: 6, borderRadius: '50%', background: rgba([0.78, 0.22, 0.28], 0.3) }} />
            <div style={{ width: 6, height: 6, borderRadius: '50%', background: rgba([0.2, 0.35, 0.6], 0.3) }} />
            <div style={{ flex: 1, height: 1, background: rgba([0.2, 0.35, 0.6], 0.2) }} />
          </HeaderFooter>
        </div>
      );
    }

    // MARK: Rainy Day
    case 'rainyDay':
      return (
        <div style={column}>
          <HeaderFooter
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '20px 22px 0',
            }}
          >
            <Icon name="cloud.fill" size={12} color={rgba([0.5, 0.55, 0.65], 0.4)} />
            <Icon name="cloud.rain.fill" size={10} color={rgba([0.5, 0.65, 0.8], 0.4)} />
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.default, paddingX: 26, lineHeight: 1.35 })}
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'center', alignItems: 'flex-end', gap: 10, paddingBottom: 22 }}
          >
            {Array.from({ length: 5 }).map((_, i) => (
              <div
                key={i}
                style={{
                  width: 1.5,
                  height: 6 + (i % 3) * 4,
                  borderRadius: 1,
                  background: rgba([0.5, 0.65, 0.8], 0.15 + (i % 3) * 0.05),
                }}
              />
            ))}
          </HeaderFooter>
        </div>
      );

    // MARK: Lavender
    case 'lavender':
      return (
        <div style={column}>
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 4, paddingTop: 22 }}
          >
            {Array.from({ length: 3 }).map((_, i) => (
              <Icon key={i} name="sparkle" size={8} color={rgba([0.6, 0.4, 0.8], 0.4)} />
            ))}
          </HeaderFooter>
          {question(q, theme, { design: FONT_FAMILY.serif, paddingX: 28, lineHeight: 1.4 })}
          <HeaderFooter
            style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 8, paddingBottom: 22 }}
          >
            <Icon name="leaf.fill" size={8} color={rgba([0.5, 0.65, 0.45], 0.3)} style={{ transform: 'rotate(-30deg)' }} />
            {Array.from({ length: 3 }).map((_, i) => (
              <div key={i} style={{ width: 5, height: 5, borderRadius: '50%', background: rgba([0.6, 0.4, 0.8], 0.25) }} />
            ))}
            <Icon name="leaf.fill" size={8} color={rgba([0.5, 0.65, 0.45], 0.3)} style={{ transform: 'rotate(30deg)' }} />
          </HeaderFooter>
        </div>
      );

    default:
      return (
        <div style={column}>{question(q, theme, { paddingX: 28 })}</div>
      );
  }
}

function ZenWave() {
  return (
    <svg viewBox="0 0 100 6" preserveAspectRatio="none" style={{ width: '100%', height: 6 }}>
      <path
        d={zenWavePath(100, 6)}
        fill="none"
        stroke={rgba([0.55, 0.58, 0.5], 0.15)}
        strokeWidth={0.8}
      />
    </svg>
  );
}

function zenWavePath(w: number, h: number): string {
  const waves = 6;
  const step = w / waves;
  const mid = h / 2;
  let p = `M 0 ${mid}`;
  for (let i = 0; i < waves; i++) {
    const x1 = step * i + step * 0.5;
    const x2 = step * (i + 1);
    p += ` Q ${step * i + step * 0.25} ${mid - h * 0.4} ${x1} ${mid - h * 0.4}`;
    p += ` Q ${x1 + step * 0.25} ${mid + h * 0.4} ${x2} ${mid}`;
  }
  return p;
}

function roman(n: number): string {
  const table: [number, string][] = [
    [10, 'X'],
    [9, 'IX'],
    [5, 'V'],
    [4, 'IV'],
    [1, 'I'],
  ];
  let out = '';
  let r = n;
  for (const [v, s] of table) {
    while (r >= v) {
      out += s;
      r -= v;
    }
  }
  return out;
}
