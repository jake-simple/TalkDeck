import { useEffect, useRef } from 'react';
import type { Theme, ThemeKey } from '../theme/types';

/**
 * Canvas-based animated background ported from the SwiftUI `AnimatedBackgroundView`
 * (IceDeck/Views/ThemeParticleScene.swift). Each theme maps to a per-frame draw
 * routine that reproduces the original counts / sizes / speeds / colors / opacities.
 *
 * The Swift version drives drawing from `timeline.date.timeIntervalSinceReferenceDate`
 * (an absolute, ever-increasing seconds value). Here we use an elapsed-seconds clock
 * derived from `performance.now()`, which keeps the same sin/fmod motion character.
 */

// fmod that matches Swift/C `fmod` (truncated remainder, sign follows dividend).
// For the non-negative dividends used throughout this file it equals `a % b`.
function fmod(a: number, b: number): number {
  return a % b;
}

// rgba string from 0..1 floats (mirrors lib/colors `rgba`, inlined for hot loops).
function col(r: number, g: number, b: number, a: number): string {
  return `rgba(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(
    b * 255,
  )}, ${a})`;
}

type DrawFn = (
  ctx: CanvasRenderingContext2D,
  w: number,
  h: number,
  t: number,
) => void;

const PI = Math.PI;

/* ------------------------------------------------------------------ */
/* Halloween — will-o'-wisps + drifting mist                           */
/* ------------------------------------------------------------------ */
const drawHalloween: DrawFn = (ctx, w, h, t) => {
  for (let i = 0; i < 12; i++) {
    const seed = i * 137.5;
    const x = (Math.sin(t * 0.3 + seed) * 0.5 + 0.5) * w;
    const baseY = (i / 12) * h;
    const y = baseY + Math.sin(t * 0.5 + seed * 0.7) * 35;
    const radius = 8 + (i % 4) * 4;
    const opacity = 0.09 + Math.sin(t * 0.8 + seed) * 0.04;

    ctx.fillStyle = col(1, 0.55, 0, opacity); // orange
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();

    const glowR = radius * 2.8;
    ctx.fillStyle = col(1, 0.55, 0, opacity * 0.25);
    ctx.beginPath();
    ctx.arc(x, y, glowR, 0, PI * 2);
    ctx.fill();

    if (i % 3 === 0) {
      const coreR = radius * 0.4;
      ctx.fillStyle = col(0.65, 0.0, 0.65, opacity * 0.5); // purple
      ctx.beginPath();
      ctx.arc(x, y, coreR, 0, PI * 2);
      ctx.fill();
    }
  }

  for (let i = 0; i < 3; i++) {
    const seed = i * 97.3;
    const x = w * (0.2 + i * 0.3);
    const y = h * (0.7 + i * 0.08);
    const drift = Math.sin(t * 0.15 + seed) * 30;
    const r = 60 + Math.sin(t * 0.2 + seed) * 10;
    ctx.fillStyle = col(0.65, 0.0, 0.65, 0.03);
    ctx.beginPath();
    ctx.ellipse(x + drift, y, r, r * 0.3, 0, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Christmas — snowflakes, snow dust, colorful twinkles                */
/* ------------------------------------------------------------------ */
const SNOW_COLORS: [number, number, number][] = [
  [1, 1, 1],
  [1.0, 0.95, 0.7],
  [1.0, 0.7, 0.8],
  [0.6, 0.8, 1.0],
  [1.0, 0.6, 0.3],
  [0.8, 1.0, 0.7],
  [0.85, 0.15, 0.15],
];

const drawSnowfall: DrawFn = (ctx, w, h, t) => {
  // Crystalline snowflakes
  for (let i = 0; i < 10; i++) {
    const seed = i * 73.1;
    const x = (i / 10) * w + Math.sin(t * 0.12 + seed) * 65;
    const fallSpeed = 10 + fmod(seed * 11.3, 15);
    const y = fmod(t * fallSpeed + seed * 47.1, h + 50) - 25;
    const radius = 7 + fmod(seed * 2.3, 8);
    const opacity = 0.22 + fmod(seed * 0.11, 0.12);
    const rotation = t * 0.2 + seed;

    ctx.globalAlpha = opacity;
    ctx.strokeStyle = col(1, 1, 1, 1);
    for (let arm = 0; arm < 6; arm++) {
      const angle = (arm * PI) / 3 + rotation;
      const endX = x + Math.cos(angle) * radius;
      const endY = y + Math.sin(angle) * radius;
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(x, y);
      ctx.lineTo(endX, endY);
      ctx.stroke();

      const midX = x + Math.cos(angle) * radius * 0.55;
      const midY = y + Math.sin(angle) * radius * 0.55;
      for (const sign of [-1, 1]) {
        const bAngle = angle + (sign * PI) / 5;
        const bl = radius * 0.38;
        ctx.lineWidth = 0.9;
        ctx.beginPath();
        ctx.moveTo(midX, midY);
        ctx.lineTo(midX + Math.cos(bAngle) * bl, midY + Math.sin(bAngle) * bl);
        ctx.stroke();
      }
    }
    ctx.fillStyle = col(1, 1, 1, 1);
    ctx.beginPath();
    ctx.arc(x, y, 2, 0, PI * 2);
    ctx.fill();
    ctx.globalAlpha = 1;
  }

  // Snow dust
  for (let i = 0; i < 20; i++) {
    const seed = i * 97.3;
    const x = (i / 20) * w + Math.sin(t * 0.2 + seed) * 35;
    const fallSpeed = 20 + fmod(seed * 17.3, 28);
    const y = fmod(t * fallSpeed + seed * 53.1, h + 20) - 10;
    const radius = 2 + fmod(seed * 3.7, 4);
    const opacity = 0.15 + fmod(seed * 0.13, 0.1);
    ctx.fillStyle = col(1, 1, 1, opacity);
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();
  }

  // Colorful twinkling particles
  for (let i = 0; i < 25; i++) {
    const seed = i * 53.7;
    const ci = Math.floor(fmod(seed * 3.1, SNOW_COLORS.length));
    const c = SNOW_COLORS[ci];
    const x = (i / 25) * w + Math.sin(t * 0.15 + seed * 0.8) * 50;
    const fallSpeed = 12 + fmod(seed * 9.7, 18);
    const y = fmod(t * fallSpeed + seed * 31.9, h + 40) - 20;
    const baseSize = 3 + fmod(seed * 2.9, 5);
    const twinkle = (Math.sin(t * 2.5 + seed * 4.3) + 1) * 0.5;
    const finalSize = baseSize * (0.7 + twinkle * 0.3);
    const opacity = 0.25 + twinkle * 0.3;

    const glowR = finalSize * 2.2;
    ctx.fillStyle = col(c[0], c[1], c[2], opacity * 0.25);
    ctx.beginPath();
    ctx.arc(x, y, glowR, 0, PI * 2);
    ctx.fill();

    ctx.fillStyle = col(c[0], c[1], c[2], opacity);
    ctx.beginPath();
    ctx.arc(x, y, finalSize, 0, PI * 2);
    ctx.fill();

    ctx.fillStyle = col(1, 1, 1, opacity * 0.6);
    ctx.beginPath();
    ctx.arc(x, y, finalSize * 0.4, 0, PI * 2);
    ctx.fill();
  }

  // Sparkle crosses
  for (let i = 0; i < 6; i++) {
    const seed = i * 137.5;
    const x = (i / 6) * w + Math.sin(seed) * w * 0.06;
    const y = (i / 6) * h * 0.6 + Math.sin(seed * 1.7) * h * 0.1;
    const twinkle = (Math.sin(t * 2 + seed * 3.1) + 1) * 0.5;
    const s = 3 + twinkle * 4;
    const opacity = 0.12 + twinkle * 0.2;
    ctx.strokeStyle = col(1.0, 0.95, 0.7, opacity);
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(x - s, y);
    ctx.lineTo(x + s, y);
    ctx.moveTo(x, y - s);
    ctx.lineTo(x, y + s);
    ctx.stroke();
  }
};

/* ------------------------------------------------------------------ */
/* Space — twinkling stars, milky way, meteors                         */
/* ------------------------------------------------------------------ */
const STAR_COLORS: [number, number, number][] = [
  [1, 1, 1],
  [0.8, 0.85, 1.0],
  [1.0, 0.95, 0.8],
  [0.7, 0.8, 1.0],
];

const drawSpace: DrawFn = (ctx, w, h, t) => {
  for (let i = 0; i < 45; i++) {
    const cols = 9;
    const rows = 5;
    const c = i % cols;
    const r = Math.floor(i / cols);
    const cellW = w / cols;
    const cellH = h / rows;
    const seed = i * 67.3;
    const offsetX = fmod(seed * 17.3, cellW * 0.8) + cellW * 0.1;
    const offsetY = fmod(seed * 23.1, cellH * 0.8) + cellH * 0.1;
    const x = c * cellW + offsetX;
    const y = r * cellH + offsetY;
    const twinkle = Math.sin(t * (1.5 + fmod(seed * 0.1, 2)) + seed) * 0.5 + 0.5;
    const radius = 1 + fmod(seed * 1.3, 2.2);
    const opacity = 0.1 + twinkle * 0.22;
    const color = STAR_COLORS[i % STAR_COLORS.length];

    ctx.fillStyle = col(color[0], color[1], color[2], opacity);
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();

    if (i < 10) {
      const sparkSize = radius + twinkle * 4;
      ctx.strokeStyle = col(color[0], color[1], color[2], opacity * 0.35);
      ctx.lineWidth = 0.6;
      ctx.beginPath();
      ctx.moveTo(x - sparkSize, y);
      ctx.lineTo(x + sparkSize, y);
      ctx.moveTo(x, y - sparkSize);
      ctx.lineTo(x, y + sparkSize);
      ctx.stroke();
    }
  }

  // Milky way band
  ctx.beginPath();
  for (let x = 0; x <= w; x += 3) {
    const y =
      h * 0.45 + Math.sin(x * 0.008 + t * 0.1) * 35 + Math.cos(x * 0.015) * 20;
    if (x === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  }
  ctx.strokeStyle = col(0.5, 0.4, 0.8, 0.04);
  ctx.lineWidth = 30;
  ctx.stroke();
  ctx.strokeStyle = col(0.6, 0.5, 0.9, 0.025);
  ctx.lineWidth = 60;
  ctx.stroke();

  // Meteors
  for (let i = 0; i < 4; i++) {
    const seed = i * 193.7;
    const duration = 2.5 + fmod(seed * 0.3, 1.5);
    const progress = fmod(t * 0.6 + seed * 0.7, duration) / duration;
    const startX = (i / 4) * w * 0.7 + w * 0.1 + Math.sin(seed) * 20;
    const startY = fmod(seed * 19.3, h * 0.25);
    const length = 100 + fmod(seed * 11.3, 60);
    const endX = startX + length;
    const endY = startY + length * 0.65;
    const cx = startX + (endX - startX) * progress;
    const cy = startY + (endY - startY) * progress;
    const tailLen = 35 + fmod(seed * 3.7, 25);
    const fade = 1 - progress;

    ctx.strokeStyle = col(1, 1, 1, 0.2 * fade);
    ctx.lineWidth = 1.2;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(cx - tailLen, cy - tailLen * 0.65);
    ctx.stroke();

    ctx.fillStyle = col(1, 1, 1, 0.35 * fade);
    ctx.beginPath();
    ctx.arc(cx, cy, 2, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Cherry Blossom — falling petals                                     */
/* ------------------------------------------------------------------ */
const drawCherryBlossom: DrawFn = (ctx, w, h, t) => {
  const pink: [number, number, number] = [1.0, 0.65, 0.75];
  const lightPink: [number, number, number] = [1.0, 0.8, 0.85];

  for (let i = 0; i < 15; i++) {
    const seed = i * 113.7;
    const baseX = (i / 15) * w + Math.sin(seed * 2.1) * w * 0.04;
    const fallSpeed = 12 + fmod(seed * 11.3, 20);
    const y = fmod(t * fallSpeed + seed * 53.7, h + 45) - 22;
    const drift =
      Math.sin(t * 0.3 + seed) * 40 + Math.cos(t * 0.18 + seed * 0.7) * 18;
    const x = baseX + drift;
    const rotation = t * 0.35 + seed;
    const scale = 1.1 + fmod(seed * 0.3, 1);
    const c = i % 3 === 0 ? lightPink : pink;
    const opacity = 0.15 + fmod(seed * 0.03, 0.08);

    ctx.save();
    ctx.globalAlpha = opacity;
    ctx.translate(x, y);
    ctx.rotate(rotation);
    ctx.scale(scale, scale);
    ctx.fillStyle = col(c[0], c[1], c[2], 1);
    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.quadraticCurveTo(6, 5, 0, 10);
    ctx.quadraticCurveTo(-4, 5, 0, 0);
    ctx.fill();
    ctx.restore();
  }

  for (let i = 0; i < 6; i++) {
    const seed = i * 179.3;
    const x = (i / 6) * w + fmod(t * 10 + seed, 40) - 20;
    const y = fmod(seed * 29.3, h * 0.5) + Math.sin(t * 0.5 + seed) * 22;
    const r = 3 + fmod(seed * 1.1, 3);
    ctx.fillStyle = col(pink[0], pink[1], pink[2], 0.1);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Retro Game — scrolling grid, rising blocks, blinking cursor         */
/* ------------------------------------------------------------------ */
const drawRetro: DrawFn = (ctx, w, h, t) => {
  const g: [number, number, number] = [0.1, 0.95, 0.4];
  const gridSpacing = 40;
  const scrollOffset = fmod(t * 15, gridSpacing);

  ctx.strokeStyle = col(g[0], g[1], g[2], 0.05);
  ctx.lineWidth = 0.7;
  for (let x = -gridSpacing; x <= w + gridSpacing; x += gridSpacing) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, h);
    ctx.stroke();
  }
  for (let y = -gridSpacing + scrollOffset; y <= h + gridSpacing; y += gridSpacing) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(w, y);
    ctx.stroke();
  }

  for (let i = 0; i < 7; i++) {
    const seed = i * 79.3;
    const x = (i / 7) * w + Math.sin(seed * 1.3) * w * 0.05;
    const speed = 10 + fmod(seed * 13.1, 20);
    const y = h - fmod(t * speed + seed * 37.3, h + 30) + 15;
    const blockSize = 6 + (i % 3) * 3;
    ctx.fillStyle = col(g[0], g[1], g[2], 0.12);
    ctx.fillRect(x, y, blockSize, blockSize);
  }

  if (Math.sin(t * 3) > 0) {
    ctx.fillStyle = col(g[0], g[1], g[2], 0.16);
    ctx.fillRect(w * 0.1, h * 0.85, 10, 3);
  }
};

/* ------------------------------------------------------------------ */
/* Autumn — maple leaves + warm glow                                   */
/* ------------------------------------------------------------------ */
const AUTUMN_COLORS: [number, number, number][] = [
  [0.85, 0.45, 0.15],
  [0.8, 0.3, 0.1],
  [0.9, 0.65, 0.2],
  [0.75, 0.25, 0.15],
];

const drawAutumn: DrawFn = (ctx, w, h, t) => {
  for (let i = 0; i < 12; i++) {
    const seed = i * 127.3;
    const baseX = (i / 12) * w + Math.sin(seed * 1.7) * w * 0.04;
    const fallSpeed = 10 + fmod(seed * 9.7, 18);
    const y = fmod(t * fallSpeed + seed * 41.3, h + 35) - 18;
    const drift =
      Math.sin(t * 0.2 + seed) * 35 + Math.cos(t * 0.12 + seed * 0.5) * 16;
    const x = baseX + drift;
    const rotation = t * 0.3 + seed;
    const c = AUTUMN_COLORS[i % AUTUMN_COLORS.length];
    const scale = 1.2 + fmod(seed * 0.2, 0.9);

    ctx.save();
    ctx.globalAlpha = 0.16;
    ctx.translate(x, y);
    ctx.rotate(rotation);
    ctx.scale(scale, scale);
    ctx.fillStyle = col(c[0], c[1], c[2], 1);

    if (i % 3 === 0) {
      ctx.beginPath();
      for (let arm = 0; arm < 5; arm++) {
        const angle = (arm * PI * 2) / 5 - PI / 2;
        const tipX = Math.cos(angle) * 7;
        const tipY = Math.sin(angle) * 7;
        if (arm === 0) ctx.moveTo(tipX, tipY);
        else ctx.lineTo(tipX, tipY);
        const innerAngle = angle + PI / 5;
        ctx.lineTo(Math.cos(innerAngle) * 3, Math.sin(innerAngle) * 3);
      }
      ctx.closePath();
      ctx.fill();
    } else {
      ctx.beginPath();
      ctx.moveTo(0, -7);
      ctx.quadraticCurveTo(8, 0, 0, 7);
      ctx.quadraticCurveTo(-8, 0, 0, -7);
      ctx.fill();
    }
    ctx.restore();
  }

  for (let i = 0; i < 4; i++) {
    const seed = i * 193.7;
    const x = (i / 4) * w + Math.sin(seed * 1.5) * w * 0.08;
    const y = (i / 4) * h * 0.4 + h * 0.1;
    const r = 40 + fmod(seed * 7.1, 35);
    const pulse = Math.sin(t * 0.3 + seed) * 0.012;
    ctx.fillStyle = col(0.95, 0.75, 0.3, 0.03 + pulse);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Aurora — layered wave curtains + stars                              */
/* ------------------------------------------------------------------ */
const AURORA_BANDS: [[number, number, number], number][] = [
  [[0.1, 0.9, 0.5], 0.08],
  [[0.3, 0.5, 0.9], 0.07],
  [[0.7, 0.2, 0.8], 0.055],
  [[0.2, 0.8, 0.7], 0.045],
];

const drawAurora: DrawFn = (ctx, w, h, t) => {
  AURORA_BANDS.forEach(([c, opacity], idx) => {
    const baseY = h * (0.1 + idx * 0.13);
    ctx.beginPath();
    let first = true;
    for (let x = 0; x <= w; x += 3) {
      const wave1 = Math.sin(x * 0.008 + t * 0.3 + idx * 2) * 50;
      const wave2 = Math.sin(x * 0.015 + t * 0.5 + idx * 1.5) * 25;
      const wave3 = Math.cos(x * 0.005 + t * 0.2 + idx) * 15;
      const y = baseY + wave1 + wave2 + wave3;
      if (first) {
        ctx.moveTo(x, y);
        first = false;
      } else ctx.lineTo(x, y);
    }
    ctx.lineTo(w, h);
    ctx.lineTo(0, h);
    ctx.closePath();
    ctx.fillStyle = col(c[0], c[1], c[2], opacity);
    ctx.fill();
  });

  for (let i = 0; i < 25; i++) {
    const c = i % 5;
    const r0 = Math.floor(i / 5);
    const cellW = w / 5;
    const cellH = (h * 0.4) / 5;
    const seed = i * 71.3;
    const x = c * cellW + fmod(seed * 17.1, cellW);
    const y = r0 * cellH + fmod(seed * 23.7, cellH);
    const twinkle = Math.sin(t * 2 + seed) * 0.5 + 0.5;
    const r = 1 + fmod(seed, 1.8);
    ctx.fillStyle = col(1, 1, 1, 0.1 + twinkle * 0.18);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Circus — spotlights + confetti (stars / circles / rects)            */
/* ------------------------------------------------------------------ */
const CONFETTI_COLORS: [number, number, number][] = [
  [1, 0, 0], // red
  [1, 1, 0], // yellow
  [0, 0, 1], // blue
  [0, 0.8, 0], // green
  [1, 0.5, 0], // orange
  [1, 0.75, 0.8], // pink
];
const BEAM_COLORS: [number, number, number][] = [
  [1, 1, 0],
  [1, 1, 1],
  [1, 0, 0],
];

const drawCircus: DrawFn = (ctx, w, h, t) => {
  for (let i = 0; i < 3; i++) {
    const seed = i * 131.7;
    const baseX = w * (0.2 + i * 0.3);
    const sway = Math.sin(t * 0.4 + seed) * 35;
    const beamWidth = 70;
    const bc = BEAM_COLORS[i];
    ctx.fillStyle = col(bc[0], bc[1], bc[2], 0.02);
    ctx.beginPath();
    ctx.moveTo(baseX + sway - 6, 0);
    ctx.lineTo(baseX + sway + 6, 0);
    ctx.lineTo(baseX + sway + beamWidth, h);
    ctx.lineTo(baseX + sway - beamWidth, h);
    ctx.closePath();
    ctx.fill();
  }

  for (let i = 0; i < 18; i++) {
    const seed = i * 103.7;
    const x = (i / 18) * w + Math.sin(seed * 1.9) * w * 0.04;
    const fallSpeed = 15 + fmod(seed * 7.7, 20);
    const y = fmod(t * fallSpeed + seed * 59.3, h + 20) - 10;
    const rotation = t * 1.5 + seed;
    const c = CONFETTI_COLORS[i % CONFETTI_COLORS.length];

    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rotation);

    if (i % 3 === 0) {
      const starSize = 5 + (i % 3);
      ctx.fillStyle = col(c[0], c[1], c[2], 0.16);
      ctx.beginPath();
      for (let arm = 0; arm < 5; arm++) {
        const angle = (arm * PI * 2) / 5 - PI / 2;
        if (arm === 0)
          ctx.moveTo(Math.cos(angle) * starSize, Math.sin(angle) * starSize);
        else ctx.lineTo(Math.cos(angle) * starSize, Math.sin(angle) * starSize);
        const innerAngle = angle + PI / 5;
        ctx.lineTo(
          Math.cos(innerAngle) * starSize * 0.4,
          Math.sin(innerAngle) * starSize * 0.4,
        );
      }
      ctx.closePath();
      ctx.fill();
    } else if (i % 3 === 1) {
      const r = 3 + (i % 3);
      ctx.fillStyle = col(c[0], c[1], c[2], 0.14);
      ctx.beginPath();
      ctx.arc(0, 0, r, 0, PI * 2);
      ctx.fill();
    } else {
      const bw = 4 + (i % 3);
      const bh = 7 + (i % 4);
      ctx.fillStyle = col(c[0], c[1], c[2], 0.14);
      ctx.fillRect(-bw / 2, -bh / 2, bw, bh);
    }
    ctx.restore();
  }
};

/* ------------------------------------------------------------------ */
/* Desert — dunes, blowing sand, moon, stars, heat haze                */
/* ------------------------------------------------------------------ */
const drawDesert: DrawFn = (ctx, w, h, t) => {
  const sand: [number, number, number] = [0.9, 0.75, 0.35];
  const moon: [number, number, number] = [0.95, 0.9, 0.7];

  for (let dune = 0; dune < 4; dune++) {
    const baseY = h * (0.62 + dune * 0.08);
    const offset = dune * 50;
    const drift = Math.sin(t * 0.05 + offset) * 8;
    ctx.beginPath();
    ctx.moveTo(0, h);
    for (let x = 0; x <= w; x += 3) {
      const y =
        baseY +
        Math.sin(x * 0.007 + offset + drift) * 30 +
        Math.cos(x * 0.013 + offset) * 18;
      ctx.lineTo(x, y);
    }
    ctx.lineTo(w, h);
    ctx.closePath();
    ctx.fillStyle = col(sand[0], sand[1], sand[2], 0.045 - dune * 0.008);
    ctx.fill();
  }

  for (let i = 0; i < 20; i++) {
    const seed = i * 89.3;
    const baseY = fmod(seed * 37.7, h);
    const speed = 10 + fmod(seed * 5.3, 18);
    const x = fmod(t * speed + seed * 43.1, w + 20) - 10;
    const y = baseY + Math.sin(t * 0.4 + seed) * 9;
    const r = 1.2 + fmod(seed * 1.7, 2.5);
    ctx.fillStyle = col(sand[0], sand[1], sand[2], 0.08);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();
  }

  const mx = w * 0.78;
  const my = h * 0.1;
  ctx.fillStyle = col(moon[0], moon[1], moon[2], 0.02);
  ctx.beginPath();
  ctx.arc(mx, my, 65, 0, PI * 2);
  ctx.fill();
  ctx.fillStyle = col(moon[0], moon[1], moon[2], 0.04);
  ctx.beginPath();
  ctx.arc(mx, my, 45, 0, PI * 2);
  ctx.fill();
  ctx.fillStyle = col(moon[0], moon[1], moon[2], 0.1);
  ctx.beginPath();
  ctx.arc(mx, my, 28, 0, PI * 2);
  ctx.fill();
  ctx.fillStyle = col(moon[0], moon[1], moon[2], 0.04);
  ctx.beginPath();
  ctx.ellipse(mx - 3, my - 2, 5, 4, 0, 0, PI * 2);
  ctx.fill();
  ctx.fillStyle = col(moon[0], moon[1], moon[2], 0.03);
  ctx.beginPath();
  ctx.ellipse(mx + 8.5, my + 7, 3.5, 3, 0, 0, PI * 2);
  ctx.fill();

  for (let i = 0; i < 30; i++) {
    const cols = 6;
    const rows = 5;
    const c = i % cols;
    const r0 = Math.floor(i / cols);
    const cellW = w / cols;
    const cellH = (h * 0.5) / rows;
    const seed = i * 61.7;
    const x = c * cellW + fmod(seed * 17.3, cellW);
    const y = r0 * cellH + fmod(seed * 27.1, cellH);
    const twinkle =
      Math.sin(t * (1.2 + fmod(seed * 0.07, 1.5)) + seed) * 0.5 + 0.5;
    const r = 1 + fmod(seed * 0.9, 1.5);
    ctx.fillStyle = col(1, 1, 1, 0.08 + twinkle * 0.14);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();

    if (i < 6) {
      const s = r + twinkle * 3;
      ctx.strokeStyle = col(1, 1, 1, 0.06 + twinkle * 0.1);
      ctx.lineWidth = 0.7;
      ctx.beginPath();
      ctx.moveTo(x - s, y);
      ctx.lineTo(x + s, y);
      ctx.moveTo(x, y - s);
      ctx.lineTo(x, y + s);
      ctx.stroke();
    }
  }

  for (let i = 0; i < 3; i++) {
    const seed = i * 157.3;
    const x = w * (0.2 + i * 0.3);
    const y = h * 0.65;
    const shimmer = Math.sin(t * 0.8 + seed) * 5;
    const r = 40;
    ctx.fillStyle = col(sand[0], sand[1], sand[2], 0.025);
    ctx.beginPath();
    ctx.ellipse(x, y + shimmer, r, r * 0.3, 0, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Candy — lollipops & candies + colorful sparkles                     */
/* ------------------------------------------------------------------ */
const CANDY_COLORS: [number, number, number][] = [
  [0.95, 0.35, 0.55],
  [0.55, 0.85, 0.75],
  [0.98, 0.8, 0.25],
  [0.65, 0.5, 0.9],
  [0.95, 0.55, 0.35],
];

const drawCandy: DrawFn = (ctx, w, h, t) => {
  for (let i = 0; i < 8; i++) {
    const seed = i * 127.3;
    const x = (i / 8) * w + Math.sin(t * 0.25 + seed) * 22;
    const floatSpeed = 8 + fmod(seed * 6.3, 12);
    const y = h - fmod(t * floatSpeed + seed * 43.7, h + 45) + 22;
    const c = CANDY_COLORS[i % CANDY_COLORS.length];
    const rotation = t * 0.25 + seed;

    ctx.save();
    ctx.globalAlpha = 0.12;
    if (i % 2 === 0) {
      const lolliR = 9 + (i % 3) * 3;
      ctx.fillStyle = col(c[0], c[1], c[2], 1);
      ctx.beginPath();
      ctx.arc(x, y, lolliR, 0, PI * 2);
      ctx.fill();
      ctx.strokeStyle = col(1, 1, 1, 1);
      ctx.lineWidth = 1.2;
      ctx.beginPath();
      ctx.arc(x, y, lolliR * 0.5, 0, (270 * PI) / 180);
      ctx.stroke();
      ctx.strokeStyle = col(0.6, 0.4, 0.2, 0.5); // brown
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(x, y + lolliR);
      ctx.lineTo(x, y + lolliR + 16);
      ctx.stroke();
    } else {
      ctx.translate(x, y);
      ctx.rotate(rotation);
      ctx.fillStyle = col(c[0], c[1], c[2], 1);
      ctx.beginPath();
      ctx.ellipse(0, 0, 8, 5, 0, 0, PI * 2);
      ctx.fill();
    }
    ctx.restore();
  }

  for (let i = 0; i < 8; i++) {
    const seed = i * 89.1;
    const x = (i / 8) * w + Math.sin(seed * 2.1) * w * 0.05;
    const y = (i / 8) * h * 0.8 + Math.sin(seed * 1.3) * h * 0.08;
    const twinkle = (Math.sin(t * 2.5 + seed * 2.1) + 1) * 0.5;
    const s = 2.5 + twinkle * 3;
    const c = CANDY_COLORS[i % CANDY_COLORS.length];
    ctx.strokeStyle = col(c[0], c[1], c[2], 0.12 + twinkle * 0.12);
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(x - s, y);
    ctx.lineTo(x + s, y);
    ctx.moveTo(x, y - s);
    ctx.lineTo(x, y + s);
    ctx.stroke();
  }
};

/* ------------------------------------------------------------------ */
/* Zen Garden — raked ripples, drifting leaf, slow mist                */
/* ------------------------------------------------------------------ */
const drawZenGarden: DrawFn = (ctx, w, h, t) => {
  const stone: [number, number, number] = [0.45, 0.48, 0.42];
  const centers: [number, number][] = [
    [w * 0.3, h * 0.3],
    [w * 0.7, h * 0.65],
  ];
  for (const [cx, cy] of centers) {
    for (let ring = 0; ring < 6; ring++) {
      const baseR = 25 + ring * 20;
      const ripple = Math.sin(t * 0.25 - ring * 0.4) * 3.5;
      const r = baseR + ripple;
      ctx.strokeStyle = col(
        stone[0],
        stone[1],
        stone[2],
        Math.max(0, 0.055 - ring * 0.006),
      );
      ctx.lineWidth = 0.8;
      ctx.beginPath();
      ctx.ellipse(cx, cy, r, r * 0.6, 0, 0, PI * 2);
      ctx.stroke();
    }
  }

  const leafX = w * 0.6 + Math.sin(t * 0.12) * 35;
  const leafY = h * 0.2 + Math.cos(t * 0.08) * 12;
  ctx.save();
  ctx.globalAlpha = 0.1;
  ctx.translate(leafX, leafY);
  ctx.rotate(t * 0.08);
  ctx.fillStyle = col(0.4, 0.55, 0.35, 1);
  ctx.beginPath();
  ctx.moveTo(0, -11);
  ctx.quadraticCurveTo(11, 0, 0, 11);
  ctx.quadraticCurveTo(-11, 0, 0, -11);
  ctx.fill();
  ctx.restore();

  for (let i = 0; i < 5; i++) {
    const seed = i * 151.3;
    const x = fmod((i / 5) * w + t * 2 + Math.sin(seed) * 30, w);
    const y = (i / 5) * h + Math.sin(seed * 1.5) * h * 0.08;
    const r = 28 + fmod(seed * 3.1, 25);
    const opacity = 0.025 + Math.sin(t * 0.3 + seed) * 0.012;
    ctx.fillStyle = col(1, 1, 1, Math.max(0, opacity));
    ctx.beginPath();
    ctx.ellipse(x, y, r, r * 0.5, 0, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Forsythia — falling petals, floating blossoms, soft orbs            */
/* ------------------------------------------------------------------ */
const drawForsythia: DrawFn = (ctx, w, h, t) => {
  const yellow: [number, number, number] = [0.98, 0.85, 0.08];
  const darkYellow: [number, number, number] = [0.85, 0.65, 0.08];

  for (let i = 0; i < 14; i++) {
    const seed = i * 109.3;
    const baseX = (i / 14) * w + Math.sin(seed * 2.3) * w * 0.04;
    const fallSpeed = 12 + fmod(seed * 8.7, 16);
    const y = fmod(t * fallSpeed + seed * 47.1, h + 35) - 18;
    const drift = Math.sin(t * 0.3 + seed) * 30;
    const x = baseX + drift;
    const rotation = t * 0.35 + seed;

    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rotation);
    ctx.fillStyle = col(yellow[0], yellow[1], yellow[2], 0.18);
    ctx.beginPath();
    ctx.ellipse(0, 0, 6, 4, 0, 0, PI * 2);
    ctx.fill();
    ctx.restore();
  }

  for (let i = 0; i < 5; i++) {
    const seed = i * 193.7;
    const x = (i / 5) * w + Math.sin(seed * 1.8) * w * 0.06;
    const floatSpeed = 6 + fmod(seed * 5.1, 8);
    const y = h - fmod(t * floatSpeed + seed * 37.1, h + 45) + 22;
    const cx = x + Math.sin(t * 0.2 + seed) * 18;
    const petalR = 8;
    for (let p = 0; p < 6; p++) {
      const angle = (p * PI) / 3 + (t * 0.25 + seed);
      const px = cx + Math.cos(angle) * petalR;
      const py = y + Math.sin(angle) * petalR;
      ctx.fillStyle = col(yellow[0], yellow[1], yellow[2], 0.15);
      ctx.beginPath();
      ctx.ellipse(px, py, 4, 2.5, 0, 0, PI * 2);
      ctx.fill();
    }
    ctx.fillStyle = col(darkYellow[0], darkYellow[1], darkYellow[2], 0.15);
    ctx.beginPath();
    ctx.arc(cx, y, 3, 0, PI * 2);
    ctx.fill();
  }

  for (let i = 0; i < 6; i++) {
    const seed = i * 157.3;
    const x = (Math.sin(t * 0.2 + seed) * 0.5 + 0.5) * w;
    const baseY = (i / 6) * h;
    const y = baseY + Math.sin(t * 0.4 + seed * 0.6) * 22;
    const radius = 14 + (i % 3) * 8;
    const opacity = 0.06 + Math.sin(t * 0.6 + seed) * 0.03;
    ctx.fillStyle = col(yellow[0], yellow[1], yellow[2], Math.max(0, opacity));
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Ocean — layered waves, rising bubbles, light rays                   */
/* ------------------------------------------------------------------ */
const drawOcean: DrawFn = (ctx, w, h, t) => {
  const blue: [number, number, number] = [0.2, 0.6, 0.85];
  const lightBlue: [number, number, number] = [0.4, 0.75, 0.95];
  const foam: [number, number, number] = [0.85, 0.95, 1.0];

  for (let wave = 0; wave < 4; wave++) {
    const baseY = h * (0.55 + wave * 0.1);
    const speed = 0.3 + wave * 0.1;
    const amplitude = 20 - wave * 3;
    ctx.beginPath();
    ctx.moveTo(0, h);
    for (let x = 0; x <= w; x += 3) {
      const y =
        baseY +
        Math.sin(x * 0.008 + t * speed + wave * 1.5) * amplitude +
        Math.cos(x * 0.012 + t * speed * 0.7) * amplitude * 0.5;
      ctx.lineTo(x, y);
    }
    ctx.lineTo(w, h);
    ctx.closePath();
    ctx.fillStyle = col(blue[0], blue[1], blue[2], 0.04 - wave * 0.006);
    ctx.fill();
  }

  for (let i = 0; i < 10; i++) {
    const seed = i * 97.3;
    const x = (i / 10) * w + Math.sin(t * 0.3 + seed) * 20;
    const floatSpeed = 6 + fmod(seed * 5.3, 10);
    const y = h - fmod(t * floatSpeed + seed * 37.1, h + 40) + 20;
    const r = 3 + fmod(seed * 2.1, 5);
    ctx.strokeStyle = col(lightBlue[0], lightBlue[1], lightBlue[2], 0.12);
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.stroke();
    ctx.fillStyle = col(foam[0], foam[1], foam[2], 0.15);
    ctx.beginPath();
    ctx.arc(x - r * 0.3 + r * 0.15, y - r * 0.5 + r * 0.15, r * 0.15, 0, PI * 2);
    ctx.fill();
  }

  for (let i = 0; i < 3; i++) {
    const seed = i * 131.7;
    const baseX = w * (0.2 + i * 0.3);
    const sway = Math.sin(t * 0.2 + seed) * 25;
    ctx.fillStyle = col(foam[0], foam[1], foam[2], 0.015);
    ctx.beginPath();
    ctx.moveTo(baseX + sway - 8, 0);
    ctx.lineTo(baseX + sway + 8, 0);
    ctx.lineTo(baseX + sway + 50, h * 0.7);
    ctx.lineTo(baseX + sway - 50, h * 0.7);
    ctx.closePath();
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Neon Cyber — perspective grid, neon blobs, digital rain             */
/* ------------------------------------------------------------------ */
const drawNeonCyber: DrawFn = (ctx, w, h, t) => {
  const pink: [number, number, number] = [0.95, 0.2, 0.6];
  const cyan: [number, number, number] = [0.0, 0.95, 0.9];
  const gridSpacing = 35;
  const scrollOffset = fmod(t * 20, gridSpacing);

  for (let i = 0; i < 10; i++) {
    const y = h * 0.6 + i * gridSpacing * 0.5 + scrollOffset * 0.5;
    if (y < h) {
      const opacity = Math.max(0, 0.06 - i * 0.004);
      ctx.strokeStyle = col(pink[0], pink[1], pink[2], opacity);
      ctx.lineWidth = 0.6;
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(w, y);
      ctx.stroke();
    }
  }

  for (let x = 0; x <= w; x += gridSpacing) {
    ctx.strokeStyle = col(pink[0], pink[1], pink[2], 0.04);
    ctx.lineWidth = 0.5;
    ctx.beginPath();
    ctx.moveTo(x, h * 0.6);
    ctx.lineTo(x, h);
    ctx.stroke();
  }

  for (let i = 0; i < 6; i++) {
    const seed = i * 107.3;
    const x = (Math.sin(t * 0.15 + seed) * 0.5 + 0.5) * w;
    const baseY = (i / 6) * h * 0.5;
    const y = baseY + Math.sin(t * 0.3 + seed * 0.7) * 25;
    const radius = 15 + (i % 3) * 10;
    const c = i % 2 === 0 ? pink : cyan;
    const opacity = 0.04 + Math.sin(t * 0.5 + seed) * 0.02;
    ctx.fillStyle = col(c[0], c[1], c[2], Math.max(0, opacity));
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();
  }

  for (let i = 0; i < 12; i++) {
    const seed = i * 73.1;
    const x = (i / 12) * w + Math.sin(seed * 1.7) * w * 0.03;
    const speed = 25 + fmod(seed * 9.1, 20);
    const y = fmod(t * speed + seed * 41.7, h + 20) - 10;
    const dh = 4 + (i % 3) * 3;
    const c = i % 3 === 0 ? cyan : pink;
    ctx.fillStyle = col(c[0], c[1], c[2], 0.12);
    ctx.fillRect(x, y, 1.5, dh);
  }
};

/* ------------------------------------------------------------------ */
/* Korean Traditional — hanji fibers, warm glow, dancheong dots        */
/* ------------------------------------------------------------------ */
const drawKorean: DrawFn = (ctx, w, h, t) => {
  const red: [number, number, number] = [0.78, 0.22, 0.28];
  const blue: [number, number, number] = [0.2, 0.35, 0.6];
  const warm: [number, number, number] = [0.85, 0.65, 0.15];

  for (let i = 0; i < 10; i++) {
    const seed = i * 113.7;
    const x = (i / 10) * w + Math.sin(t * 0.12 + seed) * 18;
    const floatSpeed = 4 + fmod(seed * 3.7, 6);
    const y = h - fmod(t * floatSpeed + seed * 47.3, h + 35) + 18;
    const rotation = t * 0.1 + seed;
    ctx.save();
    ctx.globalAlpha = 0.08;
    ctx.translate(x, y);
    ctx.rotate(rotation);
    ctx.strokeStyle = col(warm[0], warm[1], warm[2], 1);
    ctx.lineWidth = 0.6;
    ctx.beginPath();
    ctx.moveTo(-8, 0);
    ctx.quadraticCurveTo(0, -4, 8, 0);
    ctx.stroke();
    ctx.restore();
  }

  for (let i = 0; i < 4; i++) {
    const seed = i * 179.3;
    const x = (i / 4) * w + Math.sin(seed * 1.5) * w * 0.08;
    const y = (i / 4) * h + Math.sin(seed * 2.1) * h * 0.08;
    const r = 35 + fmod(seed * 5.3, 30);
    const pulse = Math.sin(t * 0.2 + seed) * 0.01;
    ctx.fillStyle = col(warm[0], warm[1], warm[2], 0.03 + pulse);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, PI * 2);
    ctx.fill();
  }

  const dotColors = [red, blue, warm];
  for (let i = 0; i < 3; i++) {
    const seed = i * 97.1;
    const x = (i / 3) * w + Math.sin(seed * 1.3) * w * 0.06;
    const y = i % 2 === 0 ? 15 : h - 15;
    const c = dotColors[i];
    ctx.fillStyle = col(c[0], c[1], c[2], 0.06);
    ctx.beginPath();
    ctx.arc(x, y, 4, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Rainy Day — fast rain streaks, puddle ripples, mist                 */
/* (Canvas port of the SpriteKit RainScene, kept lightweight)          */
/* ------------------------------------------------------------------ */
const drawRainy: DrawFn = (ctx, w, h, t) => {
  const blue: [number, number, number] = [0.5, 0.65, 0.8];
  const gray: [number, number, number] = [0.55, 0.6, 0.68];

  const dropCount = 50;
  for (let i = 0; i < dropCount; i++) {
    const ratio = i / dropCount;
    const seed = i * 67.3;
    const x = ratio * w + Math.sin(seed * 3.7) * w * 0.04;
    const windDrift = Math.sin(t * 0.3 + seed) * 8;
    const speed = 80 + fmod(seed * 11.3, 60);
    const y = fmod(t * speed + seed * 53.1, h + 40) - 20;
    const dh = 12 + fmod(seed * 2.3, 16);
    const opacity = 0.15 + fmod(seed * 0.02, 0.1);
    ctx.strokeStyle = col(blue[0], blue[1], blue[2], opacity);
    ctx.lineWidth = 1.2;
    ctx.beginPath();
    ctx.moveTo(x + windDrift, y);
    ctx.lineTo(x + windDrift + 2, y + dh);
    ctx.stroke();
  }

  for (let i = 0; i < 8; i++) {
    const cx = (w * (i + 0.5)) / 8;
    const cy = h * (0.85 + (i % 3) * 0.04);
    const seed = i * 151.7;
    const ripplePhase = fmod(t * 1.2 + seed, 2.5) / 2.5;
    const r = ripplePhase * 25;
    const opacity = 0.12 * (1 - ripplePhase);
    ctx.strokeStyle = col(blue[0], blue[1], blue[2], opacity);
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.ellipse(cx, cy, r, r * 0.4, 0, 0, PI * 2);
    ctx.stroke();
  }

  for (let i = 0; i < 4; i++) {
    const x = (w * (i + 0.5)) / 4;
    const y = h * (0.25 + i * 0.15);
    const seed = i * 127.3;
    const drift = Math.sin(t * 0.15 + seed) * 30;
    const r = 55 + fmod(seed * 3.1, 35);
    ctx.fillStyle = col(gray[0], gray[1], gray[2], 0.05);
    ctx.beginPath();
    ctx.ellipse(x + drift, y, r, r * 0.3, 0, 0, PI * 2);
    ctx.fill();
  }
};

/* ------------------------------------------------------------------ */
/* Lavender — falling petals, glowing orbs, sparkles                   */
/* ------------------------------------------------------------------ */
const drawLavender: DrawFn = (ctx, w, h, t) => {
  const purple: [number, number, number] = [0.6, 0.4, 0.8];
  const lightPurple: [number, number, number] = [0.75, 0.6, 0.9];

  const petalCount = 18;
  for (let i = 0; i < petalCount; i++) {
    const ratio = i / petalCount;
    const seed = i * 97.3;
    const baseX = ratio * w + Math.sin(seed * 2.3) * w * 0.05;
    const fallSpeed = 10 + fmod(seed * 7.3, 15);
    const y = fmod(t * fallSpeed + seed * 43.7, h + 35) - 18;
    const x = baseX + Math.sin(t * 0.3 + seed) * 35;
    const rotation = t * 0.25 + seed;
    const c = i % 3 === 0 ? lightPurple : purple;
    ctx.save();
    ctx.globalAlpha = 0.2;
    ctx.translate(x, y);
    ctx.rotate(rotation);
    ctx.fillStyle = col(c[0], c[1], c[2], 1);
    ctx.beginPath();
    ctx.ellipse(0, 0, 4, 6, 0, 0, PI * 2);
    ctx.fill();
    ctx.restore();
  }

  for (let i = 0; i < 5; i++) {
    const seed = i * 157.3;
    const x = (Math.sin(t * 0.15 + seed) * 0.5 + 0.5) * w;
    const baseY = (i / 5) * h;
    const y = baseY + Math.sin(t * 0.3 + seed * 0.6) * 20;
    const radius = 18 + (i % 3) * 10;
    const opacity = 0.04 + Math.sin(t * 0.4 + seed) * 0.02;
    ctx.fillStyle = col(purple[0], purple[1], purple[2], Math.max(0, opacity));
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, PI * 2);
    ctx.fill();
  }

  for (let i = 0; i < 6; i++) {
    const seed = i * 137.5;
    const x = (i / 6) * w + Math.sin(seed * 1.9) * w * 0.06;
    const y = (i / 6) * h * 0.8 + Math.sin(seed * 2.7) * h * 0.08;
    const twinkle = (Math.sin(t * 2 + seed * 3.1) + 1) * 0.5;
    const s = 2 + twinkle * 3;
    const opacity = 0.08 + twinkle * 0.12;
    ctx.strokeStyle = col(lightPurple[0], lightPurple[1], lightPurple[2], opacity);
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.moveTo(x - s, y);
    ctx.lineTo(x + s, y);
    ctx.moveTo(x, y - s);
    ctx.lineTo(x, y + s);
    ctx.stroke();
  }
};

const noop: DrawFn = () => {};

const DRAW_BY_THEME: Record<ThemeKey, DrawFn> = {
  minimal: noop,
  halloween: drawHalloween,
  christmas: drawSnowfall,
  space: drawSpace,
  cherryBlossom: drawCherryBlossom,
  retroGame: drawRetro,
  autumn: drawAutumn,
  aurora: drawAurora,
  circus: drawCircus,
  desert: drawDesert,
  candy: drawCandy,
  zenGarden: drawZenGarden,
  forsythia: drawForsythia,
  ocean: drawOcean,
  neonCyber: drawNeonCyber,
  korean: drawKorean,
  rainyDay: drawRainy,
  lavender: drawLavender,
};

export function ThemeParticleScene({ theme }: { theme: Theme }) {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const themeKeyRef = useRef<ThemeKey>(theme.key);
  themeKeyRef.current = theme.key;

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const parent = canvas.parentElement;
    if (!parent) return;

    let dpr = Math.min(window.devicePixelRatio || 1, 2);
    let cssW = 0;
    let cssH = 0;

    const reduceMotion = window.matchMedia(
      '(prefers-reduced-motion: reduce)',
    );

    function resize() {
      if (!canvas || !ctx) return;
      const rect = parent!.getBoundingClientRect();
      cssW = Math.max(1, rect.width);
      cssH = Math.max(1, rect.height);
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      canvas.width = Math.round(cssW * dpr);
      canvas.height = Math.round(cssH * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    resize();

    let ro: ResizeObserver | null = null;
    if (typeof ResizeObserver !== 'undefined') {
      ro = new ResizeObserver(() => resize());
      ro.observe(parent);
    } else {
      window.addEventListener('resize', resize);
    }

    const start = performance.now();
    let rafId = 0;

    function frame(now: number) {
      if (!ctx) return;
      // Elapsed seconds. When reduced-motion is requested, advance the clock
      // very slowly so the scene is nearly static but not frozen.
      const elapsed = (now - start) / 1000;
      const t = reduceMotion.matches ? elapsed * 0.1 : elapsed;

      ctx.clearRect(0, 0, cssW, cssH);
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';
      const draw = DRAW_BY_THEME[themeKeyRef.current] ?? noop;
      draw(ctx, cssW, cssH, t);

      rafId = requestAnimationFrame(frame);
    }
    rafId = requestAnimationFrame(frame);

    return () => {
      cancelAnimationFrame(rafId);
      if (ro) ro.disconnect();
      else window.removeEventListener('resize', resize);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      aria-hidden
      style={{
        position: 'absolute',
        inset: 0,
        width: '100%',
        height: '100%',
        pointerEvents: 'none',
        zIndex: 0,
      }}
    />
  );
}
