import type { CSSProperties } from 'react';

// SF Symbol 이름 → remixicon 클래스(ri-*) 또는 이모지 폴백.
// 'ri-' 로 시작하면 아이콘 폰트, 아니면 텍스트(이모지)로 렌더.
const MAP: Record<string, string> = {
  // shapes / generic
  'circle.fill': 'ri-circle-fill',
  'star.fill': 'ri-star-fill',
  'star.circle.fill': 'ri-star-fill',
  'triangle.fill': 'ri-triangle-fill',
  'diamond.fill': 'ri-vip-diamond-fill',
  sparkles: 'ri-sparkling-2-fill',
  sparkle: 'ri-sparkling-fill',
  'wand.and.stars': 'ri-magic-fill',

  // nature / weather
  'leaf.fill': 'ri-leaf-fill',
  snowflake: '❄️',
  wind: 'ri-windy-fill',
  'sun.max.fill': 'ri-sun-fill',
  'sun.max': 'ri-sun-line',
  'sunset.fill': 'ri-sun-fill',
  'water.waves': '🌊',
  'cloud.fill': 'ri-cloudy-fill',
  'cloud.rain.fill': 'ri-rainy-fill',
  'cloud.moon.fill': 'ri-moon-cloudy-fill',
  'moon.fill': 'ri-moon-fill',
  'moon.stars.fill': 'ri-moon-clear-fill',
  'moonphase.waxing.gibbous': 'ri-moon-fill',
  'fish.fill': '🐟',
  'mountain.2.fill': '⛰️',
  'camera.macro': '🌼',
  'flower.fill': '🌼',

  // people
  'person.2.fill': 'ri-group-fill',
  'person.2.circle.fill': 'ri-group-fill',
  'person.2.wave.2.fill': 'ri-group-fill',
  'person.fill.questionmark': 'ri-user-3-fill',
  'figure.walk': 'ri-walk-fill',
  'figure.2.and.child.holdinghands': '👨‍👩‍👧',
  'hand.wave.fill': '👋',
  'hands.clap.fill': '👏',
  'stroller.fill': '🍼',

  // objects
  'rectangle.stack.fill': 'ri-stack-fill',
  'heart.fill': 'ri-heart-fill',
  'heart.circle.fill': 'ri-heart-3-fill',
  'bolt.heart.fill': 'ri-heart-pulse-fill',
  'house.fill': 'ri-home-5-fill',
  'briefcase.fill': 'ri-briefcase-fill',
  airplane: 'ri-flight-takeoff-fill',
  'arrow.left.arrow.right.circle.fill': 'ri-arrow-left-right-line',
  'arrow.forward.circle.fill': 'ri-arrow-right-circle-fill',
  'arrow.up.arrow.down.circle.fill': 'ri-arrow-up-down-line',
  fireworks: '🎆',
  'flame.fill': 'ri-fire-fill',
  'book.fill': 'ri-book-2-fill',
  'book.closed.fill': 'ri-book-fill',
  'photo.fill': 'ri-image-fill',
  'bubble.left.fill': 'ri-chat-3-fill',
  'eye.fill': 'ri-eye-fill',
  'checkmark.seal.fill': 'ri-verified-badge-fill',
  'mic.fill': 'ri-mic-fill',
  'map.fill': 'ri-map-2-fill',
  'gift.fill': 'ri-gift-fill',
  bicycle: 'ri-bike-fill',
  laptopcomputer: 'ri-macbook-line',
  'flag.fill': 'ri-flag-fill',
  'flag.checkered': 'ri-flag-2-fill',
  'camera.fill': 'ri-camera-fill',
  'list.star': 'ri-list-check',
  'questionmark.bubble.fill': 'ri-question-answer-fill',
  'theatermasks.fill': '🎭',
  'brain.head.profile': 'ri-brain-line',
  'envelope.fill': 'ri-mail-fill',
  'tortoise.fill': '🐢',
  'bolt.fill': 'ri-flashlight-fill',
  'dice.fill': 'ri-dice-fill',
  'exclamationmark.circle.fill': 'ri-error-warning-fill',
  'calendar.circle.fill': 'ri-calendar-fill',
  'building.columns.fill': 'ri-bank-fill',
  'building.2.fill': 'ri-building-fill',
  'lock.fill': 'ri-lock-fill',
  'square.on.square': 'ri-stack-line',
  'gamecontroller.fill': 'ri-gamepad-fill',
  'birthday.cake.fill': 'ri-cake-3-fill',
  'scroll.fill': '📜',

  // UI
  'paintpalette.fill': 'ri-palette-fill',
  shuffle: 'ri-shuffle-line',
  xmark: 'ri-close-line',
};

interface IconProps {
  name: string;
  size?: number;
  color?: string;
  style?: CSSProperties;
  className?: string;
}

export function Icon({ name, size = 16, color, style, className }: IconProps) {
  const mapped = MAP[name] ?? 'ri-checkbox-blank-circle-fill';
  const base: CSSProperties = {
    fontSize: size,
    lineHeight: 1,
    color,
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    ...style,
  };
  if (mapped.startsWith('ri-')) {
    return <i className={`${mapped} ${className ?? ''}`} style={base} aria-hidden />;
  }
  // 이모지 폴백
  return (
    <span className={className} style={base} aria-hidden>
      {mapped}
    </span>
  );
}
