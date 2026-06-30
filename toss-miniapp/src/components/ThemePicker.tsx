import { useState } from 'react';
import { ALL_THEMES } from '../theme/themes';
import type { Theme, ThemeKey } from '../theme/types';
import { FONT_FAMILY } from '../theme/types';
import { rgb, rgba } from '../lib/colors';
import { t } from '../i18n';
import { Icon } from '../lib/icon';
import { FanScroller, type FanPhaseStyle } from './FanScroller';
import { ThemedCardBorder } from './CardShapes';
import { CardBackgroundPattern, CardDecorationOverlay } from './CardDecorations';

function clamp(v: number, lo: number, hi: number) {
  return Math.max(lo, Math.min(hi, v));
}

const themePhase = (phase: number): FanPhaseStyle => ({
  scale: clamp(1.4 - Math.abs(phase) * 0.45, 0.75, 1.4),
  rotateDeg: 0,
  translateY: 0,
  rotate3dDeg: phase * -40,
  perspective: 700,
  opacity: clamp(1 - Math.abs(phase) * 0.4, 0.5, 1),
});

function ThemeSmallCard({ theme }: { theme: Theme }) {
  const radius = theme.cardCornerRadius * 0.7;
  return (
    <div
      style={{
        position: 'relative',
        width: 80,
        height: 120,
        borderRadius: radius,
        overflow: 'hidden',
        background: rgb(theme.cardBackgroundColor),
        boxShadow: `0 0 4px ${rgb(theme.cardShadowColor)}`,
        border: `1px solid ${rgba(theme.accentColor, 0.3)}`,
      }}
    >
      <CardBackgroundPattern theme={theme} />
      <CardDecorationOverlay theme={theme} />
    </div>
  );
}

function ThemeLargePreview({ theme }: { theme: Theme }) {
  const radius = theme.cardCornerRadius;
  return (
    <div
      style={{
        position: 'relative',
        width: 220,
        height: 220,
        borderRadius: radius,
        background: rgb(theme.cardBackgroundColor),
        boxShadow: `0 0 12px ${rgb(theme.cardShadowColor)}, 0 0 30px ${rgba(
          [theme.cardShadowColor[0], theme.cardShadowColor[1], theme.cardShadowColor[2]],
          theme.cardShadowColor[3] * 0.4
        )}`,
      }}
    >
      <div style={{ position: 'absolute', inset: 0, borderRadius: radius, overflow: 'hidden' }}>
        <CardBackgroundPattern theme={theme} />
      </div>
      <div style={{ position: 'absolute', inset: 0 }}>
        <ThemedCardBorder theme={theme} />
      </div>
      <div style={{ position: 'absolute', inset: 0, borderRadius: radius, overflow: 'hidden' }}>
        <CardDecorationOverlay theme={theme} />
      </div>
      <div
        style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 12,
        }}
      >
        <div style={{ fontSize: 48 }}>{theme.emoji}</div>
        <div
          style={{
            fontFamily: FONT_FAMILY[theme.fontDesign],
            fontWeight: 700,
            fontSize: 22,
            color: rgb(theme.cardTextColor),
          }}
        >
          {t(theme.nameKey)}
        </div>
      </div>
    </div>
  );
}

export function ThemePicker({
  selectedTheme,
  onSelect,
  onClose,
}: {
  selectedTheme: ThemeKey;
  onSelect: (key: ThemeKey) => void;
  onClose: () => void;
}) {
  const initialIndex = Math.max(
    0,
    ALL_THEMES.findIndex((th) => th.key === selectedTheme)
  );
  const [centerIdx, setCenterIdx] = useState(initialIndex);
  const current = ALL_THEMES[centerIdx] ?? ALL_THEMES[0];
  const isSelected = current.key === selectedTheme;

  const activate = (idx: number) => {
    const th = ALL_THEMES[idx];
    onSelect(th.key);
    onClose();
  };

  return (
    <div
      className="picker-fade-in"
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 50,
        background: 'rgb(15, 10, 36)',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <div
        aria-hidden
        onClick={onClose}
        style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'auto' }}
      >
        <div
          className="picker-orb picker-orb-a"
          style={{ background: `radial-gradient(circle, ${rgba(current.accentColor, 0.55)}, transparent 70%)` }}
        />
        <div
          className="picker-orb picker-orb-b"
          style={{ background: `radial-gradient(circle, ${rgba(current.accentColor, 0.4)}, transparent 70%)` }}
        />
      </div>

      <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '16px 20px 0', zIndex: 1 }}>
        <button onClick={onClose} style={{ width: 32, height: 32, color: 'rgba(255,255,255,0.4)' }}>
          <Icon name="xmark" size={15} />
        </button>
      </div>

      <div
        style={{
          textAlign: 'center',
          fontFamily: FONT_FAMILY.rounded,
          fontWeight: 700,
          fontSize: 20,
          color: '#fff',
          zIndex: 1,
        }}
      >
        {t('ui_theme_picker_title')}
      </div>

      <div
        style={{
          flex: 1,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1,
        }}
        onClick={() => activate(centerIdx)}
      >
        <ThemeLargePreview theme={current} />
      </div>

      <div style={{ padding: '0 40px', zIndex: 1 }}>
        <button
          onClick={() => activate(centerIdx)}
          style={{
            width: '100%',
            padding: '16px 0',
            borderRadius: 999,
            background: rgb(current.accentColor),
            boxShadow: `0 4px 12px ${rgba(current.accentColor, 0.5)}`,
            color: '#fff',
            fontFamily: FONT_FAMILY.rounded,
            fontWeight: 700,
            fontSize: 16,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
          }}
        >
          <Icon name={isSelected ? 'checkmark.circle.fill' : 'paintpalette.fill'} size={16} color="#fff" />
          {isSelected ? t('ui_selected') : t('ui_apply_this_theme')}
        </button>
      </div>

      <div style={{ padding: '24px 0 40px', zIndex: 1 }}>
        <FanScroller
          items={ALL_THEMES}
          initialIndex={initialIndex}
          cardWidth={80}
          gap={4}
          height={170}
          phaseStyle={themePhase}
          onCenterChange={setCenterIdx}
          onActivate={activate}
          renderCard={(th) => <ThemeSmallCard theme={th} />}
        />
      </div>
    </div>
  );
}
