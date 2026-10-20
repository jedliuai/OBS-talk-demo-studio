import React from "react";
import {AbsoluteFill, staticFile} from "remotion";
import {CARD, LOGO} from "./layout";

const FONT = '"Noto Sans SC", "Microsoft YaHei UI", sans-serif';

export const Grain: React.FC<{opacity: number; blend: React.CSSProperties["mixBlendMode"]}> = ({
  opacity,
  blend,
}) => (
  <AbsoluteFill
    style={{
      backgroundImage: `url(${staticFile("grain.png")})`,
      backgroundSize: "512px 512px",
      opacity,
      mixBlendMode: blend,
    }}
  />
);

// The "jed" wordmark, tinted with CSS masks so each theme can colour strokes and dot.
export const Logo: React.FC<{
  width: number;
  stroke: string;
  dot: string;
  dotStyle?: React.CSSProperties;
  style?: React.CSSProperties;
}> = ({width, stroke, dot, dotStyle, style}) => {
  const k = width / LOGO.w;
  const mask = `url(${staticFile("jed-strokes-mask.png")})`;
  return (
    <div style={{position: "absolute", width, height: LOGO.h * k, ...style}}>
      <div
        style={{
          position: "absolute",
          inset: 0,
          background: stroke,
          WebkitMaskImage: mask,
          maskImage: mask,
          WebkitMaskSize: "100% 100%",
          maskSize: "100% 100%",
        }}
      />
      <div
        style={{
          position: "absolute",
          left: (LOGO.dot.cx - LOGO.dot.r) * k,
          top: (LOGO.dot.cy - LOGO.dot.r) * k,
          width: LOGO.dot.r * 2 * k,
          height: LOGO.dot.r * 2 * k,
          borderRadius: "50%",
          background: dot,
          ...dotStyle,
        }}
      />
    </div>
  );
};

export const Header: React.FC<{name: string; tag: string; rule: string; dot: string}> = ({
  name,
  tag,
  rule,
  dot,
}) => (
  <div
    style={{
      position: "absolute",
      left: CARD.x + 14,
      top: 0,
      height: CARD.y,
      display: "flex",
      alignItems: "center",
      gap: 20,
      fontFamily: FONT,
    }}
  >
    <div style={{width: 14, height: 14, borderRadius: "50%", background: dot}} />
    <div style={{fontSize: 30, fontWeight: 700, color: name, letterSpacing: 0.5}}>杰德哥Jed</div>
    <div style={{width: 2, height: 26, background: rule}} />
    <div style={{fontSize: 26, fontWeight: 400, color: tag, letterSpacing: 1}}>AI × 职场打工人</div>
  </div>
);

export const Card: React.FC<{style: React.CSSProperties}> = ({style}) => (
  <div
    style={{
      position: "absolute",
      left: CARD.x,
      top: CARD.y,
      width: CARD.w,
      height: CARD.h,
      borderRadius: CARD.radius,
      ...style,
    }}
  />
);
