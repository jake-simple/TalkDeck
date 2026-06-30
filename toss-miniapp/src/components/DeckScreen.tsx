import { type PointerEvent as ReactPointerEvent, useEffect, useRef, useState } from 'react';
import { useDeck } from '../store/useDeck';
import { useThemeStore } from '../store/useThemeStore';
import { THEMES } from '../theme/themes';
import type { Theme } from '../theme/types';
import { FONT_FAMILY } from '../theme/types';
import { rgb, rgba, linearGradient } from '../lib/colors';
import { Haptics } from '../lib/haptics';
import { t } from '../i18n';
import { PACKS } from '../theme/packs';
import { Icon } from '../lib/icon';
import { CardView } from './CardView';
import { ThemeParticleScene } from './ThemeParticleScene';
import { PackPicker } from './PackPicker';
import { ThemePicker } from './ThemePicker';

const SWIPE_THRESHOLD = 60;

export function DeckScreen() {
  const themeKey = useThemeStore((s) => s.themeKey);
  const setTheme = useThemeStore((s) => s.setTheme);
  const theme = THEMES[themeKey];

  const currentDeck = useDeck((s) => s.currentDeck);
  const currentIndex = useDeck((s) => s.currentIndex);
  const selectedPack = useDeck((s) => s.selectedPack);
  const showRandomCard = useDeck((s) => s.showRandomCard);
  const randomCard = useDeck((s) => s.randomCard);
  const swipeCard = useDeck((s) => s.swipeCard);
  const buildGameDeck = useDeck((s) => s.buildGameDeck);
  const showRandom = useDeck((s) => s.showRandom);
  const closeRandom = useDeck((s) => s.closeRandom);
  const selectPack = useDeck((s) => s.selectPack);

  const [showPack, setShowPack] = useState(false);
  const [showTheme, setShowTheme] = useState(false);
  const [awake, setAwake] = useState(false);
  const wakeLockRef = useRef<any>(null);

  const [offset, setOffset] = useState({ x: 0, y: 0 });
  const [animating, setAnimating] = useState(false);
  const dragStart = useRef<{ x: number; y: number } | null>(null);

  const total = currentDeck.length;
  const remaining = Math.max(total - currentIndex, 0);
  const isFinished = currentIndex >= total;
  const visible = currentDeck.slice(currentIndex, Math.min(currentIndex + 3, total));

  // 셰이크 → 랜덤 카드
  useEffect(() => {
    let last = 0;
    const onMotion = (e: DeviceMotionEvent) => {
      const a = e.accelerationIncludingGravity;
      if (!a) return;
      const mag = Math.abs(a.x ?? 0) + Math.abs(a.y ?? 0) + Math.abs(a.z ?? 0);
      const now = Date.now();
      if (mag > 28 && now - last > 1200) {
        last = now;
        showRandom();
      }
    };
    window.addEventListener('devicemotion', onMotion);
    return () => window.removeEventListener('devicemotion', onMotion);
  }, [showRandom]);

  const toggleAwake = async () => {
    try {
      if (!awake && 'wakeLock' in navigator) {
        wakeLockRef.current = await (navigator as any).wakeLock.request('screen');
        setAwake(true);
      } else {
        await wakeLockRef.current?.release?.();
        wakeLockRef.current = null;
        setAwake(false);
      }
    } catch {
      setAwake((v) => !v);
    }
  };

  const performShuffle = () => {
    Haptics.shuffle();
    buildGameDeck();
  };

  // 드래그
  const onPointerDown = (e: ReactPointerEvent) => {
    if (animating) return;
    dragStart.current = { x: e.clientX, y: e.clientY };
    (e.target as HTMLElement).setPointerCapture?.(e.pointerId);
  };
  const onPointerMove = (e: ReactPointerEvent) => {
    if (!dragStart.current) return;
    setOffset({ x: e.clientX - dragStart.current.x, y: e.clientY - dragStart.current.y });
  };
  const onPointerUp = () => {
    if (!dragStart.current) return;
    dragStart.current = null;
    const { x, y } = offset;
    const hDist = Math.abs(x);
    const vDist = Math.abs(y);
    const flyOut = (tx: number, ty: number, ms: number) => {
      setAnimating(true);
      setOffset({ x: tx, y: ty });
      window.setTimeout(() => {
        swipeCard();
        setAnimating(false);
        setOffset({ x: 0, y: 0 });
      }, ms);
    };
    if (hDist >= vDist) {
      if (hDist > SWIPE_THRESHOLD) {
        const dir = x > 0 ? 1 : -1;
        flyOut(dir * 600, y * 0.5, 220);
      } else {
        snapBack();
      }
    } else {
      if (vDist > SWIPE_THRESHOLD) {
        const dir = y > 0 ? 1 : -1;
        flyOut(0, dir * 800, 200);
      } else {
        snapBack();
      }
    }
  };
  const snapBack = () => {
    setAnimating(true);
    setOffset({ x: 0, y: 0 });
    window.setTimeout(() => setAnimating(false), 220);
  };

  const isHorizontal = Math.abs(offset.x) >= Math.abs(offset.y);
  const topRotation = isHorizontal ? offset.x / 25 : 0;
  const topScale = !isHorizontal ? 1 - Math.min(vAbs(offset.y) / 300, 1) * 0.15 : 1;

  return (
    <div
      style={{
        position: 'relative',
        width: '100%',
        height: '100%',
        overflow: 'hidden',
        background: linearGradient(theme.backgroundGradientColors.map((c) => rgb(c))),
        transition: 'background 0.5s ease',
      }}
    >
      <ThemeParticleScene theme={theme} />

      {/* 메인 레이아웃 */}
      <div
        style={{
          position: 'relative',
          zIndex: 1,
          height: '100%',
          display: 'flex',
          flexDirection: 'column',
          paddingTop: 'env(safe-area-inset-top)',
          paddingBottom: 'env(safe-area-inset-bottom)',
        }}
      >
        {/* 헤더 */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            padding: '8px 20px 0',
          }}
        >
          <button
            onClick={() => {
              setShowPack(true);
              setShowTheme(false);
            }}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 4,
              color: rgb(theme.accentColor),
              fontFamily: FONT_FAMILY[theme.fontDesign],
              fontWeight: 500,
              fontSize: 15,
            }}
          >
            <Icon name={PACKS[selectedPack].iconName} size={16} color={rgb(theme.accentColor)} />
            {t(PACKS[selectedPack].nameKey)}
          </button>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button onClick={toggleAwake}>
              <Icon
                name={awake ? 'sun.max.fill' : 'sun.max'}
                size={20}
                color={awake ? rgb(theme.accentColor) : rgba(theme.accentColor, 0.4)}
              />
            </button>
            <button
              onClick={() => {
                setShowTheme(true);
                setShowPack(false);
              }}
            >
              <Icon name="paintpalette.fill" size={20} color={rgb(theme.accentColor)} />
            </button>
          </div>
        </div>

        {/* 카드 영역 */}
        <div
          style={{
            flex: 1,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            position: 'relative',
            transform: 'translateY(-12px)',
          }}
        >
          {isFinished ? (
            <FinishedView themeKey={themeKey} onShuffle={performShuffle} />
          ) : (
            <div
              style={{
                position: 'relative',
                width: '100%',
                maxWidth: 400,
                aspectRatio: '1 / 1',
                padding: '0 24px',
              }}
            >
              {[...visible].reverse().map((card, ri) => {
                const index = visible.length - 1 - ri; // 0 = top
                const isTop = index === 0;
                const stackOffset = index * 8;
                const stackScale = 1 - index * 0.05;
                const opacity = index === 0 ? 1 : index === 1 ? 0.6 : 0;
                const transform = isTop
                  ? `translate(${offset.x}px, ${offset.y}px) rotate(${topRotation}deg) scale(${topScale})`
                  : `translateY(${stackOffset}px) scale(${stackScale})`;
                return (
                  <div
                    key={card.id}
                    onPointerDown={isTop ? onPointerDown : undefined}
                    onPointerMove={isTop ? onPointerMove : undefined}
                    onPointerUp={isTop ? onPointerUp : undefined}
                    onPointerCancel={isTop ? onPointerUp : undefined}
                    style={{
                      position: 'absolute',
                      inset: 0,
                      margin: '0 24px',
                      zIndex: visible.length - index,
                      opacity,
                      transform,
                      transition:
                        isTop && animating
                          ? 'transform 0.22s ease-out'
                          : isTop
                          ? 'none'
                          : 'transform 0.3s ease, opacity 0.3s ease',
                      touchAction: 'none',
                      cursor: isTop ? 'grab' : 'default',
                    }}
                  >
                    <CardView card={card} theme={theme} />
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* 하단 바 */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            padding: '0 24px 8px',
          }}
        >
          <RoundButton theme={theme} icon="shuffle" onClick={performShuffle} />
          {!isFinished && (
            <span
              style={{
                fontFamily: FONT_FAMILY[theme.fontDesign],
                fontWeight: 500,
                fontSize: 15,
                color: rgba(theme.textColor, 0.6),
              }}
            >
              {`${total - remaining + 1} / ${total}`}
            </span>
          )}
          <RoundButton theme={theme} icon="dice.fill" onClick={showRandom} />
        </div>
      </div>

      {/* 랜덤 카드 오버레이 */}
      {showRandomCard && randomCard && (
        <div
          onClick={closeRandom}
          style={{
            position: 'fixed',
            inset: 0,
            zIndex: 40,
            background: 'rgba(0,0,0,0.4)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            animation: 'overlayIn 0.3s ease',
          }}
        >
          <div
            style={{
              width: '100%',
              maxWidth: 400,
              aspectRatio: '1 / 1',
              padding: '0 32px',
              animation: 'randomCardIn 0.35s cubic-bezier(0.2,0.8,0.3,1)',
            }}
          >
            <CardView card={randomCard} theme={theme} />
          </div>
        </div>
      )}

      {showPack && (
        <PackPicker
          theme={theme}
          selectedPack={selectedPack}
          onSelect={(p) => void selectPack(p)}
          onClose={() => setShowPack(false)}
        />
      )}
      {showTheme && (
        <ThemePicker
          selectedTheme={themeKey}
          onSelect={setTheme}
          onClose={() => setShowTheme(false)}
        />
      )}
    </div>
  );
}

function vAbs(n: number) {
  return Math.abs(n);
}

function RoundButton({
  theme,
  icon,
  onClick,
}: {
  theme: Theme;
  icon: string;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      style={{
        width: 44,
        height: 44,
        borderRadius: '50%',
        background: rgb(theme.buttonColor),
        boxShadow: `0 2px 4px ${rgb(theme.cardShadowColor)}`,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: rgb(theme.accentColor),
      }}
    >
      <Icon name={icon} size={20} color={rgb(theme.accentColor)} />
    </button>
  );
}

function FinishedView({
  themeKey,
  onShuffle,
}: {
  themeKey: keyof typeof THEMES;
  onShuffle: () => void;
}) {
  const theme = THEMES[themeKey];
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: 20,
      }}
    >
      <Icon name={theme.iconName} size={50} color={rgb(theme.accentColor)} />
      <div
        style={{
          fontFamily: FONT_FAMILY[theme.fontDesign],
          fontWeight: 700,
          fontSize: 22,
          color: rgb(theme.textColor),
        }}
      >
        {t('ui_all_cards_seen')}
      </div>
      <button
        onClick={onShuffle}
        style={{
          padding: '14px 32px',
          borderRadius: 999,
          background: rgb(theme.accentColor),
          color: themeKey === 'halloween' ? '#fff' : rgb(theme.cardTextColor),
          fontFamily: FONT_FAMILY[theme.fontDesign],
          fontWeight: 600,
          fontSize: 16,
        }}
      >
        {t('ui_shuffle_again')}
      </button>
    </div>
  );
}
