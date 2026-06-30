import { useState } from 'react';
import { ALL_PACKS, type Pack, type PackKey } from '../theme/packs';
import type { Theme } from '../theme/types';
import { FONT_FAMILY } from '../theme/types';
import { rgb, rgba } from '../lib/colors';
import { t } from '../i18n';
import { Icon } from '../lib/icon';
import { FanScroller, type FanPhaseStyle } from './FanScroller';

function clamp(v: number, lo: number, hi: number) {
  return Math.max(lo, Math.min(hi, v));
}

const packPhase = (phase: number): FanPhaseStyle => ({
  scale: clamp(1.15 - Math.abs(phase) * 0.3, 0.78, 1.15),
  rotateDeg: phase * 16,
  translateY: -10 + Math.abs(phase) * 26,
});

function FanPackCard({ pack, selected }: { pack: Pack; selected: boolean }) {
  const accent = rgb(pack.accentColor);
  const accent7 = rgba(pack.accentColor, 0.7);
  return (
    <div
      style={{
        position: 'relative',
        width: 140,
        height: 220,
        borderRadius: 16,
        background: `linear-gradient(135deg, ${accent}, ${accent7})`,
        boxShadow: '0 3px 6px rgba(0,0,0,0.3)',
        overflow: 'hidden',
      }}
    >
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background:
            'linear-gradient(135deg, rgba(255,255,255,0.25), transparent 50%, rgba(255,255,255,0.08))',
        }}
      />
      <div
        style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 10,
        }}
      >
        <div
          style={{
            width: 54,
            height: 54,
            borderRadius: '50%',
            background: 'rgba(255,255,255,0.2)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <Icon name={pack.iconName} size={24} color="#fff" />
        </div>
        <div
          style={{
            fontFamily: FONT_FAMILY.rounded,
            fontWeight: 700,
            fontSize: 15,
            color: '#fff',
          }}
        >
          {t(pack.nameKey)}
        </div>
      </div>
      {selected && (
        <div style={{ position: 'absolute', top: 8, right: 8 }}>
          <Icon name="checkmark.circle.fill" size={18} color="#fff" />
        </div>
      )}
    </div>
  );
}

export function PackPicker({
  theme,
  selectedPack,
  onSelect,
  onClose,
}: {
  theme: Theme;
  selectedPack: PackKey;
  onSelect: (pack: PackKey) => void;
  onClose: () => void;
}) {
  const initialIndex = Math.max(
    0,
    ALL_PACKS.findIndex((p) => p.key === selectedPack)
  );
  const [centerIdx, setCenterIdx] = useState(initialIndex);
  const current = ALL_PACKS[centerIdx] ?? ALL_PACKS[0];
  const isSelected = current.key === selectedPack;

  const activate = (idx: number) => {
    const pack = ALL_PACKS[idx];
    if (pack.key === selectedPack) {
      onClose();
      return;
    }
    // 광고 게이트/적용/닫기는 부모(onSelect)가 처리한다.
    onSelect(pack.key);
  };

  return (
    <div
      className="picker-fade-in"
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 50,
        background: 'rgb(20, 15, 41)',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      {/* glow background */}
      <div
        aria-hidden
        style={{
          position: 'absolute',
          inset: 0,
          overflow: 'hidden',
          pointerEvents: 'none',
        }}
        onClick={onClose}
      >
        <div
          className="picker-orb picker-orb-a"
          style={{ background: `radial-gradient(circle, ${rgba(current.accentColor, 0.5)}, transparent 70%)` }}
        />
        <div
          className="picker-orb picker-orb-b"
          style={{ background: `radial-gradient(circle, ${rgba(current.accentColor, 0.35)}, transparent 70%)` }}
        />
      </div>

      {/* close */}
      <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '16px 20px 0', zIndex: 1 }}>
        <button onClick={onClose} style={{ width: 32, height: 32, color: 'rgba(255,255,255,0.4)' }}>
          <Icon name="xmark" size={15} />
        </button>
      </div>

      {/* title */}
      <div style={{ textAlign: 'center', paddingTop: 20, zIndex: 1 }}>
        <div style={{ fontFamily: FONT_FAMILY[theme.fontDesign], fontWeight: 700, fontSize: 20, color: '#fff' }}>
          {t('ui_pack_picker_title')}
        </div>
        <div style={{ marginTop: 12 }}>
          <div
            style={{
              fontFamily: FONT_FAMILY[theme.fontDesign],
              fontWeight: 800,
              fontSize: 28,
              color: rgb(current.accentColor),
            }}
          >
            {t(current.nameKey)}
          </div>
          <div
            style={{
              fontFamily: FONT_FAMILY[theme.fontDesign],
              fontSize: 14,
              color: 'rgba(255,255,255,0.6)',
              marginTop: 6,
              padding: '0 32px',
            }}
          >
            {t(current.descKey)}
          </div>
        </div>
      </div>

      <div style={{ flex: 1 }} />

      {/* select button */}
      <div style={{ padding: '0 40px 24px', zIndex: 1 }}>
        <button
          onClick={() => activate(centerIdx)}
          style={{
            width: '100%',
            padding: '16px 0',
            borderRadius: 999,
            background: rgb(current.accentColor),
            boxShadow: `0 4px 12px ${rgba(current.accentColor, 0.5)}`,
            color: '#fff',
            fontFamily: FONT_FAMILY[theme.fontDesign],
            fontWeight: 700,
            fontSize: 16,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
          }}
        >
          <Icon name={isSelected ? 'checkmark.circle.fill' : 'hand.wave.fill'} size={16} color="#fff" />
          {isSelected ? t('ui_selected') : t('ui_start_with_this_pack')}
        </button>
      </div>

      {/* fan */}
      <div style={{ paddingBottom: 40, zIndex: 1 }}>
        <FanScroller
          items={ALL_PACKS}
          initialIndex={initialIndex}
          cardWidth={140}
          gap={-50}
          height={300}
          phaseStyle={packPhase}
          onCenterChange={setCenterIdx}
          onActivate={activate}
          renderCard={(pack) => <FanPackCard pack={pack} selected={pack.key === selectedPack} />}
        />
      </div>
    </div>
  );
}
